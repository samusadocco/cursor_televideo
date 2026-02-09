// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'teletext_channels.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TeletextChannel _$TeletextChannelFromJson(Map<String, dynamic> json) {
  return _TeletextChannel.fromJson(json);
}

/// @nodoc
mixin _$TeletextChannel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get shortName =>
      throw _privateConstructorUsedError; // Nome abbreviato per visualizzazione compatta
  String get countryCode => throw _privateConstructorUsedError;
  @Deprecated('Use getLocalizedCountryName() instead')
  String? get countryName =>
      throw _privateConstructorUsedError; // Deprecated: ora usiamo countryCode + localizzazione
  String get flagEmoji => throw _privateConstructorUsedError;
  String get broadcasterName => throw _privateConstructorUsedError;
  TeletextChannelType get type => throw _privateConstructorUsedError;
  String? get baseUrl => throw _privateConstructorUsedError;
  String? get htmlBaseUrl => throw _privateConstructorUsedError;
  bool? get supportsRegions => throw _privateConstructorUsedError;
  List<String>? get regions => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  Map<int, String>? get shortcuts =>
      throw _privateConstructorUsedError; // Scorciatoie alle pagine principali
  Map<int, String>? get pageDescriptions => throw _privateConstructorUsedError;

  /// Serializes this TeletextChannel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeletextChannel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeletextChannelCopyWith<TeletextChannel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeletextChannelCopyWith<$Res> {
  factory $TeletextChannelCopyWith(
          TeletextChannel value, $Res Function(TeletextChannel) then) =
      _$TeletextChannelCopyWithImpl<$Res, TeletextChannel>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? shortName,
      String countryCode,
      @Deprecated('Use getLocalizedCountryName() instead') String? countryName,
      String flagEmoji,
      String broadcasterName,
      TeletextChannelType type,
      String? baseUrl,
      String? htmlBaseUrl,
      bool? supportsRegions,
      List<String>? regions,
      bool isActive,
      Map<int, String>? shortcuts,
      Map<int, String>? pageDescriptions});
}

/// @nodoc
class _$TeletextChannelCopyWithImpl<$Res, $Val extends TeletextChannel>
    implements $TeletextChannelCopyWith<$Res> {
  _$TeletextChannelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeletextChannel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? shortName = freezed,
    Object? countryCode = null,
    Object? countryName = freezed,
    Object? flagEmoji = null,
    Object? broadcasterName = null,
    Object? type = null,
    Object? baseUrl = freezed,
    Object? htmlBaseUrl = freezed,
    Object? supportsRegions = freezed,
    Object? regions = freezed,
    Object? isActive = null,
    Object? shortcuts = freezed,
    Object? pageDescriptions = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      shortName: freezed == shortName
          ? _value.shortName
          : shortName // ignore: cast_nullable_to_non_nullable
              as String?,
      countryCode: null == countryCode
          ? _value.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String,
      countryName: freezed == countryName
          ? _value.countryName
          : countryName // ignore: cast_nullable_to_non_nullable
              as String?,
      flagEmoji: null == flagEmoji
          ? _value.flagEmoji
          : flagEmoji // ignore: cast_nullable_to_non_nullable
              as String,
      broadcasterName: null == broadcasterName
          ? _value.broadcasterName
          : broadcasterName // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TeletextChannelType,
      baseUrl: freezed == baseUrl
          ? _value.baseUrl
          : baseUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      htmlBaseUrl: freezed == htmlBaseUrl
          ? _value.htmlBaseUrl
          : htmlBaseUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      supportsRegions: freezed == supportsRegions
          ? _value.supportsRegions
          : supportsRegions // ignore: cast_nullable_to_non_nullable
              as bool?,
      regions: freezed == regions
          ? _value.regions
          : regions // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      shortcuts: freezed == shortcuts
          ? _value.shortcuts
          : shortcuts // ignore: cast_nullable_to_non_nullable
              as Map<int, String>?,
      pageDescriptions: freezed == pageDescriptions
          ? _value.pageDescriptions
          : pageDescriptions // ignore: cast_nullable_to_non_nullable
              as Map<int, String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TeletextChannelImplCopyWith<$Res>
    implements $TeletextChannelCopyWith<$Res> {
  factory _$$TeletextChannelImplCopyWith(_$TeletextChannelImpl value,
          $Res Function(_$TeletextChannelImpl) then) =
      __$$TeletextChannelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? shortName,
      String countryCode,
      @Deprecated('Use getLocalizedCountryName() instead') String? countryName,
      String flagEmoji,
      String broadcasterName,
      TeletextChannelType type,
      String? baseUrl,
      String? htmlBaseUrl,
      bool? supportsRegions,
      List<String>? regions,
      bool isActive,
      Map<int, String>? shortcuts,
      Map<int, String>? pageDescriptions});
}

/// @nodoc
class __$$TeletextChannelImplCopyWithImpl<$Res>
    extends _$TeletextChannelCopyWithImpl<$Res, _$TeletextChannelImpl>
    implements _$$TeletextChannelImplCopyWith<$Res> {
  __$$TeletextChannelImplCopyWithImpl(
      _$TeletextChannelImpl _value, $Res Function(_$TeletextChannelImpl) _then)
      : super(_value, _then);

  /// Create a copy of TeletextChannel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? shortName = freezed,
    Object? countryCode = null,
    Object? countryName = freezed,
    Object? flagEmoji = null,
    Object? broadcasterName = null,
    Object? type = null,
    Object? baseUrl = freezed,
    Object? htmlBaseUrl = freezed,
    Object? supportsRegions = freezed,
    Object? regions = freezed,
    Object? isActive = null,
    Object? shortcuts = freezed,
    Object? pageDescriptions = freezed,
  }) {
    return _then(_$TeletextChannelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      shortName: freezed == shortName
          ? _value.shortName
          : shortName // ignore: cast_nullable_to_non_nullable
              as String?,
      countryCode: null == countryCode
          ? _value.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String,
      countryName: freezed == countryName
          ? _value.countryName
          : countryName // ignore: cast_nullable_to_non_nullable
              as String?,
      flagEmoji: null == flagEmoji
          ? _value.flagEmoji
          : flagEmoji // ignore: cast_nullable_to_non_nullable
              as String,
      broadcasterName: null == broadcasterName
          ? _value.broadcasterName
          : broadcasterName // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TeletextChannelType,
      baseUrl: freezed == baseUrl
          ? _value.baseUrl
          : baseUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      htmlBaseUrl: freezed == htmlBaseUrl
          ? _value.htmlBaseUrl
          : htmlBaseUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      supportsRegions: freezed == supportsRegions
          ? _value.supportsRegions
          : supportsRegions // ignore: cast_nullable_to_non_nullable
              as bool?,
      regions: freezed == regions
          ? _value._regions
          : regions // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      shortcuts: freezed == shortcuts
          ? _value._shortcuts
          : shortcuts // ignore: cast_nullable_to_non_nullable
              as Map<int, String>?,
      pageDescriptions: freezed == pageDescriptions
          ? _value._pageDescriptions
          : pageDescriptions // ignore: cast_nullable_to_non_nullable
              as Map<int, String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TeletextChannelImpl extends _TeletextChannel {
  const _$TeletextChannelImpl(
      {required this.id,
      required this.name,
      this.shortName,
      required this.countryCode,
      @Deprecated('Use getLocalizedCountryName() instead') this.countryName,
      required this.flagEmoji,
      required this.broadcasterName,
      required this.type,
      this.baseUrl,
      this.htmlBaseUrl,
      this.supportsRegions,
      final List<String>? regions,
      this.isActive = true,
      final Map<int, String>? shortcuts,
      final Map<int, String>? pageDescriptions})
      : _regions = regions,
        _shortcuts = shortcuts,
        _pageDescriptions = pageDescriptions,
        super._();

  factory _$TeletextChannelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeletextChannelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? shortName;
// Nome abbreviato per visualizzazione compatta
  @override
  final String countryCode;
  @override
  @Deprecated('Use getLocalizedCountryName() instead')
  final String? countryName;
// Deprecated: ora usiamo countryCode + localizzazione
  @override
  final String flagEmoji;
  @override
  final String broadcasterName;
  @override
  final TeletextChannelType type;
  @override
  final String? baseUrl;
  @override
  final String? htmlBaseUrl;
  @override
  final bool? supportsRegions;
  final List<String>? _regions;
  @override
  List<String>? get regions {
    final value = _regions;
    if (value == null) return null;
    if (_regions is EqualUnmodifiableListView) return _regions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final bool isActive;
  final Map<int, String>? _shortcuts;
  @override
  Map<int, String>? get shortcuts {
    final value = _shortcuts;
    if (value == null) return null;
    if (_shortcuts is EqualUnmodifiableMapView) return _shortcuts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

// Scorciatoie alle pagine principali
  final Map<int, String>? _pageDescriptions;
// Scorciatoie alle pagine principali
  @override
  Map<int, String>? get pageDescriptions {
    final value = _pageDescriptions;
    if (value == null) return null;
    if (_pageDescriptions is EqualUnmodifiableMapView) return _pageDescriptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'TeletextChannel(id: $id, name: $name, shortName: $shortName, countryCode: $countryCode, countryName: $countryName, flagEmoji: $flagEmoji, broadcasterName: $broadcasterName, type: $type, baseUrl: $baseUrl, htmlBaseUrl: $htmlBaseUrl, supportsRegions: $supportsRegions, regions: $regions, isActive: $isActive, shortcuts: $shortcuts, pageDescriptions: $pageDescriptions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeletextChannelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.shortName, shortName) ||
                other.shortName == shortName) &&
            (identical(other.countryCode, countryCode) ||
                other.countryCode == countryCode) &&
            (identical(other.countryName, countryName) ||
                other.countryName == countryName) &&
            (identical(other.flagEmoji, flagEmoji) ||
                other.flagEmoji == flagEmoji) &&
            (identical(other.broadcasterName, broadcasterName) ||
                other.broadcasterName == broadcasterName) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl) &&
            (identical(other.htmlBaseUrl, htmlBaseUrl) ||
                other.htmlBaseUrl == htmlBaseUrl) &&
            (identical(other.supportsRegions, supportsRegions) ||
                other.supportsRegions == supportsRegions) &&
            const DeepCollectionEquality().equals(other._regions, _regions) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            const DeepCollectionEquality()
                .equals(other._shortcuts, _shortcuts) &&
            const DeepCollectionEquality()
                .equals(other._pageDescriptions, _pageDescriptions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      shortName,
      countryCode,
      countryName,
      flagEmoji,
      broadcasterName,
      type,
      baseUrl,
      htmlBaseUrl,
      supportsRegions,
      const DeepCollectionEquality().hash(_regions),
      isActive,
      const DeepCollectionEquality().hash(_shortcuts),
      const DeepCollectionEquality().hash(_pageDescriptions));

  /// Create a copy of TeletextChannel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeletextChannelImplCopyWith<_$TeletextChannelImpl> get copyWith =>
      __$$TeletextChannelImplCopyWithImpl<_$TeletextChannelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeletextChannelImplToJson(
      this,
    );
  }
}

abstract class _TeletextChannel extends TeletextChannel {
  const factory _TeletextChannel(
      {required final String id,
      required final String name,
      final String? shortName,
      required final String countryCode,
      @Deprecated('Use getLocalizedCountryName() instead')
      final String? countryName,
      required final String flagEmoji,
      required final String broadcasterName,
      required final TeletextChannelType type,
      final String? baseUrl,
      final String? htmlBaseUrl,
      final bool? supportsRegions,
      final List<String>? regions,
      final bool isActive,
      final Map<int, String>? shortcuts,
      final Map<int, String>? pageDescriptions}) = _$TeletextChannelImpl;
  const _TeletextChannel._() : super._();

  factory _TeletextChannel.fromJson(Map<String, dynamic> json) =
      _$TeletextChannelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get shortName; // Nome abbreviato per visualizzazione compatta
  @override
  String get countryCode;
  @override
  @Deprecated('Use getLocalizedCountryName() instead')
  String?
      get countryName; // Deprecated: ora usiamo countryCode + localizzazione
  @override
  String get flagEmoji;
  @override
  String get broadcasterName;
  @override
  TeletextChannelType get type;
  @override
  String? get baseUrl;
  @override
  String? get htmlBaseUrl;
  @override
  bool? get supportsRegions;
  @override
  List<String>? get regions;
  @override
  bool get isActive;
  @override
  Map<int, String>? get shortcuts; // Scorciatoie alle pagine principali
  @override
  Map<int, String>? get pageDescriptions;

  /// Create a copy of TeletextChannel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeletextChannelImplCopyWith<_$TeletextChannelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
