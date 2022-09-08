import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:googleapis/docs/v1.dart';
import 'package:http/http.dart' as http;

class CommonUtil{
static const String apiUrl = "http://192.168.1.100:4242";
static const String stripeUserCreate = "/add/user";
static const String checkout = "/checkout";
  static backendCall(User user,String endPoint)async{

    String token = await user.getIdToken();
    return http.post(Uri.parse(apiUrl+endPoint),headers: {
      "Accept":"application/json",
      "Content-Type":"application/json",
      "Authorization":"Bearer" + token,
    });

  }
//   static Future<String> checkoutFlow(User user)async{
//     String error = "";
//     try{
//       http.Response response = await backendCall(user, checkout);
//       var json = jsonDecode(response.body);
//       SetupPaymentSheetParameters parameters = SetupPaymentSheetParameters(
//         customerId: json["customer"],
//         customerEphemeralKeySecret: json["paymentIntent"],
//         paymentIntentClientSecret: json["Shopp"],
//
//       );
//       Stripe.instance.initPaymentSheet(paymentSheetParameters: parameters);
//       await Future.delayed(const Duration(seconds: 1));
//       await Stripe.instance.presentPaymentSheet();
//     }on StripeException catch (e) {
//       log("String error" + e.error.message.toString());
//       error = e.error.message.toString();
//     }catch (e,stackTrace){
//       log("Error with backend api call",stackTrace: stackTrace,error: e);
//       error = "Network error,try after some time";
//     }
//     return error;
//   }
}