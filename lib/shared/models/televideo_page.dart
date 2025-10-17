import 'package:freezed_annotation/freezed_annotation.dart';

part 'televideo_page.freezed.dart';
part 'televideo_page.g.dart';

/// Rappresenta un'area cliccabile sulla pagina del Televideo
@freezed
class ClickableArea with _$ClickableArea {
  const factory ClickableArea({
    required int targetPage,
    required int x,
    required int y,
    required int width,
    required int height,
    String? description, // Descrizione del link
  }) = _ClickableArea;

  factory ClickableArea.fromJson(Map<String, dynamic> json) =>
      _$ClickableAreaFromJson(json);
}

@freezed
class TelevideoPage with _$TelevideoPage {
  const factory TelevideoPage({
    required int pageNumber,
    required String imageUrl,
    String? region,
    @Default([]) List<ClickableArea> clickableAreas,
    @Default(1) int maxSubPages,
    @Default(1) int subPage, // Numero sottopagina corrente
    @Default(1) int totalSubPages, // Totale sottopagine
    DateTime? timestamp, // Timestamp caricamento
    @Default(false) bool isHtmlContent, // True se è contenuto HTML invece di immagine
    String? htmlContent, // Contenuto HTML grezzo (per ARD e altri)
    String? providerId, // ID del provider che ha generato la pagina
    Map<String, dynamic>? metadata, // Metadata extra (es. link navigazione per ZDF)
  }) = _TelevideoPage;

  factory TelevideoPage.fromJson(Map<String, dynamic> json) =>
      _$TelevideoPageFromJson(json);
} 