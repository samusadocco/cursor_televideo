import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

/// Custom ImageProvider per caricare immagini da Intertext con headers custom
class IntertextImageProvider extends ImageProvider<IntertextImageProvider> {
  final String url;
  final Dio _dio;

  IntertextImageProvider(this.url)
      : _dio = Dio() {
    // Configura headers necessari per bypassare 403
    _dio.options.headers['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36';
    _dio.options.headers['Referer'] = 'https://intertext.com.ua/look';
  }

  @override
  Future<IntertextImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<IntertextImageProvider>(this);
  }

  @override
  ImageStreamCompleter loadImage(IntertextImageProvider key, ImageDecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: 1.0,
      debugLabel: url,
      informationCollector: () => <DiagnosticsNode>[
        DiagnosticsProperty<ImageProvider>('Image provider', this),
        DiagnosticsProperty<IntertextImageProvider>('Image key', key),
      ],
    );
  }

  Future<ui.Codec> _loadAsync(IntertextImageProvider key, ImageDecoderCallback decode) async {
    try {
      final response = await _dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200 && response.data != null) {
        final bytes = Uint8List.fromList(response.data!);
        final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
        return decode(buffer);
      } else {
        throw Exception('Failed to load image: HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load image from Intertext: $e');
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is IntertextImageProvider && other.url == url;
  }

  @override
  int get hashCode => url.hashCode;

  @override
  String toString() => '${objectRuntimeType(this, 'IntertextImageProvider')}("$url")';
}

