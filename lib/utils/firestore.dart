import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop/models/product_model.dart';

import '../models/cart_model.dart';

class FirestoreUtil{
  static const String productCollaction =  'product';
  static const String customerCollection =  'customers';
  static const String cartCollection =  'cart';

  static Future<List<Product>> getProduct(List<String>? ids)async {
    try {
      final productRef = FirebaseFirestore.instance.collection(
          productCollaction).withConverter<Product>(
          fromFirestore: (snapshot, _) => Product.fromJson(snapshot.data()!),
          toFirestore: (product, _) => product.toJason());

      QuerySnapshot<Product>? productDocs ;

      if(ids != null && ids.isNotEmpty){
        QuerySnapshot<Product> productDoc = await productRef.where('id',whereIn: ids).get();
      }else{
        productDocs = await productRef.get();
      }
      return productDocs!.docs.map((e) => e.data()).toList();


    } on FirebaseException catch (e, stacktrace) {
      log("Error getting the products", stackTrace: stacktrace, error: e);
    }
  return [];
  }
  static addToCart(User? user,String productId)async{
    if(user == null)return;
    try{
      DocumentReference<Map<String,dynamic>> product = FirebaseFirestore.instance.collection(customerCollection)
          .doc(user.uid)
          .collection(cartCollection)
          .doc(productId);

      if((await product.get()).exists){
        product.update({"count": FieldValue.increment(1)});
      }
      else{
        product.set({"id": productId,"count": 1});

      }
    }on FirebaseException catch(e, stackTrace){
      log("Enter adding to cart",stackTrace: stackTrace,error: e);
    }
  }
  static Future<List<Cart>> getCart(User? user)async{
    List<Cart> carts = [];
    try{
      final cartRef = await FirebaseFirestore.instance
          .collection(customerCollection)
          .doc(user?.uid)
          .collection(cartCollection)
          .get();
      List<String> productIds = [];
      for(var element in cartRef.docs){
        productIds.add(element['id']);
      }
      List<Product> products = await getProduct(productIds);

      for(var element in cartRef.docs){
        Product product = products.firstWhere((proud) => proud.id == element.id);
        var json = product.toJason();
        // json['title'] = element['title'];
        json['count'] = element['count'];
        carts.add(Cart.fromJson(json));
      }
      
    }on FirebaseException catch (e,stackTrace){
      log("Error getting cart",stackTrace: stackTrace,error: e);
    }
    return carts;
  }
  static double getCartTotal(List<Cart> carts){
    double total = 0;
    for(Cart cart in carts){
      total += int.parse(cart.price) * cart.count;
    }
    return total;
  }
}

