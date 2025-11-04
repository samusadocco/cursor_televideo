import 'package:flutter/material.dart';
import 'package:cursor_televideo/core/utils/store_country_detector.dart';

class SplashScreen extends StatefulWidget {
  final Widget child;

  const SplashScreen({
    super.key,
    required this.child,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  
  // Informazioni sul paese dello store
  String _splashImagePath = 'assets/images/splash/splash_italia.png';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _detectStoreCountry();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
    ));

    // Avvia l'animazione dopo il rilevamento del paese
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }
  
  /// Rileva il paese dello store e personalizza lo splash
  Future<void> _detectStoreCountry() async {
    try {
      final detector = StoreCountryDetector.instance;
      final country = await detector.getStoreCountryCode();
      
      // Determina quale immagine di splash usare
      final isItaly = country.toLowerCase() == 'it';
      final splashImage = isItaly 
          ? 'assets/images/splash/splash_italia.png'
          : 'assets/images/splash/splash_international.png';
      
      if (mounted) {
        setState(() {
          _splashImagePath = splashImage;
          _isLoading = false;
        });
      }
      
      print('[SplashScreen] Store country: $country, Splash: $splashImage');
    } catch (e) {
      print('[SplashScreen] Error detecting store country: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Widget principale dell'app
        widget.child,

        // Splash screen con effetto di dissolvenza
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Visibility(
              visible: _opacityAnimation.value > 0,
              child: Container(
                color: Colors.black.withOpacity(_opacityAnimation.value),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Immagine splash personalizzata con animazione
                      if (!_isLoading)
                        Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Image.asset(
                            _splashImagePath,
                            width: 300,
                            height: 300,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              // Fallback all'icona app se l'immagine splash non è trovata
                              return Image.asset(
                                'assets/icons/app_icon.png',
                                width: 200,
                                height: 200,
                                fit: BoxFit.contain,
                              );
                            },
                          ),
                        ),
                      
                      // Placeholder durante il caricamento
                      if (_isLoading)
                        Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Image.asset(
                            'assets/icons/app_icon.png',
                            width: 200,
                            height: 200,
                            fit: BoxFit.contain,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
