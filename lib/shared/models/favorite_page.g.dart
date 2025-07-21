// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FavoritePageImpl _$$FavoritePageImplFromJson(Map<String, dynamic> json) =>
    _$FavoritePageImpl(
      pageNumber: (json['pageNumber'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String?,
      regionCode: json['regionCode'] as String?,
      order: (json['order'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$FavoritePageImplToJson(_$FavoritePageImpl instance) =>
    <String, dynamic>{
      'pageNumber': instance.pageNumber,
      'title': instance.title,
      'description': instance.description,
      'regionCode': instance.regionCode,
      'order': instance.order,
    };
