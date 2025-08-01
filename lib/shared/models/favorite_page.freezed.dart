// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorite_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FavoritePage _$FavoritePageFromJson(Map<String, dynamic> json) {
  return _FavoritePage.fromJson(json);
}

/// @nodoc
mixin _$FavoritePage {
  int get pageNumber => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get regionCode => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;

  /// Serializes this FavoritePage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FavoritePage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FavoritePageCopyWith<FavoritePage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FavoritePageCopyWith<$Res> {
  factory $FavoritePageCopyWith(
          FavoritePage value, $Res Function(FavoritePage) then) =
      _$FavoritePageCopyWithImpl<$Res, FavoritePage>;
  @useResult
  $Res call(
      {int pageNumber,
      String title,
      String? description,
      String? regionCode,
      int order});
}

/// @nodoc
class _$FavoritePageCopyWithImpl<$Res, $Val extends FavoritePage>
    implements $FavoritePageCopyWith<$Res> {
  _$FavoritePageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FavoritePage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pageNumber = null,
    Object? title = null,
    Object? description = freezed,
    Object? regionCode = freezed,
    Object? order = null,
  }) {
    return _then(_value.copyWith(
      pageNumber: null == pageNumber
          ? _value.pageNumber
          : pageNumber // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      regionCode: freezed == regionCode
          ? _value.regionCode
          : regionCode // ignore: cast_nullable_to_non_nullable
              as String?,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FavoritePageImplCopyWith<$Res>
    implements $FavoritePageCopyWith<$Res> {
  factory _$$FavoritePageImplCopyWith(
          _$FavoritePageImpl value, $Res Function(_$FavoritePageImpl) then) =
      __$$FavoritePageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int pageNumber,
      String title,
      String? description,
      String? regionCode,
      int order});
}

/// @nodoc
class __$$FavoritePageImplCopyWithImpl<$Res>
    extends _$FavoritePageCopyWithImpl<$Res, _$FavoritePageImpl>
    implements _$$FavoritePageImplCopyWith<$Res> {
  __$$FavoritePageImplCopyWithImpl(
      _$FavoritePageImpl _value, $Res Function(_$FavoritePageImpl) _then)
      : super(_value, _then);

  /// Create a copy of FavoritePage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pageNumber = null,
    Object? title = null,
    Object? description = freezed,
    Object? regionCode = freezed,
    Object? order = null,
  }) {
    return _then(_$FavoritePageImpl(
      pageNumber: null == pageNumber
          ? _value.pageNumber
          : pageNumber // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      regionCode: freezed == regionCode
          ? _value.regionCode
          : regionCode // ignore: cast_nullable_to_non_nullable
              as String?,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FavoritePageImpl extends _FavoritePage {
  const _$FavoritePageImpl(
      {required this.pageNumber,
      required this.title,
      this.description,
      this.regionCode,
      this.order = 0})
      : super._();

  factory _$FavoritePageImpl.fromJson(Map<String, dynamic> json) =>
      _$$FavoritePageImplFromJson(json);

  @override
  final int pageNumber;
  @override
  final String title;
  @override
  final String? description;
  @override
  final String? regionCode;
  @override
  @JsonKey()
  final int order;

  @override
  String toString() {
    return 'FavoritePage(pageNumber: $pageNumber, title: $title, description: $description, regionCode: $regionCode, order: $order)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FavoritePageImpl &&
            (identical(other.pageNumber, pageNumber) ||
                other.pageNumber == pageNumber) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.regionCode, regionCode) ||
                other.regionCode == regionCode) &&
            (identical(other.order, order) || other.order == order));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, pageNumber, title, description, regionCode, order);

  /// Create a copy of FavoritePage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FavoritePageImplCopyWith<_$FavoritePageImpl> get copyWith =>
      __$$FavoritePageImplCopyWithImpl<_$FavoritePageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FavoritePageImplToJson(
      this,
    );
  }
}

abstract class _FavoritePage extends FavoritePage {
  const factory _FavoritePage(
      {required final int pageNumber,
      required final String title,
      final String? description,
      final String? regionCode,
      final int order}) = _$FavoritePageImpl;
  const _FavoritePage._() : super._();

  factory _FavoritePage.fromJson(Map<String, dynamic> json) =
      _$FavoritePageImpl.fromJson;

  @override
  int get pageNumber;
  @override
  String get title;
  @override
  String? get description;
  @override
  String? get regionCode;
  @override
  int get order;

  /// Create a copy of FavoritePage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FavoritePageImplCopyWith<_$FavoritePageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
