// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'region_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RegionEvent {
  Region? get region => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Region? region) selectRegion,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Region? region)? selectRegion,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Region? region)? selectRegion,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SelectRegion value) selectRegion,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_SelectRegion value)? selectRegion,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SelectRegion value)? selectRegion,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of RegionEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RegionEventCopyWith<RegionEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegionEventCopyWith<$Res> {
  factory $RegionEventCopyWith(
          RegionEvent value, $Res Function(RegionEvent) then) =
      _$RegionEventCopyWithImpl<$Res, RegionEvent>;
  @useResult
  $Res call({Region? region});
}

/// @nodoc
class _$RegionEventCopyWithImpl<$Res, $Val extends RegionEvent>
    implements $RegionEventCopyWith<$Res> {
  _$RegionEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RegionEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? region = freezed,
  }) {
    return _then(_value.copyWith(
      region: freezed == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as Region?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SelectRegionImplCopyWith<$Res>
    implements $RegionEventCopyWith<$Res> {
  factory _$$SelectRegionImplCopyWith(
          _$SelectRegionImpl value, $Res Function(_$SelectRegionImpl) then) =
      __$$SelectRegionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Region? region});
}

/// @nodoc
class __$$SelectRegionImplCopyWithImpl<$Res>
    extends _$RegionEventCopyWithImpl<$Res, _$SelectRegionImpl>
    implements _$$SelectRegionImplCopyWith<$Res> {
  __$$SelectRegionImplCopyWithImpl(
      _$SelectRegionImpl _value, $Res Function(_$SelectRegionImpl) _then)
      : super(_value, _then);

  /// Create a copy of RegionEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? region = freezed,
  }) {
    return _then(_$SelectRegionImpl(
      freezed == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as Region?,
    ));
  }
}

/// @nodoc

class _$SelectRegionImpl implements _SelectRegion {
  const _$SelectRegionImpl(this.region);

  @override
  final Region? region;

  @override
  String toString() {
    return 'RegionEvent.selectRegion(region: $region)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SelectRegionImpl &&
            (identical(other.region, region) || other.region == region));
  }

  @override
  int get hashCode => Object.hash(runtimeType, region);

  /// Create a copy of RegionEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SelectRegionImplCopyWith<_$SelectRegionImpl> get copyWith =>
      __$$SelectRegionImplCopyWithImpl<_$SelectRegionImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Region? region) selectRegion,
  }) {
    return selectRegion(region);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Region? region)? selectRegion,
  }) {
    return selectRegion?.call(region);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Region? region)? selectRegion,
    required TResult orElse(),
  }) {
    if (selectRegion != null) {
      return selectRegion(region);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SelectRegion value) selectRegion,
  }) {
    return selectRegion(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_SelectRegion value)? selectRegion,
  }) {
    return selectRegion?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SelectRegion value)? selectRegion,
    required TResult orElse(),
  }) {
    if (selectRegion != null) {
      return selectRegion(this);
    }
    return orElse();
  }
}

abstract class _SelectRegion implements RegionEvent {
  const factory _SelectRegion(final Region? region) = _$SelectRegionImpl;

  @override
  Region? get region;

  /// Create a copy of RegionEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SelectRegionImplCopyWith<_$SelectRegionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$RegionState {
  Region? get selectedRegion => throw _privateConstructorUsedError;

  /// Create a copy of RegionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RegionStateCopyWith<RegionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegionStateCopyWith<$Res> {
  factory $RegionStateCopyWith(
          RegionState value, $Res Function(RegionState) then) =
      _$RegionStateCopyWithImpl<$Res, RegionState>;
  @useResult
  $Res call({Region? selectedRegion});
}

/// @nodoc
class _$RegionStateCopyWithImpl<$Res, $Val extends RegionState>
    implements $RegionStateCopyWith<$Res> {
  _$RegionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RegionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedRegion = freezed,
  }) {
    return _then(_value.copyWith(
      selectedRegion: freezed == selectedRegion
          ? _value.selectedRegion
          : selectedRegion // ignore: cast_nullable_to_non_nullable
              as Region?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RegionStateImplCopyWith<$Res>
    implements $RegionStateCopyWith<$Res> {
  factory _$$RegionStateImplCopyWith(
          _$RegionStateImpl value, $Res Function(_$RegionStateImpl) then) =
      __$$RegionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Region? selectedRegion});
}

/// @nodoc
class __$$RegionStateImplCopyWithImpl<$Res>
    extends _$RegionStateCopyWithImpl<$Res, _$RegionStateImpl>
    implements _$$RegionStateImplCopyWith<$Res> {
  __$$RegionStateImplCopyWithImpl(
      _$RegionStateImpl _value, $Res Function(_$RegionStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of RegionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedRegion = freezed,
  }) {
    return _then(_$RegionStateImpl(
      selectedRegion: freezed == selectedRegion
          ? _value.selectedRegion
          : selectedRegion // ignore: cast_nullable_to_non_nullable
              as Region?,
    ));
  }
}

/// @nodoc

class _$RegionStateImpl implements _RegionState {
  const _$RegionStateImpl({required this.selectedRegion});

  @override
  final Region? selectedRegion;

  @override
  String toString() {
    return 'RegionState(selectedRegion: $selectedRegion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegionStateImpl &&
            (identical(other.selectedRegion, selectedRegion) ||
                other.selectedRegion == selectedRegion));
  }

  @override
  int get hashCode => Object.hash(runtimeType, selectedRegion);

  /// Create a copy of RegionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegionStateImplCopyWith<_$RegionStateImpl> get copyWith =>
      __$$RegionStateImplCopyWithImpl<_$RegionStateImpl>(this, _$identity);
}

abstract class _RegionState implements RegionState {
  const factory _RegionState({required final Region? selectedRegion}) =
      _$RegionStateImpl;

  @override
  Region? get selectedRegion;

  /// Create a copy of RegionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegionStateImplCopyWith<_$RegionStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
