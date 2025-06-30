// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'televideo_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TelevideoPageImpl _$$TelevideoPageImplFromJson(Map<String, dynamic> json) =>
    _$TelevideoPageImpl(
      pageNumber: (json['pageNumber'] as num).toInt(),
      imageUrl: json['imageUrl'] as String,
      region: json['region'] as String?,
    );

Map<String, dynamic> _$$TelevideoPageImplToJson(_$TelevideoPageImpl instance) =>
    <String, dynamic>{
      'pageNumber': instance.pageNumber,
      'imageUrl': instance.imageUrl,
      'region': instance.region,
    };
