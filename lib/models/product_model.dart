import 'package:json_annotation/json_annotation.dart';
// import 'package:build_runner/build_runner.dart';


part 'product_model.g.dart';
@JsonSerializable()
class Product{
  String title;  
  String price;
  String id;
  String description;
  String image;

  @JsonKey(defaultValue : '')
  String? category;

  Product(this.title,this.id,this.image,this.price,this.category,this.description);

  factory Product.fromJson(Map<String,dynamic> json) => _$ProductFromJson(json);

  Map<String,dynamic> toJason() => _$ProductToJson(this);

}