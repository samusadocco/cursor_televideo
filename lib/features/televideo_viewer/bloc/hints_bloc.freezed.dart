// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hints_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HintsState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<Hint> activeHints) loaded,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<Hint> activeHints)? loaded,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<Hint> activeHints)? loaded,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HintsStateCopyWith<$Res> {
  factory $HintsStateCopyWith(
          HintsState value, $Res Function(HintsState) then) =
      _$HintsStateCopyWithImpl<$Res, HintsState>;
}

/// @nodoc
class _$HintsStateCopyWithImpl<$Res, $Val extends HintsState>
    implements $HintsStateCopyWith<$Res> {
  _$HintsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HintsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<$Res> {
  factory _$$LoadingImplCopyWith(
          _$LoadingImpl value, $Res Function(_$LoadingImpl) then) =
      __$$LoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<$Res>
    extends _$HintsStateCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
      _$LoadingImpl _value, $Res Function(_$LoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of HintsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingImpl implements _Loading {
  const _$LoadingImpl();

  @override
  String toString() {
    return 'HintsState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<Hint> activeHints) loaded,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<Hint> activeHints)? loaded,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<Hint> activeHints)? loaded,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading implements HintsState {
  const factory _Loading() = _$LoadingImpl;
}

/// @nodoc
abstract class _$$LoadedImplCopyWith<$Res> {
  factory _$$LoadedImplCopyWith(
          _$LoadedImpl value, $Res Function(_$LoadedImpl) then) =
      __$$LoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Hint> activeHints});
}

/// @nodoc
class __$$LoadedImplCopyWithImpl<$Res>
    extends _$HintsStateCopyWithImpl<$Res, _$LoadedImpl>
    implements _$$LoadedImplCopyWith<$Res> {
  __$$LoadedImplCopyWithImpl(
      _$LoadedImpl _value, $Res Function(_$LoadedImpl) _then)
      : super(_value, _then);

  /// Create a copy of HintsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activeHints = null,
  }) {
    return _then(_$LoadedImpl(
      null == activeHints
          ? _value._activeHints
          : activeHints // ignore: cast_nullable_to_non_nullable
              as List<Hint>,
    ));
  }
}

/// @nodoc

class _$LoadedImpl implements _Loaded {
  const _$LoadedImpl(final List<Hint> activeHints) : _activeHints = activeHints;

  final List<Hint> _activeHints;
  @override
  List<Hint> get activeHints {
    if (_activeHints is EqualUnmodifiableListView) return _activeHints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activeHints);
  }

  @override
  String toString() {
    return 'HintsState.loaded(activeHints: $activeHints)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadedImpl &&
            const DeepCollectionEquality()
                .equals(other._activeHints, _activeHints));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_activeHints));

  /// Create a copy of HintsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadedImplCopyWith<_$LoadedImpl> get copyWith =>
      __$$LoadedImplCopyWithImpl<_$LoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<Hint> activeHints) loaded,
  }) {
    return loaded(activeHints);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<Hint> activeHints)? loaded,
  }) {
    return loaded?.call(activeHints);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<Hint> activeHints)? loaded,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(activeHints);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class _Loaded implements HintsState {
  const factory _Loaded(final List<Hint> activeHints) = _$LoadedImpl;

  List<Hint> get activeHints;

  /// Create a copy of HintsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadedImplCopyWith<_$LoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$HintsEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadHints,
    required TResult Function(String hintId) dismissHint,
    required TResult Function() resetHints,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadHints,
    TResult? Function(String hintId)? dismissHint,
    TResult? Function()? resetHints,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadHints,
    TResult Function(String hintId)? dismissHint,
    TResult Function()? resetHints,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadHints value) loadHints,
    required TResult Function(_DismissHint value) dismissHint,
    required TResult Function(_ResetHints value) resetHints,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadHints value)? loadHints,
    TResult? Function(_DismissHint value)? dismissHint,
    TResult? Function(_ResetHints value)? resetHints,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadHints value)? loadHints,
    TResult Function(_DismissHint value)? dismissHint,
    TResult Function(_ResetHints value)? resetHints,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HintsEventCopyWith<$Res> {
  factory $HintsEventCopyWith(
          HintsEvent value, $Res Function(HintsEvent) then) =
      _$HintsEventCopyWithImpl<$Res, HintsEvent>;
}

/// @nodoc
class _$HintsEventCopyWithImpl<$Res, $Val extends HintsEvent>
    implements $HintsEventCopyWith<$Res> {
  _$HintsEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HintsEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$LoadHintsImplCopyWith<$Res> {
  factory _$$LoadHintsImplCopyWith(
          _$LoadHintsImpl value, $Res Function(_$LoadHintsImpl) then) =
      __$$LoadHintsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadHintsImplCopyWithImpl<$Res>
    extends _$HintsEventCopyWithImpl<$Res, _$LoadHintsImpl>
    implements _$$LoadHintsImplCopyWith<$Res> {
  __$$LoadHintsImplCopyWithImpl(
      _$LoadHintsImpl _value, $Res Function(_$LoadHintsImpl) _then)
      : super(_value, _then);

  /// Create a copy of HintsEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadHintsImpl implements _LoadHints {
  const _$LoadHintsImpl();

  @override
  String toString() {
    return 'HintsEvent.loadHints()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadHintsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadHints,
    required TResult Function(String hintId) dismissHint,
    required TResult Function() resetHints,
  }) {
    return loadHints();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadHints,
    TResult? Function(String hintId)? dismissHint,
    TResult? Function()? resetHints,
  }) {
    return loadHints?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadHints,
    TResult Function(String hintId)? dismissHint,
    TResult Function()? resetHints,
    required TResult orElse(),
  }) {
    if (loadHints != null) {
      return loadHints();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadHints value) loadHints,
    required TResult Function(_DismissHint value) dismissHint,
    required TResult Function(_ResetHints value) resetHints,
  }) {
    return loadHints(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadHints value)? loadHints,
    TResult? Function(_DismissHint value)? dismissHint,
    TResult? Function(_ResetHints value)? resetHints,
  }) {
    return loadHints?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadHints value)? loadHints,
    TResult Function(_DismissHint value)? dismissHint,
    TResult Function(_ResetHints value)? resetHints,
    required TResult orElse(),
  }) {
    if (loadHints != null) {
      return loadHints(this);
    }
    return orElse();
  }
}

abstract class _LoadHints implements HintsEvent {
  const factory _LoadHints() = _$LoadHintsImpl;
}

/// @nodoc
abstract class _$$DismissHintImplCopyWith<$Res> {
  factory _$$DismissHintImplCopyWith(
          _$DismissHintImpl value, $Res Function(_$DismissHintImpl) then) =
      __$$DismissHintImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String hintId});
}

/// @nodoc
class __$$DismissHintImplCopyWithImpl<$Res>
    extends _$HintsEventCopyWithImpl<$Res, _$DismissHintImpl>
    implements _$$DismissHintImplCopyWith<$Res> {
  __$$DismissHintImplCopyWithImpl(
      _$DismissHintImpl _value, $Res Function(_$DismissHintImpl) _then)
      : super(_value, _then);

  /// Create a copy of HintsEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hintId = null,
  }) {
    return _then(_$DismissHintImpl(
      null == hintId
          ? _value.hintId
          : hintId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$DismissHintImpl implements _DismissHint {
  const _$DismissHintImpl(this.hintId);

  @override
  final String hintId;

  @override
  String toString() {
    return 'HintsEvent.dismissHint(hintId: $hintId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DismissHintImpl &&
            (identical(other.hintId, hintId) || other.hintId == hintId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, hintId);

  /// Create a copy of HintsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DismissHintImplCopyWith<_$DismissHintImpl> get copyWith =>
      __$$DismissHintImplCopyWithImpl<_$DismissHintImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadHints,
    required TResult Function(String hintId) dismissHint,
    required TResult Function() resetHints,
  }) {
    return dismissHint(hintId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadHints,
    TResult? Function(String hintId)? dismissHint,
    TResult? Function()? resetHints,
  }) {
    return dismissHint?.call(hintId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadHints,
    TResult Function(String hintId)? dismissHint,
    TResult Function()? resetHints,
    required TResult orElse(),
  }) {
    if (dismissHint != null) {
      return dismissHint(hintId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadHints value) loadHints,
    required TResult Function(_DismissHint value) dismissHint,
    required TResult Function(_ResetHints value) resetHints,
  }) {
    return dismissHint(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadHints value)? loadHints,
    TResult? Function(_DismissHint value)? dismissHint,
    TResult? Function(_ResetHints value)? resetHints,
  }) {
    return dismissHint?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadHints value)? loadHints,
    TResult Function(_DismissHint value)? dismissHint,
    TResult Function(_ResetHints value)? resetHints,
    required TResult orElse(),
  }) {
    if (dismissHint != null) {
      return dismissHint(this);
    }
    return orElse();
  }
}

abstract class _DismissHint implements HintsEvent {
  const factory _DismissHint(final String hintId) = _$DismissHintImpl;

  String get hintId;

  /// Create a copy of HintsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DismissHintImplCopyWith<_$DismissHintImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ResetHintsImplCopyWith<$Res> {
  factory _$$ResetHintsImplCopyWith(
          _$ResetHintsImpl value, $Res Function(_$ResetHintsImpl) then) =
      __$$ResetHintsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ResetHintsImplCopyWithImpl<$Res>
    extends _$HintsEventCopyWithImpl<$Res, _$ResetHintsImpl>
    implements _$$ResetHintsImplCopyWith<$Res> {
  __$$ResetHintsImplCopyWithImpl(
      _$ResetHintsImpl _value, $Res Function(_$ResetHintsImpl) _then)
      : super(_value, _then);

  /// Create a copy of HintsEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ResetHintsImpl implements _ResetHints {
  const _$ResetHintsImpl();

  @override
  String toString() {
    return 'HintsEvent.resetHints()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ResetHintsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadHints,
    required TResult Function(String hintId) dismissHint,
    required TResult Function() resetHints,
  }) {
    return resetHints();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadHints,
    TResult? Function(String hintId)? dismissHint,
    TResult? Function()? resetHints,
  }) {
    return resetHints?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadHints,
    TResult Function(String hintId)? dismissHint,
    TResult Function()? resetHints,
    required TResult orElse(),
  }) {
    if (resetHints != null) {
      return resetHints();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadHints value) loadHints,
    required TResult Function(_DismissHint value) dismissHint,
    required TResult Function(_ResetHints value) resetHints,
  }) {
    return resetHints(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadHints value)? loadHints,
    TResult? Function(_DismissHint value)? dismissHint,
    TResult? Function(_ResetHints value)? resetHints,
  }) {
    return resetHints?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadHints value)? loadHints,
    TResult Function(_DismissHint value)? dismissHint,
    TResult Function(_ResetHints value)? resetHints,
    required TResult orElse(),
  }) {
    if (resetHints != null) {
      return resetHints(this);
    }
    return orElse();
  }
}

abstract class _ResetHints implements HintsEvent {
  const factory _ResetHints() = _$ResetHintsImpl;
}
