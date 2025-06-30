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

TelevideoPage _$TelevideoPageFromJson(Map<String, dynamic> json) {
  return _TelevideoPage.fromJson(json);
}

/// @nodoc
mixin _$TelevideoPage {
  int get pageNumber => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  String? get region => throw _privateConstructorUsedError;

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
  $Res call({int pageNumber, String imageUrl, String? region});
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
  $Res call({int pageNumber, String imageUrl, String? region});
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TelevideoPageImpl implements _TelevideoPage {
  const _$TelevideoPageImpl(
      {required this.pageNumber, required this.imageUrl, this.region});

  factory _$TelevideoPageImpl.fromJson(Map<String, dynamic> json) =>
      _$$TelevideoPageImplFromJson(json);

  @override
  final int pageNumber;
  @override
  final String imageUrl;
  @override
  final String? region;

  @override
  String toString() {
    return 'TelevideoPage(pageNumber: $pageNumber, imageUrl: $imageUrl, region: $region)';
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
            (identical(other.region, region) || other.region == region));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, pageNumber, imageUrl, region);

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
      final String? region}) = _$TelevideoPageImpl;

  factory _TelevideoPage.fromJson(Map<String, dynamic> json) =
      _$TelevideoPageImpl.fromJson;

  @override
  int get pageNumber;
  @override
  String get imageUrl;
  @override
  String? get region;

  /// Create a copy of TelevideoPage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TelevideoPageImplCopyWith<_$TelevideoPageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
