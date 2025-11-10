import 'package:flutter/material.dart';
import 'initialization_helper.dart';

class InitializeScreen extends StatefulWidget {
  final Widget targetWidget;

  const InitializeScreen({required this.targetWidget});

  @override
  State<InitializeScreen> createState() => _InitializeScreenState();
}

class _InitializeScreenState extends State<InitializeScreen> {
  final _initializationHelper = InitializationHelper();
  late final DateTime _startTime;

  @override
  void initState() {
    super.initState();
    // Inizia il timer immediatamente quando lo stato viene creato
    _startTime = DateTime.now();
    _initialize();
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  

  Future<void> _initialize() async {
    final navigator = Navigator.of(context);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Esegui l'inizializzazione
      await _initializationHelper.initialize();
      
      // Calcola quanto tempo è passato dall'inizio (da initState)
      final elapsed = DateTime.now().difference(_startTime);
      const minSplashDuration = Duration(seconds: 2);
      
      // Se non sono passati almeno 2 secondi, aspetta il tempo rimanente
      if (elapsed < minSplashDuration) {
        final remaining = minSplashDuration - elapsed;
        await Future.delayed(remaining);
      }
      
      // Ora naviga alla schermata principale
      navigator.pushReplacement(
        MaterialPageRoute(builder: (context) => widget.targetWidget));
    });
  }

}