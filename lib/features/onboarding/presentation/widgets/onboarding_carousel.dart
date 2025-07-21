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

    final dialogWidth = isTablet 
        ? screenSize.width * 0.7
        : screenSize.width * 0.9;
    
    final dialogHeight = isTablet
        ? screenSize.height * 0.8
        : screenSize.height * 0.85;

    final pages = [
      // Pagina di benvenuto
      _buildPage(
        'Benvenuto in TeleRetro Italia',
        'Scopri tutte le funzionalità dell\'app',
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
        'Navigazione Pagine',
        'Usa le frecce laterali per navigare tra le pagine:\n\n'
        '• Freccia sinistra: vai alla pagina precedente\n'
        '• Freccia destra: vai alla pagina successiva\n\n'
        'Puoi anche usare lo swipe orizzontale per lo stesso effetto.',
        Icons.arrow_forward,
        customContent: const BottomBarInstruction(
          highlight: BottomBarHighlight.horizontalNavigation,
        ),
        contentAtBottom: true,
      ),
      // Selettore pagine
      _buildPage(
        'Selettore Pagine',
        'Tocca il numero centrale per inserire direttamente una pagina.\n\n'
        
        'Inserisci un numero tra 100 e 999 per saltare a quella pagina.',
        Icons.numbers,
        customContent: const BottomBarInstruction(
          highlight: BottomBarHighlight.pageSelector,
        ),
        contentAtBottom: true,
      ),
      // Navigazione verticale
      _buildPage(
        'Navigazione Sottopagine',
        'Se la pagina ha delle sottopagine, vedrai anche l\'indicatore:\n'
        '• 1/3 significa: prima sottopagina di tre disponibili\n\n'
        'Usa le frecce centrali per navigare tra le sottopagine:\n\n'
        '• Freccia su: vai alla sottopagina successiva\n'
        '• Freccia giù: vai alla sottopagina precedente\n\n'
        'Le frecce sono attive solo quando ci sono sottopagine disponibili.',
        Icons.arrow_upward,
        customContent: const BottomBarInstructionWithTimer(
          highlight: BottomBarHighlight.verticalNavigation,
        ),
        contentAtBottom: true,
      ),
      // Indicatore di autocaricamento
      _buildPage(
        'Autocaricamento Sottopagine',
        'Quando l\'aggiornamento automatico è attivo, il cerchio intorno al numero di pagina si riempie progressivamente:\n\n'
        'Modifica il tempo di aggiornamento nelle impostazioni\n\n'
        'L\'indicatore è visibile solo quando ci sono sottopagine disponibili e l\'aggiornamento automatico è attivo.',
        Icons.timer,
        customContent: const BottomBarInstructionWithTimer(
          highlight: BottomBarHighlight.pageSelector,
        ),
        contentAtBottom: true,
      ),
      // Spiegazione swipe
      _buildPage(
        'Navigazione Swipe',
        'Naviga facilmente tra le pagine con i gesti mostrati qui sopra.',
        Icons.swipe,
        customContent: const SwipeInstructions(),
      ),
      // Spiegazione numeri cliccabili
      _buildPage(
        'Numeri di pagina clickabili',
        'Tocca i numeri di pagina evidenziati per navigare direttamente a quella pagina\n\n'
        'Le pagine 100/1 del Televideo Nazionale e 300/1 del Televideo Regionale non sono clickabili',
        Icons.touch_app,
        customContent: const PageLinksInstruction(),
      ),
      // Spiegazione menu shortcuts
      _buildPage(
        'Menu Shortcuts',
        'Accedi rapidamente alle pagine più importanti del Televideo.\n\n'
        'Usa questo menu per saltare direttamente a:\n'
        '• Pagina 100: Indice nazionale\n'
        '• Pagina 200: Notizie\n'
        '.....\n'
        'Puoi anche ricercare le pagine in base al titolo selezionando l\' opzione Cerca pagina',
        Icons.menu_book,
        customContent: const ShortcutsMenuInstruction(),
      ),
      // Spiegazione selettore regioni
      _buildPage(
        'Selettore Regioni',
        'Passa dal Televideo Nazionale a quello Regionale.\n\n'

        'La tua posizione verrà rilevata automaticamente per suggerirti la regione corretta.',
        Icons.location_on,
        customContent: const RegionSelectorInstruction(),
      ),
      // Spiegazione preferiti
      _buildPage(
        'Aggiungi ai Preferiti',
        'Salva le pagine che visiti più spesso:\n\n'
        '• Tocca l\'icona cuore per aggiungere la pagina corrente\n'
        '• Tocca di nuovo per rimuoverla dai preferiti\n'
        '• L\'icona diventa rossa quando la pagina è tra i preferiti\n\n'
        'Puoi salvare sia pagine nazionali che regionali.',
        Icons.favorite,
        customContent: const FavoritesInstruction(),
        contentAfterTitle: true,
      ),
      // Spiegazione lista preferiti
      _buildPage(
        'Lista Preferiti',
        'Gestisci le tue pagine preferite:\n\n'
        '• Tocca una pagina per aprirla\n'
        '• Scorri a sinistra per rimuoverla\n'
        '• Tocca la matita per modificare la descrizione\n'
        '• Tieni premuto per modificare l\'ordine\n\n'
         , Icons.list,
        customContent: const FavoritesListInstruction(),
        contentAfterTitle: true,
      ),
      // Spiegazione impostazioni
      _buildPage(
        'Impostazioni',
        'Personalizza l\'app secondo le tue preferenze:\n\n'
        '• Tema: scegli tra chiaro, scuro o automatico\n'
        '• Aggiornamento automatico: attiva il caricamento automatico delle sottopagine\n'
        '• Cache: gestisci la durata della cache delle pagine\n'
        '• Istruzioni: rivedi questo tutorial quando vuoi',
        Icons.settings,
        customContent: const SettingsInstruction(),
        contentAfterTitle: true,
      ),
      // Spiegazione Live Show
      
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
                                  child: const Text('Indietro'),
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
                                  child: const Text('Non mostrare più'),
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
                                child: Text(_currentPage < pages.length - 1 ? 'Avanti' : 'Inizia'),
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