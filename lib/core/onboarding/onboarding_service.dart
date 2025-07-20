import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class OnboardingService {
  static final OnboardingService _instance = OnboardingService._internal();
  factory OnboardingService() => _instance;
  OnboardingService._internal();

  static const String _hasSeenOnboardingKey = 'has_seen_onboarding';
  static const String _showOnStartupKey = 'show_onboarding_on_startup';
  bool _hasSeenOnboarding = false;
  bool _showOnStartup = false;

  // Stream controller per notificare quando mostrare l'onboarding
  final _showOnboardingController = StreamController<void>.broadcast();
  Stream<void> get showOnboardingStream => _showOnboardingController.stream;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _hasSeenOnboarding = prefs.getBool(_hasSeenOnboardingKey) ?? false;
    _showOnStartup = prefs.getBool(_showOnStartupKey) ?? false;
  }

  bool get hasSeenOnboarding => _hasSeenOnboarding;
  bool get showOnStartup => _showOnStartup;

  Future<void> markOnboardingAsSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasSeenOnboardingKey, true);
    _hasSeenOnboarding = true;
  }

  Future<void> setShowOnStartup(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showOnStartupKey, value);
    _showOnStartup = value;
  }

  void showOnboarding() {
    _showOnboardingController.add(null);
  }

  void dispose() {
    _showOnboardingController.close();
  }
} 