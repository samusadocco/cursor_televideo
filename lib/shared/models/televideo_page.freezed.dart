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
  $Res call({int targetPage, int x, int y, int width, int height});
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
  $Res call({int targetPage, int x, int y, int width, int height});
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
      required this.height});

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
  String toString() {
    return 'ClickableArea(targetPage: $targetPage, x: $x, y: $y, width: $width, height: $height)';
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
            (identical(other.height, height) || other.height == height));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, targetPage, x, y, width, height);

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
      required final int height}) = _$ClickableAreaImpl;

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
      int maxSubPages});
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
      int maxSubPages});
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
      this.maxSubPages = 1})
      : _clickableAreas = clickableAreas;

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
  String toString() {
    return 'TelevideoPage(pageNumber: $pageNumber, imageUrl: $imageUrl, region: $region, clickableAreas: $clickableAreas, maxSubPages: $maxSubPages)';
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
                other.maxSubPages == maxSubPages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, pageNumber, imageUrl, region,
      const DeepCollectionEquality().hash(_clickableAreas), maxSubPages);

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
      final int maxSubPages}) = _$TelevideoPageImpl;

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

  /// Create a copy of TelevideoPage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TelevideoPageImplCopyWith<_$TelevideoPageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
