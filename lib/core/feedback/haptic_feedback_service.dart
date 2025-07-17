import 'package:flutter/services.dart';

class HapticFeedbackService {
  static void error() {
    HapticFeedback.heavyImpact();
  }

  static void success() {
    HapticFeedback.mediumImpact();
  }

  static void light() {
    HapticFeedback.lightImpact();
  }

  static void selection() {
    HapticFeedback.selectionClick();
  }
} 