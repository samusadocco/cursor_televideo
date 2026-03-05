import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cursor_televideo/core/analytics/analytics_service.dart';

/// Servizio per gestire gli In-App Purchase
/// 
/// Gestisce gli abbonamenti (mensile e trimestrale) per rimuovere la pubblicità e sbloccare funzionalità premium
class IAPService {
  // Product IDs per i diversi piani di abbonamento
  static const String _monthlyProductId = 'premium_subscription_monthly';
  static const String _quarterlyProductId = 'premium_subscription_quarterly2';
  
  static const String _isPremiumKey = 'is_premium_user';
  
  // Lista di tutti i product IDs
  static const Set<String> _allProductIds = {
    _monthlyProductId,
    _quarterlyProductId,
  };
  
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  
  final SharedPreferences _prefs;
  
  // Stream per notificare cambiamenti nello stato premium
  final _premiumStatusController = StreamController<bool>.broadcast();
  Stream<bool> get premiumStatusStream => _premiumStatusController.stream;
  
  // Prodotti disponibili
  List<ProductDetails> _products = [];
  List<ProductDetails> get products => _products;
  
  // Stato inizializzazione
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;
  
  IAPService(this._prefs);
  
  /// Inizializza il servizio IAP
  Future<bool> initialize() async {
    try {
      print('[IAPService] Initializing...');
      
      // Verifica disponibilità IAP
      final bool available = await _inAppPurchase.isAvailable();
      if (!available) {
        print('[IAPService] Store not available');
        _isInitialized = false;
        return false;
      }
      
      print('[IAPService] Store is available');
      
      // Configura listener per gli acquisti
      _subscription = _inAppPurchase.purchaseStream.listen(
        _onPurchaseUpdate,
        onDone: () => _subscription.cancel(),
        onError: (error) => print('[IAPService] Purchase stream error: $error'),
      );
      
      // Configura delegate per App Store Promotion (iOS)
      // Gestisce acquisti avviati direttamente dalla pagina prodotto nell'App Store
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        final iosPlatformAddition = _inAppPurchase
            .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
        await iosPlatformAddition.setDelegate(_AppStorePromotionDelegate());
        print('[IAPService] App Store Promotion delegate registered');
      }
      
      // Carica i prodotti
      await _loadProducts();
      
      // Ripristina acquisti precedenti
      await restorePurchases();
      
      // Inizializza lo stato subscription in Firebase Analytics
      try {
        final currentStatus = isPremium();
        await AnalyticsService().setSubscriptionStatus(currentStatus);
        print('[IAPService] Analytics initialized with subscription status: ${currentStatus ? "premium" : "free"}');
      } catch (e) {
        print('[IAPService] Error initializing analytics status: $e');
      }
      
      _isInitialized = true;
      print('[IAPService] Initialized successfully');
      return true;
    } catch (e) {
      print('[IAPService] Initialization error: $e');
      _isInitialized = false;
      return false;
    }
  }
  
  /// Carica i prodotti dallo store
  Future<void> _loadProducts() async {
    try {
      print('[IAPService] Loading products...');
      
      final ProductDetailsResponse response = 
          await _inAppPurchase.queryProductDetails(_allProductIds);
      
      if (response.error != null) {
        print('[IAPService] Error loading products: ${response.error}');
        
        // In modalità debug, fornisci più informazioni
        if (kDebugMode) {
          print('[IAPService] ERROR DETAILS:');
          print('  - Code: ${response.error?.code}');
          print('  - Message: ${response.error?.message}');
          print('  - Details: ${response.error?.details}');
        }
        return;
      }
      
      if (response.notFoundIDs.isNotEmpty) {
        print('[IAPService] ⚠️ Products not found: ${response.notFoundIDs}');
        print('[IAPService] Questi Product IDs devono essere configurati su App Store Connect / Google Play Console');
      }
      
      _products = response.productDetails;
      print('[IAPService] Loaded ${_products.length} products');
      
      if (_products.isEmpty) {
        print('[IAPService] ❌ NESSUN PRODOTTO CARICATO!');
        print('[IAPService] Verifica:');
        print('  1. I prodotti sono configurati negli store?');
        print('  2. Stai usando un dispositivo reale (non simulatore)?');
        print('  3. I Product IDs corrispondono?');
        print('     - Richiesti: $_allProductIds');
      }
      
      for (final product in _products) {
        print('[IAPService] ✅ Product: ${product.id} - ${product.title} - ${product.price}');
      }
    } catch (e) {
      print('[IAPService] Error loading products: $e');
    }
  }
  
  /// Gestisce gli aggiornamenti degli acquisti
  Future<void> _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      print('[IAPService] Purchase update: ${purchaseDetails.status}');
      
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          print('[IAPService] Purchase pending...');
          break;
          
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          final isPurchased = purchaseDetails.status == PurchaseStatus.purchased;
          print('[IAPService] Purchase ${isPurchased ? "completed" : "restored"}');
          
          // Verifica l'acquisto (importante per sicurezza)
          bool valid = await _verifyPurchase(purchaseDetails);
          
          if (valid) {
            // Sblocca le funzionalità premium
            await _unlockPremium();
            print('[IAPService] Premium unlocked!');
            
            // Log evento in Firebase Analytics
            try {
              // Trova il prodotto corretto in base al productID
              final product = getProductById(purchaseDetails.productID);
              
              // Determina il tipo di piano per analytics
              String planType = 'unknown';
              if (purchaseDetails.productID == _monthlyProductId) {
                planType = 'monthly';
              } else if (purchaseDetails.productID == _quarterlyProductId) {
                planType = 'quarterly';
              }
              
              await AnalyticsService().logSubscriptionEvent(
                isPurchased ? 'subscription_purchased' : 'subscription_restored',
                subscriptionId: purchaseDetails.productID,
                price: product?.price,
                currency: product?.currencyCode,
                additionalParams: {
                  'platform': purchaseDetails.verificationData.source,
                  'transaction_id': purchaseDetails.purchaseID ?? 'unknown',
                  'plan_type': planType,
                },
              );
            } catch (e) {
              print('[IAPService] Error logging analytics event: $e');
            }
          }
          
          // Completa l'acquisto
          if (purchaseDetails.pendingCompletePurchase) {
            await _inAppPurchase.completePurchase(purchaseDetails);
          }
          break;
          
        case PurchaseStatus.error:
          print('[IAPService] Purchase error: ${purchaseDetails.error}');
          break;
          
        case PurchaseStatus.canceled:
          print('[IAPService] Purchase canceled');
          break;
      }
    }
  }
  
  /// Verifica la validità dell'acquisto
  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    // TODO: In produzione, implementare verifica server-side
    // Per ora accettiamo tutti gli acquisti come validi
    // 
    // IMPORTANTE: Per la sicurezza in produzione, dovresti:
    // 1. Inviare il receipt al tuo server
    // 2. Il server verifica il receipt con Apple/Google
    // 3. Il server ti dice se è valido
    
    print('[IAPService] Verifying purchase...');
    
    // iOS: purchaseDetails.verificationData.serverVerificationData contiene il receipt
    // Android: purchaseDetails.verificationData.serverVerificationData contiene il purchase token
    
    return true;
  }
  
  /// Sblocca le funzionalità premium
  Future<void> _unlockPremium() async {
    await _prefs.setBool(_isPremiumKey, true);
    _premiumStatusController.add(true);
    
    // Aggiorna lo stato in Firebase Analytics
    try {
      await AnalyticsService().setSubscriptionStatus(true);
    } catch (e) {
      print('[IAPService] Error updating analytics: $e');
    }
    
    print('[IAPService] Premium features unlocked');
  }
  
  /// Verifica se l'utente è premium
  bool isPremium() {
    return _prefs.getBool(_isPremiumKey) ?? false;
  }
  
  /// Ottiene il prodotto mensile
  ProductDetails? getMonthlyProduct() {
    try {
      return _products.firstWhere((p) => p.id == _monthlyProductId);
    } catch (e) {
      return null;
    }
  }
  
  /// Ottiene il prodotto trimestrale
  ProductDetails? getQuarterlyProduct() {
    try {
      return _products.firstWhere((p) => p.id == _quarterlyProductId);
    } catch (e) {
      return null;
    }
  }
  
  /// Ottiene un prodotto specifico per ID
  ProductDetails? getProductById(String productId) {
    try {
      return _products.firstWhere((p) => p.id == productId);
    } catch (e) {
      return null;
    }
  }
  
  /// Ottiene tutti i prodotti disponibili
  List<ProductDetails> getAllProducts() {
    return _products;
  }
  
  /// [Deprecated] Usa getQuarterlyProduct() invece
  @Deprecated('Use getMonthlyProduct() or getQuarterlyProduct()')
  ProductDetails? getPremiumProduct() {
    return getQuarterlyProduct();
  }
  
  /// Avvia l'acquisto di un abbonamento premium
  /// Se [productId] non è specificato, usa il trimestrale come default
  Future<bool> purchasePremium({String? productId}) async {
    try {
      if (!_isInitialized) {
        print('[IAPService] Service not initialized');
        return false;
      }
      
      // Se non specificato, usa il trimestrale come default per retrocompatibilità
      final targetProductId = productId ?? _quarterlyProductId;
      
      final product = getProductById(targetProductId);
      if (product == null) {
        print('[IAPService] Product not found: $targetProductId');
        return false;
      }
      
      print('[IAPService] Starting subscription purchase for: ${product.id}');
      
      // Crea parametri d'acquisto per abbonamento
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: product,
      );
      
      // Avvia l'acquisto dell'abbonamento
      // buyNonConsumable funziona anche per gli abbonamenti su entrambe le piattaforme
      final bool success = await _inAppPurchase.buyNonConsumable(
        purchaseParam: purchaseParam,
      );
      
      print('[IAPService] Subscription purchase initiated: $success');
      return success;
    } catch (e) {
      print('[IAPService] Purchase error: $e');
      return false;
    }
  }
  
  /// Ripristina gli acquisti precedenti (per cambio dispositivo, reinstallazione, ecc.)
  Future<void> restorePurchases() async {
    try {
      print('[IAPService] Restoring purchases...');
      
      // Richiede esplicitamente il restore
      // Questo funziona sia per iOS che per Android
      // Su iOS, mostra un dialogo di conferma
      // Su Android, ricarica gli acquisti dal Play Store
      await _inAppPurchase.restorePurchases();
      
      print('[IAPService] Restore completed');
    } catch (e) {
      print('[IAPService] Restore error: $e');
    }
  }
  
  /// Pulisce e chiude il servizio
  void dispose() {
    _subscription.cancel();
    _premiumStatusController.close();
  }
  
  /// Metodo per testing: attiva lo stato premium manualmente (solo per development)
  @visibleForTesting
  Future<void> setPremiumStatusForTesting(bool isPremium) async {
    await _prefs.setBool(_isPremiumKey, isPremium);
    _premiumStatusController.add(isPremium);
    print('[IAPService] Premium status set to $isPremium (testing)');
  }
  
  /// Metodo per testing: rimuove lo stato premium (solo per development)
  @visibleForTesting
  Future<void> clearPremiumStatus() async {
    await _prefs.remove(_isPremiumKey);
    _premiumStatusController.add(false);
    print('[IAPService] Premium status cleared (testing)');
  }
}

/// Delegate per supportare la Promozione sull'App Store (iOS).
/// 
/// Quando un utente tocca un abbonamento promosso direttamente nell'App Store,
/// iOS chiama shouldContinueTransaction per decidere se procedere con l'acquisto.
/// Restituendo true, l'acquisto viene gestito normalmente dal purchaseStream.
class _AppStorePromotionDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
    SKPaymentTransactionWrapper transaction,
    SKStorefrontWrapper storefront,
  ) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
