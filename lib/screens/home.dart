import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shop/components/loader.dart';
import 'package:shop/screens/login.dart';
import 'package:shop/screens/product.dart';
import 'package:shop/utils/firestore.dart';

import '../components/grid_card.dart';
import '../models/product_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final data = ["1", "2"];

  BannerAd? bannerAd;
  InterstitialAd? interstitialAd;
  bool isLoaded = false;

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //
  //   //Banner Ad
  //
  // }

  // InterstitialAd? interstitialAd;
  // bool isLoaded = false;
  //
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   InterstitialAd.load(adUnitId: "ca-app-pub-3940256099942544/8691691433",
  //       request: AdRequest(),
  //       adLoadCallback: InterstitialAdLoadCallback(
  //           onAdLoaded: (ad) {
  //             setState(() {
  //               isLoaded = true;
  //               this.interstitialAd = ad;
  //             });
  //             print('Ad loaded');
  //           }, onAdFailedToLoad: (error){
  //         print('Interstitial failed to load')
  //       }));
  // }

  Future<List<Product>>? products;

  @override
  void initState() {
    super.initState();
    products = FirestoreUtil.getProduct([]);
    bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: "ca-app-pub-3940256099942544/6300978111",
        listener: BannerAdListener(onAdLoaded: (ad) {
          setState(() {
            isLoaded = true;
          });
          print('Banner ad loaded');
        }, onAdFailedToLoad: (ad, error) {
          ad.dispose();
        }),
        request: AdRequest());
    bannerAd!.load();

    //Interstitial Ad
    InterstitialAd.load(
        adUnitId: "ca-app-pub-3940256099942544/8691691433",
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
          setState(() {
            isLoaded = true;
            this.interstitialAd = ad;
          });
          print('Ad loaded');
        }, onAdFailedToLoad: (error) {
          print('Interstitial failed to load');
        }));
  }



  @override
  Widget build(BuildContext context) {
    onCardPress(Product product) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductScreen(
                    product: product,
                  )));
    }

    return FutureBuilder<List<Product>>(
        future: products,
        builder: (context, AsyncSnapshot<List<Product>> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return RefreshIndicator(
              color: Colors.black,
              onRefresh: () {
                return Future.delayed(const Duration(seconds: 1), () {
                  setState(() {
                    products = FirestoreUtil.getProduct([]);
                  });
                });
              },
              child: GridView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    // mainAxisSpacing: 5,
                    // crossAxisSpacing: 10,
                    mainAxisExtent: 250,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return GridCard(
                        index: index,
                        onPress: () {
                          if (isLoaded) {
                            interstitialAd!.show();
                          }
                          onCardPress(snapshot.data![index]);
                        },
                        product: snapshot.data![index]);
                  }),
            );
          } else {
            return Center(child: Loader());
          }
        });
    //
    // Container(
    //     child: GridView.builder(
    //         itemCount: data.length,
    //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //           crossAxisCount: 2,
    //           mainAxisSpacing: 10,
    //           crossAxisSpacing: 10,
    //           mainAxisExtent: 280,
    //         ),
    //         itemBuilder: (BuildContext context, int index) {
    //           return GridCard(index: index, onPress: onCardPress);
    //         }));
  }
}
