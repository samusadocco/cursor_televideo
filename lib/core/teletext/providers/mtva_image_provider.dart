import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

/// ImageProvider personalizzato per MTVA che accetta certificati self-signed
class MTVAImageProvider extends ImageProvider<MTVAImageProvider> {
  final String url;
  final double scale;
  
  static http.Client? _httpClient;
  
  MTVAImageProvider(this.url, {this.scale = 1.0});
  
  static http.Client _getHttpClient() {
    if (_httpClient == null) {
      final ioClient = HttpClient();
      ioClient.badCertificateCallback = (X509Certificate cert, String host, int port) {
        return host == 'www.teletext.hu' || host == 'teletext.hu';
      };
      _httpClient = IOClient(ioClient);
    }
    return _httpClient!;
  }

  @override
  Future<MTVAImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<MTVAImageProvider>(this);
  }

  @override
  ImageStreamCompleter loadImage(MTVAImageProvider key, ImageDecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: key.scale,
      debugLabel: key.url,
      informationCollector: () => <DiagnosticsNode>[
        DiagnosticsProperty<ImageProvider>('Image provider', this),
        DiagnosticsProperty<MTVAImageProvider>('Image key', key),
      ],
    );
  }

  Future<ui.Codec> _loadAsync(MTVAImageProvider key, ImageDecoderCallback decode) async {
    assert(key == this);

    try {
      final client = _getHttpClient();
      final response = await client.get(
        Uri.parse(url),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        },
      );

      if (response.statusCode != 200) {
        throw NetworkImageLoadException(
          statusCode: response.statusCode,
          uri: Uri.parse(url),
        );
      }

      final bytes = response.bodyBytes;
      if (bytes.isEmpty) {
        throw Exception('MTVAImageProvider: Image data is empty');
      }

      final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
      return decode(buffer);
    } catch (e) {
      print('[MTVAImageProvider] Error loading image: $e');
      rethrow;
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is MTVAImageProvider && other.url == url && other.scale == scale;
  }

  @override
  int get hashCode => Object.hash(url, scale);

  @override
  String toString() => '${objectRuntimeType(this, 'MTVAImageProvider')}("$url", scale: $scale)';
}

