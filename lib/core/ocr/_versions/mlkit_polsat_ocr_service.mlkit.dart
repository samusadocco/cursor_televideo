import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';
import 'package:flutter/foundation.dart';

/// Servizio OCR veloce per teletext basato su immagini (Polsat, TVP Telegazeta).
/// Gestisce numeri di pagina standard e double-width (es. 861-865).
class MLKitPolsatOcrService {
  final Dio _dio;
  final TextRecognizer? _textRecognizer;
  final bool _isSimulator;

  static final RegExp _pageNumberPattern = RegExp(r'(?<![0-9])([1-9]\d{2})(?![0-9])');
  static final RegExp _pageRangePattern =
      RegExp(r'(?<![0-9])([1-9]\d{2})\s*[-–/]\s*([1-9]\d{2})(?![0-9])');
  static final RegExp _digitSequencePattern = RegExp(r'^[0-9\-–./]+$');

  MLKitPolsatOcrService({Dio? dio})
      : _dio = dio ?? Dio(),
        _isSimulator = _shouldDisableOCR(),
        _textRecognizer = _initializeTextRecognizer() {
    if (_isSimulator) {
      print('[MLKit OCR] ⚠️ OCR disabled - running without clickable links');
    }
  }

  static TextRecognizer? _initializeTextRecognizer() {
    if (_shouldDisableOCR()) {
      return null;
    }

    try {
      return TextRecognizer(script: TextRecognitionScript.latin);
    } catch (e) {
      print('[MLKit OCR] ⚠️ Failed to initialize TextRecognizer: $e');
      return null;
    }
  }

  static bool _shouldDisableOCR() {
    const enableOcr = String.fromEnvironment('ENABLE_OCR', defaultValue: 'auto');

    if (enableOcr == 'false') {
      print('[MLKit OCR] 🔧 OCR manually disabled via --dart-define=ENABLE_OCR=false');
      return true;
    }

    if (enableOcr == 'true') {
      print('[MLKit OCR] 🔧 OCR manually enabled via --dart-define=ENABLE_OCR=true');
      return false;
    }

    if (!Platform.isIOS) return false;

    final environment = Platform.environment;
    if (environment['SIMULATOR_DEVICE_NAME'] != null ||
        environment['SIMULATOR_UDID'] != null) {
      print('[MLKit OCR] 🔍 iOS Simulator detected - OCR auto-disabled');
      return true;
    }

    if (Platform.version.toLowerCase().contains('simulator')) {
      print('[MLKit OCR] 🔍 iOS Simulator detected - OCR auto-disabled');
      return true;
    }

    return false;
  }

  Future<List<ClickableArea>> extractClickableAreas({
    required String imageUrl,
    required int pageNumber,
  }) async {
    if (_isSimulator) {
      print('[MLKit OCR] ⚠️ Skipping OCR on iOS Simulator - returning empty list');
      return [];
    }

    final startTime = DateTime.now();
    print('[MLKit OCR] 🚀 Starting extraction from: $imageUrl');

    try {
      final tempFile = await _downloadImage(imageUrl);

      final standardResult = await _recognizeAndExtract(tempFile, coordinateScale: 1.0);
      final wideResult = await _recognizeWideDigits(tempFile);

      await tempFile.delete();

      final merged = _dedupeAreas([...standardResult, ...wideResult]);
      final totalDuration = DateTime.now().difference(startTime).inMilliseconds;
      print(
        '[MLKit OCR] ✅ Total extraction time: ${totalDuration}ms, '
        'found ${merged.length} clickable areas '
        '(standard=${standardResult.length}, wide=${wideResult.length})',
      );

      return merged;
    } catch (e) {
      print('[MLKit OCR] ❌ Error: $e');
      rethrow;
    }
  }

  Future<List<ClickableArea>> _recognizeWideDigits(File source) async {
    File? halfWidthFile;
    try {
      halfWidthFile = await _createHalfWidthVariant(source);
      return await _recognizeAndExtract(halfWidthFile, coordinateScale: 2.0);
    } catch (e) {
      print('[MLKit OCR] ⚠️ Wide-digit OCR pass failed: $e');
      return [];
    } finally {
      if (halfWidthFile != null && await halfWidthFile.exists()) {
        await halfWidthFile.delete();
      }
    }
  }

  Future<List<ClickableArea>> _recognizeAndExtract(
    File imageFile, {
    required double coordinateScale,
  }) async {
    final inputImage = InputImage.fromFilePath(imageFile.path);
    final recognizedText = await _textRecognizer!.processImage(inputImage);
    return _extractClickableLinks(recognizedText, coordinateScale: coordinateScale);
  }

  Future<File> _createHalfWidthVariant(File source) async {
    final decoded = img.decodePng(await source.readAsBytes());
    if (decoded == null) {
      throw Exception('Failed to decode PNG for wide-digit OCR');
    }

    final halfWidth = img.copyResize(
      decoded,
      width: decoded.width ~/ 2,
      height: decoded.height,
      interpolation: img.Interpolation.nearest,
    );

    final out = File('${source.path}_half.png');
    await out.writeAsBytes(img.encodePng(halfWidth));
    return out;
  }

  List<ClickableArea> _extractClickableLinks(
    RecognizedText recognizedText, {
    required double coordinateScale,
  }) {
    final clickableAreas = <ClickableArea>[];
    final processedPages = <int>{};

    for (final block in recognizedText.blocks) {
      for (final line in block.lines) {
        _extractFromLineText(line, processedPages, clickableAreas, coordinateScale);
        _extractFromDigitGroups(line, processedPages, clickableAreas, coordinateScale);
      }
    }

    return clickableAreas;
  }

  void _extractFromLineText(
    TextLine line,
    Set<int> processedPages,
    List<ClickableArea> clickableAreas,
    double coordinateScale,
  ) {
    final text = line.text;

    for (final match in _pageRangePattern.allMatches(text)) {
      _addPageFromLine(
        line: line,
        pageNumStr: match.group(1)!,
        processedPages: processedPages,
        clickableAreas: clickableAreas,
        coordinateScale: coordinateScale,
      );
      _addPageFromLine(
        line: line,
        pageNumStr: match.group(2)!,
        processedPages: processedPages,
        clickableAreas: clickableAreas,
        coordinateScale: coordinateScale,
      );
    }

    for (final match in _pageNumberPattern.allMatches(text)) {
      _addPageFromLine(
        line: line,
        pageNumStr: match.group(1)!,
        processedPages: processedPages,
        clickableAreas: clickableAreas,
        coordinateScale: coordinateScale,
      );
    }
  }

  void _extractFromDigitGroups(
    TextLine line,
    Set<int> processedPages,
    List<ClickableArea> clickableAreas,
    double coordinateScale,
  ) {
    final elements = line.elements;
    if (elements.isEmpty) {
      return;
    }

    final buffer = StringBuffer();
    final groupElements = <TextElement>[];

    void flushGroup() {
      if (buffer.isEmpty || groupElements.isEmpty) {
        buffer.clear();
        groupElements.clear();
        return;
      }

      final groupText = buffer.toString();
      final groupRect = _mergeElementBounds(groupElements);
      if (groupRect != null) {
        for (final match in _pageRangePattern.allMatches(groupText)) {
          _addPageFromGroup(
            groupText: groupText,
            groupRect: groupRect,
            pageNumStr: match.group(1)!,
            processedPages: processedPages,
            clickableAreas: clickableAreas,
            coordinateScale: coordinateScale,
          );
          _addPageFromGroup(
            groupText: groupText,
            groupRect: groupRect,
            pageNumStr: match.group(2)!,
            processedPages: processedPages,
            clickableAreas: clickableAreas,
            coordinateScale: coordinateScale,
          );
        }

        for (final match in _pageNumberPattern.allMatches(groupText)) {
          _addPageFromGroup(
            groupText: groupText,
            groupRect: groupRect,
            pageNumStr: match.group(1)!,
            processedPages: processedPages,
            clickableAreas: clickableAreas,
            coordinateScale: coordinateScale,
          );
        }
      }

      buffer.clear();
      groupElements.clear();
    }

    for (final element in elements) {
      final token = element.text.trim();
      if (token.isNotEmpty && _digitSequencePattern.hasMatch(token)) {
        buffer.write(token);
        groupElements.add(element);
      } else {
        flushGroup();
      }
    }

    flushGroup();
  }

  void _addPageFromLine(
    {
    required TextLine line,
    required String pageNumStr,
    required Set<int> processedPages,
    required List<ClickableArea> clickableAreas,
    required double coordinateScale,
  }) {
    final pageNum = int.tryParse(pageNumStr);
    if (pageNum == null || pageNum < 100 || pageNum > 999) {
      return;
    }
    if (!processedPages.add(pageNum)) {
      return;
    }

    final bounds = _boundsForPageInLine(line, pageNumStr) ?? line.boundingBox;
    _appendArea(
      clickableAreas,
      pageNum,
      _scaleRect(bounds, coordinateScale),
    );
  }

  void _addPageFromGroup(
    {
    required String groupText,
    required Rect groupRect,
    required String pageNumStr,
    required Set<int> processedPages,
    required List<ClickableArea> clickableAreas,
    required double coordinateScale,
  }) {
    final pageNum = int.tryParse(pageNumStr);
    if (pageNum == null || pageNum < 100 || pageNum > 999) {
      return;
    }
    if (!processedPages.add(pageNum)) {
      return;
    }

    final start = groupText.indexOf(pageNumStr);
    final bounds = start >= 0
        ? _boundsForSubstring(groupText, start, start + pageNumStr.length, groupRect)
        : groupRect;

    _appendArea(
      clickableAreas,
      pageNum,
      _scaleRect(bounds, coordinateScale),
    );
  }

  void _appendArea(List<ClickableArea> clickableAreas, int pageNum, Rect rect) {
    if (rect.width <= 0 || rect.height <= 0) {
      return;
    }

    clickableAreas.add(ClickableArea(
      targetPage: pageNum,
      x: rect.left.round(),
      y: rect.top.round(),
      width: rect.width.round(),
      height: rect.height.round(),
      description: 'Pagina $pageNum',
    ));

    print(
      '[MLKit OCR] ✅ Found page $pageNum at '
      '(${rect.left.round()},${rect.top.round()}) '
      'size ${rect.width.round()}x${rect.height.round()}',
    );
  }

  Rect? _boundsForPageInLine(TextLine line, String pageNumStr) {
    final elements = line.elements;
    if (elements.isEmpty) {
      return null;
    }

    final chunks = <({int start, int end, TextElement element})>[];
    final buffer = StringBuffer();
    var offset = 0;

    for (final element in elements) {
      final text = element.text;
      chunks.add((start: offset, end: offset + text.length, element: element));
      buffer.write(text);
      offset += text.length;
    }

    final fullText = buffer.toString();
    final index = fullText.indexOf(pageNumStr);
    if (index < 0) {
      return null;
    }

    return _boundsForRange(chunks, index, index + pageNumStr.length);
  }

  Rect _boundsForSubstring(String text, int start, int end, Rect groupRect) {
    if (text.isEmpty) {
      return groupRect;
    }

    final left = groupRect.left + groupRect.width * start / text.length;
    final width = groupRect.width * (end - start) / text.length;
    return Rect.fromLTWH(left, groupRect.top, width, groupRect.height);
  }

  Rect? _boundsForRange(
    List<({int start, int end, TextElement element})> chunks,
    int start,
    int end,
  ) {
    Rect? result;

    for (final chunk in chunks) {
      if (chunk.end <= start || chunk.start >= end) {
        continue;
      }
      final rect = chunk.element.boundingBox;
      result = result == null ? rect : result.expandToInclude(rect);
    }

    return result;
  }

  Rect? _mergeElementBounds(List<TextElement> elements) {
    Rect? result;
    for (final element in elements) {
      final rect = element.boundingBox;
      result = result == null ? rect : result.expandToInclude(rect);
    }
    return result;
  }

  Rect _scaleRect(Rect rect, double scale) {
    if (scale == 1.0) {
      return rect;
    }

    return Rect.fromLTWH(
      rect.left * scale,
      rect.top,
      rect.width * scale,
      rect.height,
    );
  }

  List<ClickableArea> _dedupeAreas(List<ClickableArea> areas) {
    final byPage = <int, ClickableArea>{};
    for (final area in areas) {
      byPage.putIfAbsent(area.targetPage, () => area);
    }
    return byPage.values.toList();
  }

  Future<File> _downloadImage(String imageUrl) async {
    final response = await _dio.get<Uint8List>(
      imageUrl,
      options: Options(
        responseType: ResponseType.bytes,
        validateStatus: (status) => status! < 500,
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to download image: ${response.statusCode}');
    }

    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/polsat_ocr_${DateTime.now().millisecondsSinceEpoch}.png');
    await tempFile.writeAsBytes(response.data!);

    return tempFile;
  }

  Future<void> dispose() async {
    if (_textRecognizer != null) {
      await _textRecognizer!.close();
    }
  }
}
