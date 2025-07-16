// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shortcut_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ShortcutPage _$ShortcutPageFromJson(Map<String, dynamic> json) {
  return _ShortcutPage.fromJson(json);
}

/// @nodoc
mixin _$ShortcutPage {
  int get pageNumber => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;

  /// Serializes this ShortcutPage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShortcutPage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShortcutPageCopyWith<ShortcutPage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShortcutPageCopyWith<$Res> {
  factory $ShortcutPageCopyWith(
          ShortcutPage value, $Res Function(ShortcutPage) then) =
      _$ShortcutPageCopyWithImpl<$Res, ShortcutPage>;
  @useResult
  $Res call({int pageNumber, String title});
}

/// @nodoc
class _$ShortcutPageCopyWithImpl<$Res, $Val extends ShortcutPage>
    implements $ShortcutPageCopyWith<$Res> {
  _$ShortcutPageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShortcutPage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pageNumber = null,
    Object? title = null,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShortcutPageImplCopyWith<$Res>
    implements $ShortcutPageCopyWith<$Res> {
  factory _$$ShortcutPageImplCopyWith(
          _$ShortcutPageImpl value, $Res Function(_$ShortcutPageImpl) then) =
      __$$ShortcutPageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int pageNumber, String title});
}

/// @nodoc
class __$$ShortcutPageImplCopyWithImpl<$Res>
    extends _$ShortcutPageCopyWithImpl<$Res, _$ShortcutPageImpl>
    implements _$$ShortcutPageImplCopyWith<$Res> {
  __$$ShortcutPageImplCopyWithImpl(
      _$ShortcutPageImpl _value, $Res Function(_$ShortcutPageImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShortcutPage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pageNumber = null,
    Object? title = null,
  }) {
    return _then(_$ShortcutPageImpl(
      pageNumber: null == pageNumber
          ? _value.pageNumber
          : pageNumber // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ShortcutPageImpl implements _ShortcutPage {
  const _$ShortcutPageImpl({required this.pageNumber, required this.title});

  factory _$ShortcutPageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShortcutPageImplFromJson(json);

  @override
  final int pageNumber;
  @override
  final String title;

  @override
  String toString() {
    return 'ShortcutPage(pageNumber: $pageNumber, title: $title)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShortcutPageImpl &&
            (identical(other.pageNumber, pageNumber) ||
                other.pageNumber == pageNumber) &&
            (identical(other.title, title) || other.title == title));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, pageNumber, title);

  /// Create a copy of ShortcutPage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShortcutPageImplCopyWith<_$ShortcutPageImpl> get copyWith =>
      __$$ShortcutPageImplCopyWithImpl<_$ShortcutPageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShortcutPageImplToJson(
      this,
    );
  }
}

abstract class _ShortcutPage implements ShortcutPage {
  const factory _ShortcutPage(
      {required final int pageNumber,
      required final String title}) = _$ShortcutPageImpl;

  factory _ShortcutPage.fromJson(Map<String, dynamic> json) =
      _$ShortcutPageImpl.fromJson;

  @override
  int get pageNumber;
  @override
  String get title;

  /// Create a copy of ShortcutPage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShortcutPageImplCopyWith<_$ShortcutPageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
