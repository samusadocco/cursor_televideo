// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'televideo_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ClickableArea _$ClickableAreaFromJson(Map<String, dynamic> json) {
  return _ClickableArea.fromJson(json);
}

/// @nodoc
mixin _$ClickableArea {
  int get targetPage => throw _privateConstructorUsedError;
  int get x => throw _privateConstructorUsedError;
  int get y => throw _privateConstructorUsedError;
  int get width => throw _privateConstructorUsedError;
  int get height => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this ClickableArea to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ClickableArea
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClickableAreaCopyWith<ClickableArea> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClickableAreaCopyWith<$Res> {
  factory $ClickableAreaCopyWith(
          ClickableArea value, $Res Function(ClickableArea) then) =
      _$ClickableAreaCopyWithImpl<$Res, ClickableArea>;
  @useResult
  $Res call(
      {int targetPage,
      int x,
      int y,
      int width,
      int height,
      String? description});
}

/// @nodoc
class _$ClickableAreaCopyWithImpl<$Res, $Val extends ClickableArea>
    implements $ClickableAreaCopyWith<$Res> {
  _$ClickableAreaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClickableArea
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetPage = null,
    Object? x = null,
    Object? y = null,
    Object? width = null,
    Object? height = null,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      targetPage: null == targetPage
          ? _value.targetPage
          : targetPage // ignore: cast_nullable_to_non_nullable
              as int,
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as int,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as int,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ClickableAreaImplCopyWith<$Res>
    implements $ClickableAreaCopyWith<$Res> {
  factory _$$ClickableAreaImplCopyWith(
          _$ClickableAreaImpl value, $Res Function(_$ClickableAreaImpl) then) =
      __$$ClickableAreaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int targetPage,
      int x,
      int y,
      int width,
      int height,
      String? description});
}

/// @nodoc
class __$$ClickableAreaImplCopyWithImpl<$Res>
    extends _$ClickableAreaCopyWithImpl<$Res, _$ClickableAreaImpl>
    implements _$$ClickableAreaImplCopyWith<$Res> {
  __$$ClickableAreaImplCopyWithImpl(
      _$ClickableAreaImpl _value, $Res Function(_$ClickableAreaImpl) _then)
      : super(_value, _then);

  /// Create a copy of ClickableArea
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetPage = null,
    Object? x = null,
    Object? y = null,
    Object? width = null,
    Object? height = null,
    Object? description = freezed,
  }) {
    return _then(_$ClickableAreaImpl(
      targetPage: null == targetPage
          ? _value.targetPage
          : targetPage // ignore: cast_nullable_to_non_nullable
              as int,
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as int,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as int,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ClickableAreaImpl implements _ClickableArea {
  const _$ClickableAreaImpl(
      {required this.targetPage,
      required this.x,
      required this.y,
      required this.width,
      required this.height,
      this.description});

  factory _$ClickableAreaImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClickableAreaImplFromJson(json);

  @override
  final int targetPage;
  @override
  final int x;
  @override
  final int y;
  @override
  final int width;
  @override
  final int height;
  @override
  final String? description;

  @override
  String toString() {
    return 'ClickableArea(targetPage: $targetPage, x: $x, y: $y, width: $width, height: $height, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClickableAreaImpl &&
            (identical(other.targetPage, targetPage) ||
                other.targetPage == targetPage) &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, targetPage, x, y, width, height, description);

  /// Create a copy of ClickableArea
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClickableAreaImplCopyWith<_$ClickableAreaImpl> get copyWith =>
      __$$ClickableAreaImplCopyWithImpl<_$ClickableAreaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ClickableAreaImplToJson(
      this,
    );
  }
}

abstract class _ClickableArea implements ClickableArea {
  const factory _ClickableArea(
      {required final int targetPage,
      required final int x,
      required final int y,
      required final int width,
      required final int height,
      final String? description}) = _$ClickableAreaImpl;

  factory _ClickableArea.fromJson(Map<String, dynamic> json) =
      _$ClickableAreaImpl.fromJson;

  @override
  int get targetPage;
  @override
  int get x;
  @override
  int get y;
  @override
  int get width;
  @override
  int get height;
  @override
  String? get description;

  /// Create a copy of ClickableArea
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClickableAreaImplCopyWith<_$ClickableAreaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TelevideoPage _$TelevideoPageFromJson(Map<String, dynamic> json) {
  return _TelevideoPage.fromJson(json);
}

/// @nodoc
mixin _$TelevideoPage {
  int get pageNumber => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  String? get region => throw _privateConstructorUsedError;
  List<ClickableArea> get clickableAreas => throw _privateConstructorUsedError;
  int get maxSubPages => throw _privateConstructorUsedError;
  int get subPage =>
      throw _privateConstructorUsedError; // Numero sottopagina corrente
  int get totalSubPages =>
      throw _privateConstructorUsedError; // Totale sottopagine
  DateTime? get timestamp =>
      throw _privateConstructorUsedError; // Timestamp caricamento
  bool get isHtmlContent =>
      throw _privateConstructorUsedError; // True se è contenuto HTML invece di immagine
  String? get htmlContent =>
      throw _privateConstructorUsedError; // Contenuto HTML grezzo (per ARD e altri)
  String? get providerId =>
      throw _privateConstructorUsedError; // ID del provider che ha generato la pagina
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this TelevideoPage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TelevideoPage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TelevideoPageCopyWith<TelevideoPage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TelevideoPageCopyWith<$Res> {
  factory $TelevideoPageCopyWith(
          TelevideoPage value, $Res Function(TelevideoPage) then) =
      _$TelevideoPageCopyWithImpl<$Res, TelevideoPage>;
  @useResult
  $Res call(
      {int pageNumber,
      String imageUrl,
      String? region,
      List<ClickableArea> clickableAreas,
      int maxSubPages,
      int subPage,
      int totalSubPages,
      DateTime? timestamp,
      bool isHtmlContent,
      String? htmlContent,
      String? providerId,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$TelevideoPageCopyWithImpl<$Res, $Val extends TelevideoPage>
    implements $TelevideoPageCopyWith<$Res> {
  _$TelevideoPageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TelevideoPage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pageNumber = null,
    Object? imageUrl = null,
    Object? region = freezed,
    Object? clickableAreas = null,
    Object? maxSubPages = null,
    Object? subPage = null,
    Object? totalSubPages = null,
    Object? timestamp = freezed,
    Object? isHtmlContent = null,
    Object? htmlContent = freezed,
    Object? providerId = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      pageNumber: null == pageNumber
          ? _value.pageNumber
          : pageNumber // ignore: cast_nullable_to_non_nullable
              as int,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      region: freezed == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String?,
      clickableAreas: null == clickableAreas
          ? _value.clickableAreas
          : clickableAreas // ignore: cast_nullable_to_non_nullable
              as List<ClickableArea>,
      maxSubPages: null == maxSubPages
          ? _value.maxSubPages
          : maxSubPages // ignore: cast_nullable_to_non_nullable
              as int,
      subPage: null == subPage
          ? _value.subPage
          : subPage // ignore: cast_nullable_to_non_nullable
              as int,
      totalSubPages: null == totalSubPages
          ? _value.totalSubPages
          : totalSubPages // ignore: cast_nullable_to_non_nullable
              as int,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isHtmlContent: null == isHtmlContent
          ? _value.isHtmlContent
          : isHtmlContent // ignore: cast_nullable_to_non_nullable
              as bool,
      htmlContent: freezed == htmlContent
          ? _value.htmlContent
          : htmlContent // ignore: cast_nullable_to_non_nullable
              as String?,
      providerId: freezed == providerId
          ? _value.providerId
          : providerId // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TelevideoPageImplCopyWith<$Res>
    implements $TelevideoPageCopyWith<$Res> {
  factory _$$TelevideoPageImplCopyWith(
          _$TelevideoPageImpl value, $Res Function(_$TelevideoPageImpl) then) =
      __$$TelevideoPageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int pageNumber,
      String imageUrl,
      String? region,
      List<ClickableArea> clickableAreas,
      int maxSubPages,
      int subPage,
      int totalSubPages,
      DateTime? timestamp,
      bool isHtmlContent,
      String? htmlContent,
      String? providerId,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$TelevideoPageImplCopyWithImpl<$Res>
    extends _$TelevideoPageCopyWithImpl<$Res, _$TelevideoPageImpl>
    implements _$$TelevideoPageImplCopyWith<$Res> {
  __$$TelevideoPageImplCopyWithImpl(
      _$TelevideoPageImpl _value, $Res Function(_$TelevideoPageImpl) _then)
      : super(_value, _then);

  /// Create a copy of TelevideoPage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pageNumber = null,
    Object? imageUrl = null,
    Object? region = freezed,
    Object? clickableAreas = null,
    Object? maxSubPages = null,
    Object? subPage = null,
    Object? totalSubPages = null,
    Object? timestamp = freezed,
    Object? isHtmlContent = null,
    Object? htmlContent = freezed,
    Object? providerId = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$TelevideoPageImpl(
      pageNumber: null == pageNumber
          ? _value.pageNumber
          : pageNumber // ignore: cast_nullable_to_non_nullable
              as int,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      region: freezed == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String?,
      clickableAreas: null == clickableAreas
          ? _value._clickableAreas
          : clickableAreas // ignore: cast_nullable_to_non_nullable
              as List<ClickableArea>,
      maxSubPages: null == maxSubPages
          ? _value.maxSubPages
          : maxSubPages // ignore: cast_nullable_to_non_nullable
              as int,
      subPage: null == subPage
          ? _value.subPage
          : subPage // ignore: cast_nullable_to_non_nullable
              as int,
      totalSubPages: null == totalSubPages
          ? _value.totalSubPages
          : totalSubPages // ignore: cast_nullable_to_non_nullable
              as int,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isHtmlContent: null == isHtmlContent
          ? _value.isHtmlContent
          : isHtmlContent // ignore: cast_nullable_to_non_nullable
              as bool,
      htmlContent: freezed == htmlContent
          ? _value.htmlContent
          : htmlContent // ignore: cast_nullable_to_non_nullable
              as String?,
      providerId: freezed == providerId
          ? _value.providerId
          : providerId // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TelevideoPageImpl implements _TelevideoPage {
  const _$TelevideoPageImpl(
      {required this.pageNumber,
      required this.imageUrl,
      this.region,
      final List<ClickableArea> clickableAreas = const [],
      this.maxSubPages = 1,
      this.subPage = 1,
      this.totalSubPages = 1,
      this.timestamp,
      this.isHtmlContent = false,
      this.htmlContent,
      this.providerId,
      final Map<String, dynamic>? metadata})
      : _clickableAreas = clickableAreas,
        _metadata = metadata;

  factory _$TelevideoPageImpl.fromJson(Map<String, dynamic> json) =>
      _$$TelevideoPageImplFromJson(json);

  @override
  final int pageNumber;
  @override
  final String imageUrl;
  @override
  final String? region;
  final List<ClickableArea> _clickableAreas;
  @override
  @JsonKey()
  List<ClickableArea> get clickableAreas {
    if (_clickableAreas is EqualUnmodifiableListView) return _clickableAreas;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_clickableAreas);
  }

  @override
  @JsonKey()
  final int maxSubPages;
  @override
  @JsonKey()
  final int subPage;
// Numero sottopagina corrente
  @override
  @JsonKey()
  final int totalSubPages;
// Totale sottopagine
  @override
  final DateTime? timestamp;
// Timestamp caricamento
  @override
  @JsonKey()
  final bool isHtmlContent;
// True se è contenuto HTML invece di immagine
  @override
  final String? htmlContent;
// Contenuto HTML grezzo (per ARD e altri)
  @override
  final String? providerId;
// ID del provider che ha generato la pagina
  final Map<String, dynamic>? _metadata;
// ID del provider che ha generato la pagina
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'TelevideoPage(pageNumber: $pageNumber, imageUrl: $imageUrl, region: $region, clickableAreas: $clickableAreas, maxSubPages: $maxSubPages, subPage: $subPage, totalSubPages: $totalSubPages, timestamp: $timestamp, isHtmlContent: $isHtmlContent, htmlContent: $htmlContent, providerId: $providerId, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TelevideoPageImpl &&
            (identical(other.pageNumber, pageNumber) ||
                other.pageNumber == pageNumber) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.region, region) || other.region == region) &&
            const DeepCollectionEquality()
                .equals(other._clickableAreas, _clickableAreas) &&
            (identical(other.maxSubPages, maxSubPages) ||
                other.maxSubPages == maxSubPages) &&
            (identical(other.subPage, subPage) || other.subPage == subPage) &&
            (identical(other.totalSubPages, totalSubPages) ||
                other.totalSubPages == totalSubPages) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.isHtmlContent, isHtmlContent) ||
                other.isHtmlContent == isHtmlContent) &&
            (identical(other.htmlContent, htmlContent) ||
                other.htmlContent == htmlContent) &&
            (identical(other.providerId, providerId) ||
                other.providerId == providerId) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      pageNumber,
      imageUrl,
      region,
      const DeepCollectionEquality().hash(_clickableAreas),
      maxSubPages,
      subPage,
      totalSubPages,
      timestamp,
      isHtmlContent,
      htmlContent,
      providerId,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of TelevideoPage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TelevideoPageImplCopyWith<_$TelevideoPageImpl> get copyWith =>
      __$$TelevideoPageImplCopyWithImpl<_$TelevideoPageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TelevideoPageImplToJson(
      this,
    );
  }
}

abstract class _TelevideoPage implements TelevideoPage {
  const factory _TelevideoPage(
      {required final int pageNumber,
      required final String imageUrl,
      final String? region,
      final List<ClickableArea> clickableAreas,
      final int maxSubPages,
      final int subPage,
      final int totalSubPages,
      final DateTime? timestamp,
      final bool isHtmlContent,
      final String? htmlContent,
      final String? providerId,
      final Map<String, dynamic>? metadata}) = _$TelevideoPageImpl;

  factory _TelevideoPage.fromJson(Map<String, dynamic> json) =
      _$TelevideoPageImpl.fromJson;

  @override
  int get pageNumber;
  @override
  String get imageUrl;
  @override
  String? get region;
  @override
  List<ClickableArea> get clickableAreas;
  @override
  int get maxSubPages;
  @override
  int get subPage; // Numero sottopagina corrente
  @override
  int get totalSubPages; // Totale sottopagine
  @override
  DateTime? get timestamp; // Timestamp caricamento
  @override
  bool get isHtmlContent; // True se è contenuto HTML invece di immagine
  @override
  String? get htmlContent; // Contenuto HTML grezzo (per ARD e altri)
  @override
  String? get providerId; // ID del provider che ha generato la pagina
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of TelevideoPage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TelevideoPageImplCopyWith<_$TelevideoPageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
