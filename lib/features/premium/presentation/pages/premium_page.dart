import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cursor_televideo/core/iap/iap_service.dart';
import 'package:cursor_televideo/core/iap/iap_product.dart';
import 'package:cursor_televideo/core/l10n/app_localizations.dart';

/// Pagina per gestire l'acquisto Premium
class PremiumPage extends StatefulWidget {
  final IAPService iapService;

  const PremiumPage({
    super.key,
    required this.iapService,
  });

  @override
  State<PremiumPage> createState() => _PremiumPageState();
}

enum SubscriptionPlan { monthly, quarterly }

class _PremiumPageState extends State<PremiumPage> {
  bool _isLoading = false;
  bool _isLoadingProducts = false;
  String? _errorMessage;
  SubscriptionPlan _selectedPlan = SubscriptionPlan.quarterly; // Default: trimestrale (miglior valore)
  Timer? _cheatTimer; // pressione 3 sec su ripristina → modalità solo pubblicità
  
  @override
  void initState() {
    super.initState();
    // Se i prodotti non sono caricati, ritenta automaticamente (fix per revisione Apple)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!widget.iapService.isPremium() &&
          widget.iapService.getAllProducts().isEmpty &&
          !_isLoadingProducts) {
        _retryLoadProducts();
      }
    });
  }

  @override
  void dispose() {
    _cheatTimer?.cancel();
    super.dispose();
  }

  void _startCheatTimer() {
    _cheatTimer?.cancel();
    _cheatTimer = Timer(const Duration(seconds: 3), () async {
      await widget.iapService.setAdsOnlyMode(true);
      if (mounted) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Modalità solo pubblicità attivata'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    });
  }

  void _cancelCheatTimer() {
    _cheatTimer?.cancel();
    _cheatTimer = null;
  }
  
  /// Ritenta il caricamento prodotti con delay (risolve timing durante revisione)
  Future<void> _retryLoadProducts() async {
    if (!mounted) return;
    setState(() => _isLoadingProducts = true);
    
    for (int attempt = 0; attempt < 3 && mounted; attempt++) {
      await widget.iapService.reloadProducts();
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted && widget.iapService.getAllProducts().isNotEmpty) {
        break;
      }
    }
    
    if (mounted) {
      setState(() => _isLoadingProducts = false);
    }
  }
  
  /// Calcola il prezzo mensile equivalente
  String _calculateMonthlyPrice(String price, int months) {
    // Estrae il numero dal prezzo (es. "€2.99" -> 2.99)
    final numericPrice = price.replaceAll(RegExp(r'[^\d.,]'), '');
    try {
      final priceValue = double.parse(numericPrice.replaceAll(',', '.'));
      final monthlyPrice = priceValue / months;
      
      // Estrae il simbolo della valuta
      final currencySymbol = price.replaceAll(RegExp(r'[\d.,\s]'), '');
      
      return '$currencySymbol${monthlyPrice.toStringAsFixed(2)}';
    } catch (e) {
      return price;
    }
  }
  
  /// Calcola il risparmio percentuale del trimestrale rispetto al mensile
  String? _calculateSavings(IAPProduct? monthly, IAPProduct? quarterly) {
    if (monthly == null || quarterly == null) return null;
    
    try {
      final monthlyNumeric = monthly.price.replaceAll(RegExp(r'[^\d.,]'), '');
      final quarterlyNumeric = quarterly.price.replaceAll(RegExp(r'[^\d.,]'), '');
      
      final monthlyPrice = double.parse(monthlyNumeric.replaceAll(',', '.'));
      final quarterlyPrice = double.parse(quarterlyNumeric.replaceAll(',', '.'));
      
      final monthlyTotal = monthlyPrice * 3; // 3 mesi
      final savings = ((monthlyTotal - quarterlyPrice) / monthlyTotal * 100).round();
      
      return savings > 0 ? '$savings%' : null;
    } catch (e) {
      return null;
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.errorOpeningLink)),
      );
    }
  }

  Widget _buildLegalLink(BuildContext context, String label, String url) {
    return GestureDetector(
      onTap: () => _launchUrl(url),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.blue[700],
          decoration: TextDecoration.underline,
          decorationColor: Colors.blue[700],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isPremium = widget.iapService.isPremium();
    final monthlyProduct = widget.iapService.getMonthlyProduct();
    final quarterlyProduct = widget.iapService.getQuarterlyProduct();
    final hasProducts = monthlyProduct != null || quarterlyProduct != null;
    
    // Debug info
    print('🔍 [PremiumPage] isPremium: $isPremium');
    print('🔍 [PremiumPage] hasProducts: $hasProducts');
    print('🔍 [PremiumPage] monthlyProduct: ${monthlyProduct?.id}');
    print('🔍 [PremiumPage] quarterlyProduct: ${quarterlyProduct?.id}');
    print('🔍 [PremiumPage] all products count: ${widget.iapService.getAllProducts().length}');

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.premiumTitle),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header con icona
            const SizedBox(height: 20),
            const Icon(
              Icons.star_rounded,
              size: 80,
              color: Colors.amber,
            ),
            const SizedBox(height: 16),
            
            // Titolo
            Text(
              l10n.premiumFeatures,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            
            // Sottotitolo
            Text(
              l10n.premiumSubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // Lista dei benefici
            _buildFeatureItem(
              context,
              Icons.block,
              l10n.premiumNoAds,
              l10n.premiumNoAdsDescription,
            ),
            const SizedBox(height: 16),
            
            _buildFeatureItem(
              context,
              Icons.speed,
              l10n.premiumFasterExperience,
              l10n.premiumFasterExperienceDescription,
            ),
            const SizedBox(height: 16),
            
            _buildFeatureItem(
              context,
              Icons.support,
              l10n.premiumSupportDevelopment,
              l10n.premiumSupportDevelopmentDescription,
            ),
            const SizedBox(height: 32),
            
            // Stato utente
            if (isPremium) ...[
              // Utente già premium
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green, width: 2),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.premiumActivated,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            l10n.premiumThankYou,
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Pulsante ripristina acquisti (cheat: long press 3 sec → modalità solo pubblicità)
              Listener(
                onPointerDown: (_) => _startCheatTimer(),
                onPointerUp: (_) => _cancelCheatTimer(),
                onPointerCancel: (_) => _cancelCheatTimer(),
                child: OutlinedButton.icon(
                  onPressed: _isLoading ? null : _restorePurchases,
                  icon: const Icon(Icons.restore),
                  label: Text(l10n.restorePurchases),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ] else ...[
              // Utente non premium - mostra selezione piano
              if (hasProducts) ...[
                // Selettore piani
                if (monthlyProduct != null && quarterlyProduct != null) ...[
                  // Mostra entrambi i piani
                  Text(
                    l10n.premiumChoosePlan,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  
                  // Piano Mensile
                  _buildPlanCard(
                    context,
                    plan: SubscriptionPlan.monthly,
                    product: monthlyProduct,
                    title: l10n.premiumMonthly,
                    subtitle: _calculateMonthlyPrice(monthlyProduct.price, 1),
                    isSelected: _selectedPlan == SubscriptionPlan.monthly,
                    onTap: () => setState(() => _selectedPlan = SubscriptionPlan.monthly),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Piano Trimestrale (BEST VALUE)
                  _buildPlanCard(
                    context,
                    plan: SubscriptionPlan.quarterly,
                    product: quarterlyProduct,
                    title: l10n.premiumQuarterly,
                    subtitle: '${_calculateMonthlyPrice(quarterlyProduct.price, 3)} ${l10n.premiumPerMonth}',
                    badge: _calculateSavings(monthlyProduct, quarterlyProduct) != null
                        ? l10n.premiumSavePercent(_calculateSavings(monthlyProduct, quarterlyProduct)!)
                        : null,
                    isSelected: _selectedPlan == SubscriptionPlan.quarterly,
                    isBestValue: true,
                    onTap: () => setState(() => _selectedPlan = SubscriptionPlan.quarterly),
                  ),
                ] else if (quarterlyProduct != null) ...[
                  // Mostra solo trimestrale se mensile non disponibile
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.amber[700]!, Colors.amber[400]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.autorenew,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.premiumOneTimePurchase,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          quarterlyProduct.price,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.premiumLifetime,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '≈ ${_calculateMonthlyPrice(quarterlyProduct.price, 3)} ${l10n.premiumPerMonth}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                
                // Pulsante acquisto
                ElevatedButton(
                  onPressed: _isLoading ? null : _purchasePremium,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              l10n.purchasePremium,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (hasProducts) ...[
                              const SizedBox(height: 4),
                            Text(
                              _selectedPlan == SubscriptionPlan.monthly
                                  ? l10n.premiumMonthlyPlan
                                  : l10n.premiumQuarterlyPlan,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ],
                        ),
                ),
                const SizedBox(height: 16),
                
                // Pulsante ripristina acquisti
                TextButton.icon(
                  onPressed: _isLoading ? null : _restorePurchases,
                  icon: const Icon(Icons.restore),
                  label: Text(l10n.restorePurchases),
                ),
              ] else ...[
                // Prodotti non caricati: mostra loading o messaggio con retry
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _isLoadingProducts ? Colors.blue[50] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isLoadingProducts ? Colors.blue[200]! : Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      if (_isLoadingProducts) ...[
                        const SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.premiumLoadingSubscriptions,
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ] else ...[
                        Icon(
                          Icons.cloud_off_outlined,
                          size: 40,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.premiumLoadErrorRetry,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed: _isLoadingProducts ? null : _retryLoadProducts,
                          icon: const Icon(Icons.refresh, size: 18),
                          label: Text(l10n.retry),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
            
            // Messaggio di errore
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red, width: 1),
                ),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
            
            const SizedBox(height: 32),
            
            // Note legali - più prominente per abbonamenti
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!, width: 1),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, size: 16, color: Colors.grey[700]),
                      const SizedBox(width: 8),
                      Text(
                        l10n.premiumSubscriptionInfo,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.premiumLegalNote,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      _buildLegalLink(
                        context,
                        l10n.premiumPrivacyPolicy,
                        'https://www.codebysam.it/teleretro/privacy.html',
                      ),
                      Text(
                        ' • ',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      _buildLegalLink(
                        context,
                        l10n.premiumTermsOfUse,
                        'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFeatureItem(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.amber[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.amber[700], size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildPlanCard(
    BuildContext context, {
    required SubscriptionPlan plan,
    required IAPProduct product,
    required String title,
    required String subtitle,
    String? badge,
    required bool isSelected,
    bool isBestValue = false,
    required VoidCallback onTap,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [Colors.amber[700]!, Colors.amber[400]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.amber[700]! : Colors.grey[300]!,
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            // Badge "BEST VALUE"
            if (isBestValue && badge != null)
              Positioned(
                top: -10,
                right: -10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            
            Row(
              children: [
                // Radio button
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? Colors.white : Colors.grey[400]!,
                      width: 2,
                    ),
                    color: isSelected ? Colors.white : Colors.transparent,
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.amber[700],
                            ),
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                
                // Dettagli piano
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[800],
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: isSelected ? Colors.white70 : Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Prezzo
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      product.price,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[800],
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      plan == SubscriptionPlan.monthly ? l10n.premiumPerMonth : l10n.premiumEvery3Months,
                      style: TextStyle(
                        color: isSelected ? Colors.white70 : Colors.grey[600],
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _purchasePremium() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      // Determina il product ID in base al piano selezionato
      final productId = _selectedPlan == SubscriptionPlan.monthly
          ? 'premium_subscription_monthly'
          : 'premium_subscription_quarterly2';
      
      final success = await widget.iapService.purchasePremium(productId: productId);
      
      if (!success) {
        setState(() {
          _errorMessage = AppLocalizations.of(context)!.premiumPurchaseError;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.premiumPurchaseError;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  Future<void> _restorePurchases() async {
    // Se in modalità solo pubblicità, disattivala al click
    if (widget.iapService.isAdsOnlyMode()) {
      await widget.iapService.setAdsOnlyMode(false);
      if (mounted) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Modalità solo pubblicità disattivata'),
            backgroundColor: Colors.green,
          ),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await widget.iapService.restorePurchases();
      
      if (mounted) {
        // Controlla se ora è premium
        if (widget.iapService.isPremium()) {
          // Mostra messaggio di successo
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.premiumRestoreSuccess),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          // Nessun acquisto trovato
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.premiumRestoreNoPurchases),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = AppLocalizations.of(context)!.premiumRestoreError;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
