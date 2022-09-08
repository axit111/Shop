import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shop/screens/checkout.dart';
import 'package:shop/screens/home.dart';
import 'package:shop/screens/login.dart';
import 'package:shop/screens/offer.dart';
import 'package:shop/screens/profile.dart';
import 'package:shop/utils/application_state.dart';
import 'package:shop/utils/custom_theme.dart';

void main() async{

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  //Firebase setup
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // FlutterNativeSplash.remove();

  //
  // //Stripe setup
  // final String response = await rootBundle.loadString("assets/config/stripe.json");
  // final data = await json.decode(response);
  // Stripe.publishableKey = data["publishableKey"];

  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: (context, _) => Consumer<ApplicationState>(
      builder: (context, applicationState, _){
        Widget child;
        switch(applicationState.loginState) {
          case ApplicatinLoginState.loggetOut :
            FlutterNativeSplash.remove();

            child = const LoginScreen();
          break;
          case ApplicatinLoginState.looggedIn :
            FlutterNativeSplash.remove();

            child = const MyApp();
          break;
          default:
            FlutterNativeSplash.remove();

            child = const LoginScreen();
        }
        return MaterialApp(debugShowCheckedModeBanner: false,theme: CustomTheme.getTheme(),home: child,);
      },
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
          length: 4,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text('SHOPPERS'),
            ),
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                boxShadow: CustomTheme.cardShadow,
              ),
              child: const TabBar(
                padding: EdgeInsets.symmetric(vertical: 10),
                indicatorColor: Colors.transparent,
                tabs: [
                  Tab(
                    icon: Icon(Icons.home),
                  ),
                  Tab(
                    icon: Icon(Icons.shopping_cart),
                  ),
                  Tab(
                    icon: Icon(Icons.local_offer_rounded),
                  ),
                  Tab(
                    icon: Icon(Icons.person),
                  ),
                ],
              ),
            ),
            body: const TabBarView(
              children: [
                HomeScreen(),
                CheckoutScreen(),
                OfferScreen(),
                ProfileScreen(),
              ],
            ),
          ),
        );
  }

}
