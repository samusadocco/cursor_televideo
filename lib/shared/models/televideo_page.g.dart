// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'televideo_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClickableAreaImpl _$$ClickableAreaImplFromJson(Map<String, dynamic> json) =>
    _$ClickableAreaImpl(
      targetPage: (json['targetPage'] as num).toInt(),
      x: (json['x'] as num).toInt(),
      y: (json['y'] as num).toInt(),
      width: (json['width'] as num).toInt(),
      height: (json['height'] as num).toInt(),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$ClickableAreaImplToJson(_$ClickableAreaImpl instance) =>
    <String, dynamic>{
      'targetPage': instance.targetPage,
      'x': instance.x,
      'y': instance.y,
      'width': instance.width,
      'height': instance.height,
      'description': instance.description,
    };

_$TelevideoPageImpl _$$TelevideoPageImplFromJson(Map<String, dynamic> json) =>
    _$TelevideoPageImpl(
      pageNumber: (json['pageNumber'] as num).toInt(),
      imageUrl: json['imageUrl'] as String,
      region: json['region'] as String?,
      clickableAreas: (json['clickableAreas'] as List<dynamic>?)
              ?.map((e) => ClickableArea.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      maxSubPages: (json['maxSubPages'] as num?)?.toInt() ?? 1,
      subPage: (json['subPage'] as num?)?.toInt() ?? 1,
      totalSubPages: (json['totalSubPages'] as num?)?.toInt() ?? 1,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      isHtmlContent: json['isHtmlContent'] as bool? ?? false,
      htmlContent: json['htmlContent'] as String?,
      providerId: json['providerId'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$TelevideoPageImplToJson(_$TelevideoPageImpl instance) =>
    <String, dynamic>{
      'pageNumber': instance.pageNumber,
      'imageUrl': instance.imageUrl,
      'region': instance.region,
      'clickableAreas': instance.clickableAreas,
      'maxSubPages': instance.maxSubPages,
      'subPage': instance.subPage,
      'totalSubPages': instance.totalSubPages,
      'timestamp': instance.timestamp?.toIso8601String(),
      'isHtmlContent': instance.isHtmlContent,
      'htmlContent': instance.htmlContent,
      'providerId': instance.providerId,
      'metadata': instance.metadata,
    };
