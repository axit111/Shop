// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      json['title']as String,
      json['id']as String,
      json['image']as String,
      json['price'] as String,
      json['category']as String ,
      json['description'] as String,
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'title': instance.title,
      'price': instance.price,
      'id': instance.id,
      'description': instance.description,
      'image': instance.image,
      'category': instance.category,
    };
