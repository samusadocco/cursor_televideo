import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cursor_televideo/core/analytics/analytics_service.dart';
import 'package:cursor_televideo/core/iap/iap_product.dart';

/// Stub IAP per simulatore iOS / build WebView (senza in_app_purchase).
class IAPService {
  static const String _isPremiumKey = 'is_premium_user';
  static const String _adsOnlyKey = 'premium_ads_only_mode';

  final SharedPreferences _prefs;
  final _premiumStatusController = StreamController<bool>.broadcast();

  bool _isInitialized = false;

  IAPService(this._prefs);

  Stream<bool> get premiumStatusStream => _premiumStatusController.stream;
  bool get isInitialized => _isInitialized;
  List<IAPProduct> get products => const [];

  Future<bool> initialize() async {
    print('[IAPService] Stub WebView/simulator - store IAP non disponibile');
    try {
      final currentStatus = isPremium();
      await AnalyticsService().setSubscriptionStatus(currentStatus);
    } catch (e) {
      print('[IAPService] Error initializing analytics status: $e');
    }
    _isInitialized = true;
    return false;
  }

  Future<void> reloadProducts() async {}

  List<IAPProduct> getAllProducts() => const [];

  IAPProduct? getMonthlyProduct() => null;
  IAPProduct? getQuarterlyProduct() => null;
  IAPProduct? getProductById(String productId) => null;

  @Deprecated('Use getMonthlyProduct() or getQuarterlyProduct()')
  IAPProduct? getPremiumProduct() => null;

  bool isPremium() {
    if (_prefs.getBool(_adsOnlyKey) == true) return false;
    return _prefs.getBool(_isPremiumKey) ?? false;
  }

  bool isAdsOnlyMode() => _prefs.getBool(_adsOnlyKey) == true;
  bool hasActiveSubscription() => _prefs.getBool(_isPremiumKey) ?? false;

  Future<void> setAdsOnlyMode(bool enabled) async {
    await _prefs.setBool(_adsOnlyKey, enabled);
    _premiumStatusController.add(isPremium());
  }

  Future<bool> purchasePremium({String? productId}) async {
    print('[IAPService] Stub WebView/simulator - acquisto non disponibile');
    return false;
  }

  Future<void> restorePurchases() async {
    print('[IAPService] Stub WebView/simulator - restore non disponibile');
  }

  void dispose() {
    _premiumStatusController.close();
  }

  @visibleForTesting
  Future<void> setPremiumStatusForTesting(bool isPremium) async {
    await _prefs.setBool(_isPremiumKey, isPremium);
    _premiumStatusController.add(isPremium);
    print('[IAPService] Premium status set to $isPremium (testing)');
  }

  @visibleForTesting
  Future<void> clearPremiumStatus() async {
    await _prefs.remove(_isPremiumKey);
    _premiumStatusController.add(false);
    print('[IAPService] Premium status cleared (testing)');
  }
}
