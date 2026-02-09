// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teletext_channels.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TeletextChannelImpl _$$TeletextChannelImplFromJson(
        Map<String, dynamic> json) =>
    _$TeletextChannelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      shortName: json['shortName'] as String?,
      countryCode: json['countryCode'] as String,
      countryName: json['countryName'] as String?,
      flagEmoji: json['flagEmoji'] as String,
      broadcasterName: json['broadcasterName'] as String,
      type: $enumDecode(_$TeletextChannelTypeEnumMap, json['type']),
      baseUrl: json['baseUrl'] as String?,
      htmlBaseUrl: json['htmlBaseUrl'] as String?,
      supportsRegions: json['supportsRegions'] as bool?,
      regions:
          (json['regions'] as List<dynamic>?)?.map((e) => e as String).toList(),
      isActive: json['isActive'] as bool? ?? true,
      shortcuts: (json['shortcuts'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(int.parse(k), e as String),
      ),
      pageDescriptions:
          (json['pageDescriptions'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(int.parse(k), e as String),
      ),
    );

Map<String, dynamic> _$$TeletextChannelImplToJson(
        _$TeletextChannelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'shortName': instance.shortName,
      'countryCode': instance.countryCode,
      'countryName': instance.countryName,
      'flagEmoji': instance.flagEmoji,
      'broadcasterName': instance.broadcasterName,
      'type': _$TeletextChannelTypeEnumMap[instance.type]!,
      'baseUrl': instance.baseUrl,
      'htmlBaseUrl': instance.htmlBaseUrl,
      'supportsRegions': instance.supportsRegions,
      'regions': instance.regions,
      'isActive': instance.isActive,
      'shortcuts': instance.shortcuts?.map((k, e) => MapEntry(k.toString(), e)),
      'pageDescriptions':
          instance.pageDescriptions?.map((k, e) => MapEntry(k.toString(), e)),
    };

const _$TeletextChannelTypeEnumMap = {
  TeletextChannelType.national: 'national',
  TeletextChannelType.regional: 'regional',
};
