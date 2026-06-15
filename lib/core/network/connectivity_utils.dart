import 'package:connectivity_plus/connectivity_plus.dart';

/// Normalizza il risultato di [Connectivity.checkConnectivity] (API 5.x e 6.x).
Future<List<ConnectivityResult>> getConnectivityResults() async {
  final result = await Connectivity().checkConnectivity();
  if (result is List<ConnectivityResult>) {
    return result;
  }
  return [result as ConnectivityResult];
}

bool hasActiveNetwork(List<ConnectivityResult> results) {
  return results.contains(ConnectivityResult.wifi) ||
      results.contains(ConnectivityResult.mobile) ||
      results.contains(ConnectivityResult.ethernet);
}

bool isNetworkUnavailable(List<ConnectivityResult> results) {
  return !hasActiveNetwork(results) ||
      (results.contains(ConnectivityResult.none) && results.length <= 1);
}
