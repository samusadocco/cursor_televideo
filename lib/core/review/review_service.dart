import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewService {
  static const String _launchCountKey = 'app_launch_count';
  static const String _lastReviewRequestKey = 'last_review_request_date';
  static const String _hasOpenedStoreKey = 'has_opened_store';
  static const int _launchesBeforeReview = 10; // Richiedi recensione dopo 10 avvii
  static const Duration _minDaysBetweenRequests = Duration(days: 60); // Aspetta almeno 60 giorni tra le richieste
  static const Duration _minDaysAfterStoreOpen = Duration(days: 180); // Aspetta 6 mesi se l'utente ha già aperto lo store

  final InAppReview _inAppReview;
  final SharedPreferences _prefs;

  ReviewService._(this._inAppReview, this._prefs);

  static Future<ReviewService> create() async {
    final prefs = await SharedPreferences.getInstance();
    final inAppReview = InAppReview.instance;
    return ReviewService._(inAppReview, prefs);
  }

  /// Incrementa il contatore di avvii dell'app
  Future<void> incrementLaunchCount() async {
    final currentCount = _prefs.getInt(_launchCountKey) ?? 0;
    await _prefs.setInt(_launchCountKey, currentCount + 1);
  }

  /// Controlla se è il momento di richiedere una recensione
    Future<bool> shouldRequestReview() async {
    if (!await _inAppReview.isAvailable()) {
      return false;
    }

    // Se l'utente ha già aperto lo store per recensire
    final hasOpenedStore = _prefs.getBool(_hasOpenedStoreKey) ?? false;
    if (hasOpenedStore) {
      final lastRequestDate = DateTime.fromMillisecondsSinceEpoch(
        _prefs.getInt(_lastReviewRequestKey) ?? 0,
      );
      final now = DateTime.now();
      final daysSinceLastRequest = now.difference(lastRequestDate);
      
      // Se ha già aperto lo store, aspettiamo molto più tempo
      if (daysSinceLastRequest < _minDaysAfterStoreOpen) {
        return false;
      }
    }

    final launchCount = _prefs.getInt(_launchCountKey) ?? 0;
    final lastRequestDate = DateTime.fromMillisecondsSinceEpoch(
      _prefs.getInt(_lastReviewRequestKey) ?? 0,
    );
    final now = DateTime.now();

    // Verifica se sono passati abbastanza giorni dall'ultima richiesta
    final daysSinceLastRequest = now.difference(lastRequestDate);
    if (daysSinceLastRequest < _minDaysBetweenRequests) {
      return false;
    }

    return launchCount >= _launchesBeforeReview;
  }

  /// Richiede una recensione all'utente
  Future<void> requestReview() async {
    try {
      if (await _inAppReview.isAvailable()) {
        // In sviluppo, apriamo direttamente la pagina dello store
        await openStoreListing();
      } else {
        await _inAppReview.requestReview();
      }
      // Salva la data dell'ultima richiesta
      await _prefs.setInt(_lastReviewRequestKey, DateTime.now().millisecondsSinceEpoch);
      // Resetta il contatore degli avvii
      await _prefs.setInt(_launchCountKey, 0);
    } catch (e) {
      // In caso di errore, non fare nulla
      print('Errore durante la richiesta di recensione: $e');
    }
  }

  /// Apre direttamente la pagina dello store per lasciare una recensione
  Future<void> openStoreListing() async {
    try {
      await _inAppReview.openStoreListing(
        appStoreId: '6748967698', // Sostituisci con il tuo App Store ID
      );
      // Segna che l'utente ha aperto lo store
      await _prefs.setBool(_hasOpenedStoreKey, true);
      // Aggiorna la data dell'ultima richiesta
      await _prefs.setInt(_lastReviewRequestKey, DateTime.now().millisecondsSinceEpoch);
      // Resetta il contatore degli avvii
      await _prefs.setInt(_launchCountKey, 0);
    } catch (e) {
      print('Errore durante l\'apertura dello store: $e');
    }
  }
}
