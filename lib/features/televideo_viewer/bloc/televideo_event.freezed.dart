// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'televideo_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TelevideoEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int pageNumber) loadNationalPage,
    required TResult Function(Region region, int pageNumber) loadRegionalPage,
    required TResult Function(int currentPage) nextPage,
    required TResult Function(int currentPage) previousPage,
    required TResult Function() nextSubPage,
    required TResult Function() previousSubPage,
    required TResult Function() startLoading,
    required TResult Function() toggleAutoRefreshPause,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int pageNumber)? loadNationalPage,
    TResult? Function(Region region, int pageNumber)? loadRegionalPage,
    TResult? Function(int currentPage)? nextPage,
    TResult? Function(int currentPage)? previousPage,
    TResult? Function()? nextSubPage,
    TResult? Function()? previousSubPage,
    TResult? Function()? startLoading,
    TResult? Function()? toggleAutoRefreshPause,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int pageNumber)? loadNationalPage,
    TResult Function(Region region, int pageNumber)? loadRegionalPage,
    TResult Function(int currentPage)? nextPage,
    TResult Function(int currentPage)? previousPage,
    TResult Function()? nextSubPage,
    TResult Function()? previousSubPage,
    TResult Function()? startLoading,
    TResult Function()? toggleAutoRefreshPause,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadNationalPage value) loadNationalPage,
    required TResult Function(_LoadRegionalPage value) loadRegionalPage,
    required TResult Function(_NextPage value) nextPage,
    required TResult Function(_PreviousPage value) previousPage,
    required TResult Function(_NextSubPage value) nextSubPage,
    required TResult Function(_PreviousSubPage value) previousSubPage,
    required TResult Function(_StartLoading value) startLoading,
    required TResult Function(_ToggleAutoRefreshPause value)
        toggleAutoRefreshPause,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadNationalPage value)? loadNationalPage,
    TResult? Function(_LoadRegionalPage value)? loadRegionalPage,
    TResult? Function(_NextPage value)? nextPage,
    TResult? Function(_PreviousPage value)? previousPage,
    TResult? Function(_NextSubPage value)? nextSubPage,
    TResult? Function(_PreviousSubPage value)? previousSubPage,
    TResult? Function(_StartLoading value)? startLoading,
    TResult? Function(_ToggleAutoRefreshPause value)? toggleAutoRefreshPause,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadNationalPage value)? loadNationalPage,
    TResult Function(_LoadRegionalPage value)? loadRegionalPage,
    TResult Function(_NextPage value)? nextPage,
    TResult Function(_PreviousPage value)? previousPage,
    TResult Function(_NextSubPage value)? nextSubPage,
    TResult Function(_PreviousSubPage value)? previousSubPage,
    TResult Function(_StartLoading value)? startLoading,
    TResult Function(_ToggleAutoRefreshPause value)? toggleAutoRefreshPause,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TelevideoEventCopyWith<$Res> {
  factory $TelevideoEventCopyWith(
          TelevideoEvent value, $Res Function(TelevideoEvent) then) =
      _$TelevideoEventCopyWithImpl<$Res, TelevideoEvent>;
}

/// @nodoc
class _$TelevideoEventCopyWithImpl<$Res, $Val extends TelevideoEvent>
    implements $TelevideoEventCopyWith<$Res> {
  _$TelevideoEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TelevideoEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$LoadNationalPageImplCopyWith<$Res> {
  factory _$$LoadNationalPageImplCopyWith(_$LoadNationalPageImpl value,
          $Res Function(_$LoadNationalPageImpl) then) =
      __$$LoadNationalPageImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int pageNumber});
}

/// @nodoc
class __$$LoadNationalPageImplCopyWithImpl<$Res>
    extends _$TelevideoEventCopyWithImpl<$Res, _$LoadNationalPageImpl>
    implements _$$LoadNationalPageImplCopyWith<$Res> {
  __$$LoadNationalPageImplCopyWithImpl(_$LoadNationalPageImpl _value,
      $Res Function(_$LoadNationalPageImpl) _then)
      : super(_value, _then);

  /// Create a copy of TelevideoEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pageNumber = null,
  }) {
    return _then(_$LoadNationalPageImpl(
      null == pageNumber
          ? _value.pageNumber
          : pageNumber // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$LoadNationalPageImpl implements _LoadNationalPage {
  const _$LoadNationalPageImpl(this.pageNumber);

  @override
  final int pageNumber;

  @override
  String toString() {
    return 'TelevideoEvent.loadNationalPage(pageNumber: $pageNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadNationalPageImpl &&
            (identical(other.pageNumber, pageNumber) ||
                other.pageNumber == pageNumber));
  }

  @override
  int get hashCode => Object.hash(runtimeType, pageNumber);

  /// Create a copy of TelevideoEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadNationalPageImplCopyWith<_$LoadNationalPageImpl> get copyWith =>
      __$$LoadNationalPageImplCopyWithImpl<_$LoadNationalPageImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int pageNumber) loadNationalPage,
    required TResult Function(Region region, int pageNumber) loadRegionalPage,
    required TResult Function(int currentPage) nextPage,
    required TResult Function(int currentPage) previousPage,
    required TResult Function() nextSubPage,
    required TResult Function() previousSubPage,
    required TResult Function() startLoading,
    required TResult Function() toggleAutoRefreshPause,
  }) {
    return loadNationalPage(pageNumber);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int pageNumber)? loadNationalPage,
    TResult? Function(Region region, int pageNumber)? loadRegionalPage,
    TResult? Function(int currentPage)? nextPage,
    TResult? Function(int currentPage)? previousPage,
    TResult? Function()? nextSubPage,
    TResult? Function()? previousSubPage,
    TResult? Function()? startLoading,
    TResult? Function()? toggleAutoRefreshPause,
  }) {
    return loadNationalPage?.call(pageNumber);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int pageNumber)? loadNationalPage,
    TResult Function(Region region, int pageNumber)? loadRegionalPage,
    TResult Function(int currentPage)? nextPage,
    TResult Function(int currentPage)? previousPage,
    TResult Function()? nextSubPage,
    TResult Function()? previousSubPage,
    TResult Function()? startLoading,
    TResult Function()? toggleAutoRefreshPause,
    required TResult orElse(),
  }) {
    if (loadNationalPage != null) {
      return loadNationalPage(pageNumber);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadNationalPage value) loadNationalPage,
    required TResult Function(_LoadRegionalPage value) loadRegionalPage,
    required TResult Function(_NextPage value) nextPage,
    required TResult Function(_PreviousPage value) previousPage,
    required TResult Function(_NextSubPage value) nextSubPage,
    required TResult Function(_PreviousSubPage value) previousSubPage,
    required TResult Function(_StartLoading value) startLoading,
    required TResult Function(_ToggleAutoRefreshPause value)
        toggleAutoRefreshPause,
  }) {
    return loadNationalPage(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadNationalPage value)? loadNationalPage,
    TResult? Function(_LoadRegionalPage value)? loadRegionalPage,
    TResult? Function(_NextPage value)? nextPage,
    TResult? Function(_PreviousPage value)? previousPage,
    TResult? Function(_NextSubPage value)? nextSubPage,
    TResult? Function(_PreviousSubPage value)? previousSubPage,
    TResult? Function(_StartLoading value)? startLoading,
    TResult? Function(_ToggleAutoRefreshPause value)? toggleAutoRefreshPause,
  }) {
    return loadNationalPage?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadNationalPage value)? loadNationalPage,
    TResult Function(_LoadRegionalPage value)? loadRegionalPage,
    TResult Function(_NextPage value)? nextPage,
    TResult Function(_PreviousPage value)? previousPage,
    TResult Function(_NextSubPage value)? nextSubPage,
    TResult Function(_PreviousSubPage value)? previousSubPage,
    TResult Function(_StartLoading value)? startLoading,
    TResult Function(_ToggleAutoRefreshPause value)? toggleAutoRefreshPause,
    required TResult orElse(),
  }) {
    if (loadNationalPage != null) {
      return loadNationalPage(this);
    }
    return orElse();
  }
}

abstract class _LoadNationalPage implements TelevideoEvent {
  const factory _LoadNationalPage(final int pageNumber) =
      _$LoadNationalPageImpl;

  int get pageNumber;

  /// Create a copy of TelevideoEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadNationalPageImplCopyWith<_$LoadNationalPageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadRegionalPageImplCopyWith<$Res> {
  factory _$$LoadRegionalPageImplCopyWith(_$LoadRegionalPageImpl value,
          $Res Function(_$LoadRegionalPageImpl) then) =
      __$$LoadRegionalPageImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Region region, int pageNumber});
}

/// @nodoc
class __$$LoadRegionalPageImplCopyWithImpl<$Res>
    extends _$TelevideoEventCopyWithImpl<$Res, _$LoadRegionalPageImpl>
    implements _$$LoadRegionalPageImplCopyWith<$Res> {
  __$$LoadRegionalPageImplCopyWithImpl(_$LoadRegionalPageImpl _value,
      $Res Function(_$LoadRegionalPageImpl) _then)
      : super(_value, _then);

  /// Create a copy of TelevideoEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? region = null,
    Object? pageNumber = null,
  }) {
    return _then(_$LoadRegionalPageImpl(
      null == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as Region,
      null == pageNumber
          ? _value.pageNumber
          : pageNumber // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$LoadRegionalPageImpl implements _LoadRegionalPage {
  const _$LoadRegionalPageImpl(this.region, this.pageNumber);

  @override
  final Region region;
  @override
  final int pageNumber;

  @override
  String toString() {
    return 'TelevideoEvent.loadRegionalPage(region: $region, pageNumber: $pageNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadRegionalPageImpl &&
            (identical(other.region, region) || other.region == region) &&
            (identical(other.pageNumber, pageNumber) ||
                other.pageNumber == pageNumber));
  }

  @override
  int get hashCode => Object.hash(runtimeType, region, pageNumber);

  /// Create a copy of TelevideoEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadRegionalPageImplCopyWith<_$LoadRegionalPageImpl> get copyWith =>
      __$$LoadRegionalPageImplCopyWithImpl<_$LoadRegionalPageImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int pageNumber) loadNationalPage,
    required TResult Function(Region region, int pageNumber) loadRegionalPage,
    required TResult Function(int currentPage) nextPage,
    required TResult Function(int currentPage) previousPage,
    required TResult Function() nextSubPage,
    required TResult Function() previousSubPage,
    required TResult Function() startLoading,
    required TResult Function() toggleAutoRefreshPause,
  }) {
    return loadRegionalPage(region, pageNumber);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int pageNumber)? loadNationalPage,
    TResult? Function(Region region, int pageNumber)? loadRegionalPage,
    TResult? Function(int currentPage)? nextPage,
    TResult? Function(int currentPage)? previousPage,
    TResult? Function()? nextSubPage,
    TResult? Function()? previousSubPage,
    TResult? Function()? startLoading,
    TResult? Function()? toggleAutoRefreshPause,
  }) {
    return loadRegionalPage?.call(region, pageNumber);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int pageNumber)? loadNationalPage,
    TResult Function(Region region, int pageNumber)? loadRegionalPage,
    TResult Function(int currentPage)? nextPage,
    TResult Function(int currentPage)? previousPage,
    TResult Function()? nextSubPage,
    TResult Function()? previousSubPage,
    TResult Function()? startLoading,
    TResult Function()? toggleAutoRefreshPause,
    required TResult orElse(),
  }) {
    if (loadRegionalPage != null) {
      return loadRegionalPage(region, pageNumber);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadNationalPage value) loadNationalPage,
    required TResult Function(_LoadRegionalPage value) loadRegionalPage,
    required TResult Function(_NextPage value) nextPage,
    required TResult Function(_PreviousPage value) previousPage,
    required TResult Function(_NextSubPage value) nextSubPage,
    required TResult Function(_PreviousSubPage value) previousSubPage,
    required TResult Function(_StartLoading value) startLoading,
    required TResult Function(_ToggleAutoRefreshPause value)
        toggleAutoRefreshPause,
  }) {
    return loadRegionalPage(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadNationalPage value)? loadNationalPage,
    TResult? Function(_LoadRegionalPage value)? loadRegionalPage,
    TResult? Function(_NextPage value)? nextPage,
    TResult? Function(_PreviousPage value)? previousPage,
    TResult? Function(_NextSubPage value)? nextSubPage,
    TResult? Function(_PreviousSubPage value)? previousSubPage,
    TResult? Function(_StartLoading value)? startLoading,
    TResult? Function(_ToggleAutoRefreshPause value)? toggleAutoRefreshPause,
  }) {
    return loadRegionalPage?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadNationalPage value)? loadNationalPage,
    TResult Function(_LoadRegionalPage value)? loadRegionalPage,
    TResult Function(_NextPage value)? nextPage,
    TResult Function(_PreviousPage value)? previousPage,
    TResult Function(_NextSubPage value)? nextSubPage,
    TResult Function(_PreviousSubPage value)? previousSubPage,
    TResult Function(_StartLoading value)? startLoading,
    TResult Function(_ToggleAutoRefreshPause value)? toggleAutoRefreshPause,
    required TResult orElse(),
  }) {
    if (loadRegionalPage != null) {
      return loadRegionalPage(this);
    }
    return orElse();
  }
}

abstract class _LoadRegionalPage implements TelevideoEvent {
  const factory _LoadRegionalPage(final Region region, final int pageNumber) =
      _$LoadRegionalPageImpl;

  Region get region;
  int get pageNumber;

  /// Create a copy of TelevideoEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadRegionalPageImplCopyWith<_$LoadRegionalPageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NextPageImplCopyWith<$Res> {
  factory _$$NextPageImplCopyWith(
          _$NextPageImpl value, $Res Function(_$NextPageImpl) then) =
      __$$NextPageImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int currentPage});
}

/// @nodoc
class __$$NextPageImplCopyWithImpl<$Res>
    extends _$TelevideoEventCopyWithImpl<$Res, _$NextPageImpl>
    implements _$$NextPageImplCopyWith<$Res> {
  __$$NextPageImplCopyWithImpl(
      _$NextPageImpl _value, $Res Function(_$NextPageImpl) _then)
      : super(_value, _then);

  /// Create a copy of TelevideoEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPage = null,
  }) {
    return _then(_$NextPageImpl(
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$NextPageImpl implements _NextPage {
  const _$NextPageImpl({required this.currentPage});

  @override
  final int currentPage;

  @override
  String toString() {
    return 'TelevideoEvent.nextPage(currentPage: $currentPage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NextPageImpl &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currentPage);

  /// Create a copy of TelevideoEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NextPageImplCopyWith<_$NextPageImpl> get copyWith =>
      __$$NextPageImplCopyWithImpl<_$NextPageImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int pageNumber) loadNationalPage,
    required TResult Function(Region region, int pageNumber) loadRegionalPage,
    required TResult Function(int currentPage) nextPage,
    required TResult Function(int currentPage) previousPage,
    required TResult Function() nextSubPage,
    required TResult Function() previousSubPage,
    required TResult Function() startLoading,
    required TResult Function() toggleAutoRefreshPause,
  }) {
    return nextPage(currentPage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int pageNumber)? loadNationalPage,
    TResult? Function(Region region, int pageNumber)? loadRegionalPage,
    TResult? Function(int currentPage)? nextPage,
    TResult? Function(int currentPage)? previousPage,
    TResult? Function()? nextSubPage,
    TResult? Function()? previousSubPage,
    TResult? Function()? startLoading,
    TResult? Function()? toggleAutoRefreshPause,
  }) {
    return nextPage?.call(currentPage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int pageNumber)? loadNationalPage,
    TResult Function(Region region, int pageNumber)? loadRegionalPage,
    TResult Function(int currentPage)? nextPage,
    TResult Function(int currentPage)? previousPage,
    TResult Function()? nextSubPage,
    TResult Function()? previousSubPage,
    TResult Function()? startLoading,
    TResult Function()? toggleAutoRefreshPause,
    required TResult orElse(),
  }) {
    if (nextPage != null) {
      return nextPage(currentPage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadNationalPage value) loadNationalPage,
    required TResult Function(_LoadRegionalPage value) loadRegionalPage,
    required TResult Function(_NextPage value) nextPage,
    required TResult Function(_PreviousPage value) previousPage,
    required TResult Function(_NextSubPage value) nextSubPage,
    required TResult Function(_PreviousSubPage value) previousSubPage,
    required TResult Function(_StartLoading value) startLoading,
    required TResult Function(_ToggleAutoRefreshPause value)
        toggleAutoRefreshPause,
  }) {
    return nextPage(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadNationalPage value)? loadNationalPage,
    TResult? Function(_LoadRegionalPage value)? loadRegionalPage,
    TResult? Function(_NextPage value)? nextPage,
    TResult? Function(_PreviousPage value)? previousPage,
    TResult? Function(_NextSubPage value)? nextSubPage,
    TResult? Function(_PreviousSubPage value)? previousSubPage,
    TResult? Function(_StartLoading value)? startLoading,
    TResult? Function(_ToggleAutoRefreshPause value)? toggleAutoRefreshPause,
  }) {
    return nextPage?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadNationalPage value)? loadNationalPage,
    TResult Function(_LoadRegionalPage value)? loadRegionalPage,
    TResult Function(_NextPage value)? nextPage,
    TResult Function(_PreviousPage value)? previousPage,
    TResult Function(_NextSubPage value)? nextSubPage,
    TResult Function(_PreviousSubPage value)? previousSubPage,
    TResult Function(_StartLoading value)? startLoading,
    TResult Function(_ToggleAutoRefreshPause value)? toggleAutoRefreshPause,
    required TResult orElse(),
  }) {
    if (nextPage != null) {
      return nextPage(this);
    }
    return orElse();
  }
}

abstract class _NextPage implements TelevideoEvent {
  const factory _NextPage({required final int currentPage}) = _$NextPageImpl;

  int get currentPage;

  /// Create a copy of TelevideoEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NextPageImplCopyWith<_$NextPageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PreviousPageImplCopyWith<$Res> {
  factory _$$PreviousPageImplCopyWith(
          _$PreviousPageImpl value, $Res Function(_$PreviousPageImpl) then) =
      __$$PreviousPageImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int currentPage});
}

/// @nodoc
class __$$PreviousPageImplCopyWithImpl<$Res>
    extends _$TelevideoEventCopyWithImpl<$Res, _$PreviousPageImpl>
    implements _$$PreviousPageImplCopyWith<$Res> {
  __$$PreviousPageImplCopyWithImpl(
      _$PreviousPageImpl _value, $Res Function(_$PreviousPageImpl) _then)
      : super(_value, _then);

  /// Create a copy of TelevideoEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPage = null,
  }) {
    return _then(_$PreviousPageImpl(
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$PreviousPageImpl implements _PreviousPage {
  const _$PreviousPageImpl({required this.currentPage});

  @override
  final int currentPage;

  @override
  String toString() {
    return 'TelevideoEvent.previousPage(currentPage: $currentPage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PreviousPageImpl &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currentPage);

  /// Create a copy of TelevideoEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PreviousPageImplCopyWith<_$PreviousPageImpl> get copyWith =>
      __$$PreviousPageImplCopyWithImpl<_$PreviousPageImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int pageNumber) loadNationalPage,
    required TResult Function(Region region, int pageNumber) loadRegionalPage,
    required TResult Function(int currentPage) nextPage,
    required TResult Function(int currentPage) previousPage,
    required TResult Function() nextSubPage,
    required TResult Function() previousSubPage,
    required TResult Function() startLoading,
    required TResult Function() toggleAutoRefreshPause,
  }) {
    return previousPage(currentPage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int pageNumber)? loadNationalPage,
    TResult? Function(Region region, int pageNumber)? loadRegionalPage,
    TResult? Function(int currentPage)? nextPage,
    TResult? Function(int currentPage)? previousPage,
    TResult? Function()? nextSubPage,
    TResult? Function()? previousSubPage,
    TResult? Function()? startLoading,
    TResult? Function()? toggleAutoRefreshPause,
  }) {
    return previousPage?.call(currentPage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int pageNumber)? loadNationalPage,
    TResult Function(Region region, int pageNumber)? loadRegionalPage,
    TResult Function(int currentPage)? nextPage,
    TResult Function(int currentPage)? previousPage,
    TResult Function()? nextSubPage,
    TResult Function()? previousSubPage,
    TResult Function()? startLoading,
    TResult Function()? toggleAutoRefreshPause,
    required TResult orElse(),
  }) {
    if (previousPage != null) {
      return previousPage(currentPage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadNationalPage value) loadNationalPage,
    required TResult Function(_LoadRegionalPage value) loadRegionalPage,
    required TResult Function(_NextPage value) nextPage,
    required TResult Function(_PreviousPage value) previousPage,
    required TResult Function(_NextSubPage value) nextSubPage,
    required TResult Function(_PreviousSubPage value) previousSubPage,
    required TResult Function(_StartLoading value) startLoading,
    required TResult Function(_ToggleAutoRefreshPause value)
        toggleAutoRefreshPause,
  }) {
    return previousPage(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadNationalPage value)? loadNationalPage,
    TResult? Function(_LoadRegionalPage value)? loadRegionalPage,
    TResult? Function(_NextPage value)? nextPage,
    TResult? Function(_PreviousPage value)? previousPage,
    TResult? Function(_NextSubPage value)? nextSubPage,
    TResult? Function(_PreviousSubPage value)? previousSubPage,
    TResult? Function(_StartLoading value)? startLoading,
    TResult? Function(_ToggleAutoRefreshPause value)? toggleAutoRefreshPause,
  }) {
    return previousPage?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadNationalPage value)? loadNationalPage,
    TResult Function(_LoadRegionalPage value)? loadRegionalPage,
    TResult Function(_NextPage value)? nextPage,
    TResult Function(_PreviousPage value)? previousPage,
    TResult Function(_NextSubPage value)? nextSubPage,
    TResult Function(_PreviousSubPage value)? previousSubPage,
    TResult Function(_StartLoading value)? startLoading,
    TResult Function(_ToggleAutoRefreshPause value)? toggleAutoRefreshPause,
    required TResult orElse(),
  }) {
    if (previousPage != null) {
      return previousPage(this);
    }
    return orElse();
  }
}

abstract class _PreviousPage implements TelevideoEvent {
  const factory _PreviousPage({required final int currentPage}) =
      _$PreviousPageImpl;

  int get currentPage;

  /// Create a copy of TelevideoEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PreviousPageImplCopyWith<_$PreviousPageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NextSubPageImplCopyWith<$Res> {
  factory _$$NextSubPageImplCopyWith(
          _$NextSubPageImpl value, $Res Function(_$NextSubPageImpl) then) =
      __$$NextSubPageImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NextSubPageImplCopyWithImpl<$Res>
    extends _$TelevideoEventCopyWithImpl<$Res, _$NextSubPageImpl>
    implements _$$NextSubPageImplCopyWith<$Res> {
  __$$NextSubPageImplCopyWithImpl(
      _$NextSubPageImpl _value, $Res Function(_$NextSubPageImpl) _then)
      : super(_value, _then);

  /// Create a copy of TelevideoEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$NextSubPageImpl implements _NextSubPage {
  const _$NextSubPageImpl();

  @override
  String toString() {
    return 'TelevideoEvent.nextSubPage()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$NextSubPageImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int pageNumber) loadNationalPage,
    required TResult Function(Region region, int pageNumber) loadRegionalPage,
    required TResult Function(int currentPage) nextPage,
    required TResult Function(int currentPage) previousPage,
    required TResult Function() nextSubPage,
    required TResult Function() previousSubPage,
    required TResult Function() startLoading,
    required TResult Function() toggleAutoRefreshPause,
  }) {
    return nextSubPage();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int pageNumber)? loadNationalPage,
    TResult? Function(Region region, int pageNumber)? loadRegionalPage,
    TResult? Function(int currentPage)? nextPage,
    TResult? Function(int currentPage)? previousPage,
    TResult? Function()? nextSubPage,
    TResult? Function()? previousSubPage,
    TResult? Function()? startLoading,
    TResult? Function()? toggleAutoRefreshPause,
  }) {
    return nextSubPage?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int pageNumber)? loadNationalPage,
    TResult Function(Region region, int pageNumber)? loadRegionalPage,
    TResult Function(int currentPage)? nextPage,
    TResult Function(int currentPage)? previousPage,
    TResult Function()? nextSubPage,
    TResult Function()? previousSubPage,
    TResult Function()? startLoading,
    TResult Function()? toggleAutoRefreshPause,
    required TResult orElse(),
  }) {
    if (nextSubPage != null) {
      return nextSubPage();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadNationalPage value) loadNationalPage,
    required TResult Function(_LoadRegionalPage value) loadRegionalPage,
    required TResult Function(_NextPage value) nextPage,
    required TResult Function(_PreviousPage value) previousPage,
    required TResult Function(_NextSubPage value) nextSubPage,
    required TResult Function(_PreviousSubPage value) previousSubPage,
    required TResult Function(_StartLoading value) startLoading,
    required TResult Function(_ToggleAutoRefreshPause value)
        toggleAutoRefreshPause,
  }) {
    return nextSubPage(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadNationalPage value)? loadNationalPage,
    TResult? Function(_LoadRegionalPage value)? loadRegionalPage,
    TResult? Function(_NextPage value)? nextPage,
    TResult? Function(_PreviousPage value)? previousPage,
    TResult? Function(_NextSubPage value)? nextSubPage,
    TResult? Function(_PreviousSubPage value)? previousSubPage,
    TResult? Function(_StartLoading value)? startLoading,
    TResult? Function(_ToggleAutoRefreshPause value)? toggleAutoRefreshPause,
  }) {
    return nextSubPage?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadNationalPage value)? loadNationalPage,
    TResult Function(_LoadRegionalPage value)? loadRegionalPage,
    TResult Function(_NextPage value)? nextPage,
    TResult Function(_PreviousPage value)? previousPage,
    TResult Function(_NextSubPage value)? nextSubPage,
    TResult Function(_PreviousSubPage value)? previousSubPage,
    TResult Function(_StartLoading value)? startLoading,
    TResult Function(_ToggleAutoRefreshPause value)? toggleAutoRefreshPause,
    required TResult orElse(),
  }) {
    if (nextSubPage != null) {
      return nextSubPage(this);
    }
    return orElse();
  }
}

abstract class _NextSubPage implements TelevideoEvent {
  const factory _NextSubPage() = _$NextSubPageImpl;
}

/// @nodoc
abstract class _$$PreviousSubPageImplCopyWith<$Res> {
  factory _$$PreviousSubPageImplCopyWith(_$PreviousSubPageImpl value,
          $Res Function(_$PreviousSubPageImpl) then) =
      __$$PreviousSubPageImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PreviousSubPageImplCopyWithImpl<$Res>
    extends _$TelevideoEventCopyWithImpl<$Res, _$PreviousSubPageImpl>
    implements _$$PreviousSubPageImplCopyWith<$Res> {
  __$$PreviousSubPageImplCopyWithImpl(
      _$PreviousSubPageImpl _value, $Res Function(_$PreviousSubPageImpl) _then)
      : super(_value, _then);

  /// Create a copy of TelevideoEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PreviousSubPageImpl implements _PreviousSubPage {
  const _$PreviousSubPageImpl();

  @override
  String toString() {
    return 'TelevideoEvent.previousSubPage()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$PreviousSubPageImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int pageNumber) loadNationalPage,
    required TResult Function(Region region, int pageNumber) loadRegionalPage,
    required TResult Function(int currentPage) nextPage,
    required TResult Function(int currentPage) previousPage,
    required TResult Function() nextSubPage,
    required TResult Function() previousSubPage,
    required TResult Function() startLoading,
    required TResult Function() toggleAutoRefreshPause,
  }) {
    return previousSubPage();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int pageNumber)? loadNationalPage,
    TResult? Function(Region region, int pageNumber)? loadRegionalPage,
    TResult? Function(int currentPage)? nextPage,
    TResult? Function(int currentPage)? previousPage,
    TResult? Function()? nextSubPage,
    TResult? Function()? previousSubPage,
    TResult? Function()? startLoading,
    TResult? Function()? toggleAutoRefreshPause,
  }) {
    return previousSubPage?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int pageNumber)? loadNationalPage,
    TResult Function(Region region, int pageNumber)? loadRegionalPage,
    TResult Function(int currentPage)? nextPage,
    TResult Function(int currentPage)? previousPage,
    TResult Function()? nextSubPage,
    TResult Function()? previousSubPage,
    TResult Function()? startLoading,
    TResult Function()? toggleAutoRefreshPause,
    required TResult orElse(),
  }) {
    if (previousSubPage != null) {
      return previousSubPage();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadNationalPage value) loadNationalPage,
    required TResult Function(_LoadRegionalPage value) loadRegionalPage,
    required TResult Function(_NextPage value) nextPage,
    required TResult Function(_PreviousPage value) previousPage,
    required TResult Function(_NextSubPage value) nextSubPage,
    required TResult Function(_PreviousSubPage value) previousSubPage,
    required TResult Function(_StartLoading value) startLoading,
    required TResult Function(_ToggleAutoRefreshPause value)
        toggleAutoRefreshPause,
  }) {
    return previousSubPage(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadNationalPage value)? loadNationalPage,
    TResult? Function(_LoadRegionalPage value)? loadRegionalPage,
    TResult? Function(_NextPage value)? nextPage,
    TResult? Function(_PreviousPage value)? previousPage,
    TResult? Function(_NextSubPage value)? nextSubPage,
    TResult? Function(_PreviousSubPage value)? previousSubPage,
    TResult? Function(_StartLoading value)? startLoading,
    TResult? Function(_ToggleAutoRefreshPause value)? toggleAutoRefreshPause,
  }) {
    return previousSubPage?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadNationalPage value)? loadNationalPage,
    TResult Function(_LoadRegionalPage value)? loadRegionalPage,
    TResult Function(_NextPage value)? nextPage,
    TResult Function(_PreviousPage value)? previousPage,
    TResult Function(_NextSubPage value)? nextSubPage,
    TResult Function(_PreviousSubPage value)? previousSubPage,
    TResult Function(_StartLoading value)? startLoading,
    TResult Function(_ToggleAutoRefreshPause value)? toggleAutoRefreshPause,
    required TResult orElse(),
  }) {
    if (previousSubPage != null) {
      return previousSubPage(this);
    }
    return orElse();
  }
}

abstract class _PreviousSubPage implements TelevideoEvent {
  const factory _PreviousSubPage() = _$PreviousSubPageImpl;
}

/// @nodoc
abstract class _$$StartLoadingImplCopyWith<$Res> {
  factory _$$StartLoadingImplCopyWith(
          _$StartLoadingImpl value, $Res Function(_$StartLoadingImpl) then) =
      __$$StartLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$StartLoadingImplCopyWithImpl<$Res>
    extends _$TelevideoEventCopyWithImpl<$Res, _$StartLoadingImpl>
    implements _$$StartLoadingImplCopyWith<$Res> {
  __$$StartLoadingImplCopyWithImpl(
      _$StartLoadingImpl _value, $Res Function(_$StartLoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of TelevideoEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$StartLoadingImpl implements _StartLoading {
  const _$StartLoadingImpl();

  @override
  String toString() {
    return 'TelevideoEvent.startLoading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$StartLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int pageNumber) loadNationalPage,
    required TResult Function(Region region, int pageNumber) loadRegionalPage,
    required TResult Function(int currentPage) nextPage,
    required TResult Function(int currentPage) previousPage,
    required TResult Function() nextSubPage,
    required TResult Function() previousSubPage,
    required TResult Function() startLoading,
    required TResult Function() toggleAutoRefreshPause,
  }) {
    return startLoading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int pageNumber)? loadNationalPage,
    TResult? Function(Region region, int pageNumber)? loadRegionalPage,
    TResult? Function(int currentPage)? nextPage,
    TResult? Function(int currentPage)? previousPage,
    TResult? Function()? nextSubPage,
    TResult? Function()? previousSubPage,
    TResult? Function()? startLoading,
    TResult? Function()? toggleAutoRefreshPause,
  }) {
    return startLoading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int pageNumber)? loadNationalPage,
    TResult Function(Region region, int pageNumber)? loadRegionalPage,
    TResult Function(int currentPage)? nextPage,
    TResult Function(int currentPage)? previousPage,
    TResult Function()? nextSubPage,
    TResult Function()? previousSubPage,
    TResult Function()? startLoading,
    TResult Function()? toggleAutoRefreshPause,
    required TResult orElse(),
  }) {
    if (startLoading != null) {
      return startLoading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadNationalPage value) loadNationalPage,
    required TResult Function(_LoadRegionalPage value) loadRegionalPage,
    required TResult Function(_NextPage value) nextPage,
    required TResult Function(_PreviousPage value) previousPage,
    required TResult Function(_NextSubPage value) nextSubPage,
    required TResult Function(_PreviousSubPage value) previousSubPage,
    required TResult Function(_StartLoading value) startLoading,
    required TResult Function(_ToggleAutoRefreshPause value)
        toggleAutoRefreshPause,
  }) {
    return startLoading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadNationalPage value)? loadNationalPage,
    TResult? Function(_LoadRegionalPage value)? loadRegionalPage,
    TResult? Function(_NextPage value)? nextPage,
    TResult? Function(_PreviousPage value)? previousPage,
    TResult? Function(_NextSubPage value)? nextSubPage,
    TResult? Function(_PreviousSubPage value)? previousSubPage,
    TResult? Function(_StartLoading value)? startLoading,
    TResult? Function(_ToggleAutoRefreshPause value)? toggleAutoRefreshPause,
  }) {
    return startLoading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadNationalPage value)? loadNationalPage,
    TResult Function(_LoadRegionalPage value)? loadRegionalPage,
    TResult Function(_NextPage value)? nextPage,
    TResult Function(_PreviousPage value)? previousPage,
    TResult Function(_NextSubPage value)? nextSubPage,
    TResult Function(_PreviousSubPage value)? previousSubPage,
    TResult Function(_StartLoading value)? startLoading,
    TResult Function(_ToggleAutoRefreshPause value)? toggleAutoRefreshPause,
    required TResult orElse(),
  }) {
    if (startLoading != null) {
      return startLoading(this);
    }
    return orElse();
  }
}

abstract class _StartLoading implements TelevideoEvent {
  const factory _StartLoading() = _$StartLoadingImpl;
}

/// @nodoc
abstract class _$$ToggleAutoRefreshPauseImplCopyWith<$Res> {
  factory _$$ToggleAutoRefreshPauseImplCopyWith(
          _$ToggleAutoRefreshPauseImpl value,
          $Res Function(_$ToggleAutoRefreshPauseImpl) then) =
      __$$ToggleAutoRefreshPauseImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ToggleAutoRefreshPauseImplCopyWithImpl<$Res>
    extends _$TelevideoEventCopyWithImpl<$Res, _$ToggleAutoRefreshPauseImpl>
    implements _$$ToggleAutoRefreshPauseImplCopyWith<$Res> {
  __$$ToggleAutoRefreshPauseImplCopyWithImpl(
      _$ToggleAutoRefreshPauseImpl _value,
      $Res Function(_$ToggleAutoRefreshPauseImpl) _then)
      : super(_value, _then);

  /// Create a copy of TelevideoEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ToggleAutoRefreshPauseImpl implements _ToggleAutoRefreshPause {
  const _$ToggleAutoRefreshPauseImpl();

  @override
  String toString() {
    return 'TelevideoEvent.toggleAutoRefreshPause()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ToggleAutoRefreshPauseImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int pageNumber) loadNationalPage,
    required TResult Function(Region region, int pageNumber) loadRegionalPage,
    required TResult Function(int currentPage) nextPage,
    required TResult Function(int currentPage) previousPage,
    required TResult Function() nextSubPage,
    required TResult Function() previousSubPage,
    required TResult Function() startLoading,
    required TResult Function() toggleAutoRefreshPause,
  }) {
    return toggleAutoRefreshPause();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int pageNumber)? loadNationalPage,
    TResult? Function(Region region, int pageNumber)? loadRegionalPage,
    TResult? Function(int currentPage)? nextPage,
    TResult? Function(int currentPage)? previousPage,
    TResult? Function()? nextSubPage,
    TResult? Function()? previousSubPage,
    TResult? Function()? startLoading,
    TResult? Function()? toggleAutoRefreshPause,
  }) {
    return toggleAutoRefreshPause?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int pageNumber)? loadNationalPage,
    TResult Function(Region region, int pageNumber)? loadRegionalPage,
    TResult Function(int currentPage)? nextPage,
    TResult Function(int currentPage)? previousPage,
    TResult Function()? nextSubPage,
    TResult Function()? previousSubPage,
    TResult Function()? startLoading,
    TResult Function()? toggleAutoRefreshPause,
    required TResult orElse(),
  }) {
    if (toggleAutoRefreshPause != null) {
      return toggleAutoRefreshPause();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadNationalPage value) loadNationalPage,
    required TResult Function(_LoadRegionalPage value) loadRegionalPage,
    required TResult Function(_NextPage value) nextPage,
    required TResult Function(_PreviousPage value) previousPage,
    required TResult Function(_NextSubPage value) nextSubPage,
    required TResult Function(_PreviousSubPage value) previousSubPage,
    required TResult Function(_StartLoading value) startLoading,
    required TResult Function(_ToggleAutoRefreshPause value)
        toggleAutoRefreshPause,
  }) {
    return toggleAutoRefreshPause(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadNationalPage value)? loadNationalPage,
    TResult? Function(_LoadRegionalPage value)? loadRegionalPage,
    TResult? Function(_NextPage value)? nextPage,
    TResult? Function(_PreviousPage value)? previousPage,
    TResult? Function(_NextSubPage value)? nextSubPage,
    TResult? Function(_PreviousSubPage value)? previousSubPage,
    TResult? Function(_StartLoading value)? startLoading,
    TResult? Function(_ToggleAutoRefreshPause value)? toggleAutoRefreshPause,
  }) {
    return toggleAutoRefreshPause?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadNationalPage value)? loadNationalPage,
    TResult Function(_LoadRegionalPage value)? loadRegionalPage,
    TResult Function(_NextPage value)? nextPage,
    TResult Function(_PreviousPage value)? previousPage,
    TResult Function(_NextSubPage value)? nextSubPage,
    TResult Function(_PreviousSubPage value)? previousSubPage,
    TResult Function(_StartLoading value)? startLoading,
    TResult Function(_ToggleAutoRefreshPause value)? toggleAutoRefreshPause,
    required TResult orElse(),
  }) {
    if (toggleAutoRefreshPause != null) {
      return toggleAutoRefreshPause(this);
    }
    return orElse();
  }
}

abstract class _ToggleAutoRefreshPause implements TelevideoEvent {
  const factory _ToggleAutoRefreshPause() = _$ToggleAutoRefreshPauseImpl;
}
