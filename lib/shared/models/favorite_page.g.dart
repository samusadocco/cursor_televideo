// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FavoritePageImpl _$$FavoritePageImplFromJson(Map<String, dynamic> json) =>
    _$FavoritePageImpl(
      pageNumber: (json['pageNumber'] as num).toInt(),
      title: json['title'] as String,
      regionCode: json['regionCode'] as String?,
    );

Map<String, dynamic> _$$FavoritePageImplToJson(_$FavoritePageImpl instance) =>
    <String, dynamic>{
      'pageNumber': instance.pageNumber,
      'title': instance.title,
      'regionCode': instance.regionCode,
    };
