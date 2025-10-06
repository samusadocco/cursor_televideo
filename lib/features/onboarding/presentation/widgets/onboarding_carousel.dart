import 'package:flutter/material.dart';
import 'package:cursor_televideo/features/onboarding/presentation/widgets/region_selector_instruction.dart';
import 'package:cursor_televideo/features/onboarding/presentation/widgets/shortcuts_menu_instruction.dart';
import 'package:cursor_televideo/features/onboarding/presentation/widgets/swipe_instructions.dart';
import 'package:cursor_televideo/features/onboarding/presentation/widgets/bottom_bar_instruction.dart';
import 'package:cursor_televideo/features/onboarding/presentation/widgets/bottom_bar_instruction_with_timer.dart';
import 'package:cursor_televideo/features/onboarding/presentation/widgets/favorites_instruction.dart';
import 'package:cursor_televideo/features/onboarding/presentation/widgets/favorites_list_instruction.dart';
import 'package:cursor_televideo/features/onboarding/presentation/widgets/settings_instruction.dart';
import 'package:cursor_televideo/features/onboarding/presentation/widgets/page_links_instruction.dart';
import 'package:cursor_televideo/features/onboarding/presentation/widgets/navigation_arrows_instruction.dart';
import 'package:cursor_televideo/core/onboarding/onboarding_service.dart';
import 'package:cursor_televideo/core/l10n/app_localizations.dart';

class OnboardingCarousel extends StatefulWidget {
  final VoidCallback onDismiss;

  const OnboardingCarousel({
    super.key,
    required this.onDismiss,
  });

  @override
  State<OnboardingCarousel> createState() => _OnboardingCarouselState();
}

class _OnboardingCarouselState extends State<OnboardingCarousel> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _dismissCarousel() {
    _animationController.reverse().then((_) {
      widget.onDismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;
    final l10n = AppLocalizations.of(context)!;

    final dialogWidth = isTablet 
        ? screenSize.width * 0.7
        : screenSize.width * 0.9;
    
    final dialogHeight = isTablet
        ? screenSize.height * 0.8
        : screenSize.height * 0.85;

    final pages = [
      // Pagina di benvenuto
      _buildPage(
        l10n.onboardingWelcome,
        l10n.onboardingWelcomeDescription,
        Icons.tv,
        customContent: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/icons/app_icon.png',
              width: isTablet ? 300 : 200,
              height: isTablet ? 300 : 200,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 24),
          ],
        ),
        contentAfterTitle: true,
      ),
      // Navigazione orizzontale
      _buildPage(
        l10n.onboardingNavigation,
        l10n.onboardingNavigationDescription,
        Icons.arrow_forward,
        customContent: const BottomBarInstruction(
          highlight: BottomBarHighlight.horizontalNavigation,
        ),
        contentAtBottom: true,
      ),
      // Selettore pagine
      _buildPage(
        l10n.onboardingPageSelector,
        l10n.onboardingPageSelectorDescription,
        Icons.numbers,
        customContent: const BottomBarInstruction(
          highlight: BottomBarHighlight.pageSelector,
        ),
        contentAtBottom: true,
      ),
      // Navigazione verticale
      _buildPage(
        l10n.onboardingSubpageNavigation,
        l10n.onboardingSubpageNavigationDescription,
        Icons.arrow_upward,
        customContent: const BottomBarInstructionWithTimer(
          highlight: BottomBarHighlight.verticalNavigation,
        ),
        contentAtBottom: true,
      ),
      // Indicatore di autocaricamento
      _buildPage(
        l10n.onboardingAutoRefresh,
        l10n.onboardingAutoRefreshDescription,
        Icons.timer,
        customContent: const BottomBarInstructionWithTimer(
          highlight: BottomBarHighlight.pageSelector,
        ),
        contentAtBottom: true,
      ),
      // Pausa autocaricamento
      _buildPage(
        l10n.onboardingPause,
        l10n.onboardingPauseDescription,
        Icons.pause_circle_outline,
        customContent: const BottomBarInstructionWithTimer(
          highlight: BottomBarHighlight.pageSelector,
          showPauseOverlay: true,
        ),
        contentAtBottom: true,
      ),
      // Spiegazione swipe
      _buildPage(
        l10n.onboardingSwipe,
        l10n.onboardingSwipeDescription,
        Icons.swipe,
        customContent: const SwipeInstructions(),
      ),
      // Spiegazione numeri cliccabili
      _buildPage(
        l10n.onboardingClickableNumbers,
        l10n.onboardingClickableNumbersDescription,
        Icons.touch_app,
        customContent: const PageLinksInstruction(),
      ),
      // Spiegazione menu shortcuts
      _buildPage(
        l10n.onboardingShortcuts,
        l10n.onboardingShortcutsDescription,
        Icons.menu_book,
        customContent: const ShortcutsMenuInstruction(),
      ),
      // Spiegazione selettore regioni
      _buildPage(
        l10n.onboardingRegions,
        l10n.onboardingRegionsDescription,
        Icons.location_on,
        customContent: const RegionSelectorInstruction(),
      ),
      // Spiegazione preferiti
      _buildPage(
        l10n.onboardingFavorites,
        l10n.onboardingFavoritesDescription,
        Icons.favorite,
        customContent: const FavoritesInstruction(),
        contentAfterTitle: true,
      ),
      // Spiegazione lista preferiti
      _buildPage(
        l10n.onboardingFavoritesList,
        l10n.onboardingFavoritesListDescription,
        Icons.list,
        customContent: const FavoritesListInstruction(),
        contentAfterTitle: true,
      ),
      // Spiegazione impostazioni
      _buildPage(
        l10n.settings,
        l10n.onboardingSettingsDescription,
        Icons.settings,
        customContent: const SettingsInstruction(),
        contentAfterTitle: true,
      ),
    ];

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) => FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.symmetric(
              horizontal: (screenSize.width - dialogWidth) / 2,
              vertical: (screenSize.height - dialogHeight) / 2,
            ),
            child: Container(
              width: dialogWidth,
              height: dialogHeight,
              decoration: BoxDecoration(
                color: Theme.of(context).dialogBackgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        children: pages.map((page) => AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0.05, 0),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              ),
                            );
                          },
                          child: page,
                        )).toList(),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).dialogBackgroundColor,
                      border: Border(
                        top: BorderSide(
                          color: Theme.of(context).dividerColor,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            pages.length,
                            (index) => TweenAnimationBuilder<double>(
                              duration: const Duration(milliseconds: 300),
                              tween: Tween<double>(
                                begin: 0.0,
                                end: _currentPage == index ? 1.0 : 0.3,
                              ),
                              builder: (context, value, child) => Container(
                                width: 8,
                                height: 8,
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).colorScheme.primary.withOpacity(value),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (_currentPage > 0)
                                TextButton(
                                  onPressed: () {
                                    _pageController.previousPage(
                                      duration: const Duration(milliseconds: 400),
                                      curve: Curves.easeInOutCubic,
                                    );
                                  },
                                  child: Text(l10n.previous),
                                )
                              else
                                TextButton(
                                  onPressed: () async {
                                    // Salva la preferenza di non mostrare all'avvio
                                    await OnboardingService().setShowOnStartup(false);
                                    if (mounted) {
                                      widget.onDismiss();
                                    }
                                  },
                                  child: Text(l10n.dontShowAgain),
                                ),
                              TextButton(
                                onPressed: () {
                                  if (_currentPage < pages.length - 1) {
                                    _pageController.nextPage(
                                      duration: const Duration(milliseconds: 400),
                                      curve: Curves.easeInOutCubic,
                                    );
                                  } else {
                                    widget.onDismiss();
                                  }
                                },
                                child: Text(_currentPage < pages.length - 1 ? l10n.next : l10n.start),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPage(
    String title,
    String description,
    IconData icon, {
    Widget? customContent,
    bool contentAtBottom = false,
    bool contentAtTop = false,
    bool contentAfterTitle = false,
  }) {
    final descriptionWidget = Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (customContent == null)
                Icon(
                  icon,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
              const SizedBox(height: 24),
              Text(
                description,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );

    final content = [
      if (contentAtTop && customContent != null) ...[
        customContent,
        const SizedBox(height: 24),
      ],
      Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 24),
      if (contentAfterTitle && customContent != null) ...[
        customContent,
        const SizedBox(height: 24),
      ],
      if (!contentAtTop && !contentAtBottom && !contentAfterTitle && customContent != null) ...[
        customContent,
        const SizedBox(height: 24),
      ],
      Expanded(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              description,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      if (contentAtBottom && customContent != null) ...[
        const SizedBox(height: 24),
        customContent,
      ],
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: content,
    );
  }
}