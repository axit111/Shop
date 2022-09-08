import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/custom_button.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/utils/custom_theme.dart';
import 'package:shop/utils/firestore.dart';

import '../utils/application_state.dart';

class ProductScreen extends StatefulWidget {
  final Product product;
  const ProductScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool addButtonLoad = false;

  BannerAd? bannerAd;
  InterstitialAd? interstitialAd;

  bool isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bannerAd = BannerAd(size: AdSize.banner,
        adUnitId: "ca-app-pub-3940256099942544/6300978111",
        listener: BannerAdListener(
            onAdLoaded: (ad) {
              setState((){
                isLoaded = true;
              });
              print('Banner ad loaded');
            },
            onAdFailedToLoad: (ad,error){
              ad.dispose();
            }
        ),
        request: AdRequest());bannerAd!.load();

    InterstitialAd.load(adUnitId: "ca-app-pub-3940256099942544/1033173712",
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad) {
              setState(() {
                isLoaded = true;
                this.interstitialAd = ad;
              });
              print('Ad loaded');
            }, onAdFailedToLoad: (error){
          print('Interstitial failed to load');
        }));
  }


  void onAddToCart() async {
    setState(() {
      addButtonLoad = true;
    });
    await FirestoreUtil.addToCart(Provider.of<ApplicationState>(context,listen: false).user,widget.product.id);
    setState(() {
      addButtonLoad = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:  Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 60,
            child: AdWidget(
              ad: bannerAd!,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: 400,
                        width: double.infinity,
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl:
                            widget.product.image,
                        ),
                      ),
                      Positioned(
                          top: 35,
                          right: 35,
                          child: Container(
                            decoration: const ShapeDecoration(
                              color: CustomTheme.yellow,
                              shape: CircleBorder(),
                              shadows: [
                                BoxShadow(
                                    color: CustomTheme.grey,
                                    blurRadius: 3,
                                    offset: Offset(1, 3))
                              ],
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.share,
                              ),
                              color: Colors.black,
                              onPressed: () {},
                            ),
                          )),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 38),
                    child: DefaultTextStyle(
                      style: Theme.of(context).textTheme.headlineLarge!,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Padding(
                            padding: const EdgeInsets.only(top: 22),
                            child: Text(widget.product.title),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Row(
                              children: [
                                Text("MRP: "),Text('\$' + widget.product.price.toString()),
                              ],
                            ),
                          ),
                          CustomButton(text: "Add to Cart", onPress: onAddToCart,loading: addButtonLoad,),
                          Padding(padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text('About the items',style: Theme.of(context).textTheme.headlineMedium,),),
                        Padding(padding: EdgeInsets.only(bottom: 20),
                        child: Text(widget.product.description,style: Theme.of(context).textTheme.bodySmall,),
                        ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Positioned(top:35,left:30,child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5),),
                  boxShadow: [BoxShadow(blurRadius: 3,offset:Offset(1,3),color: CustomTheme.grey)]
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                color: Colors.black,
                onPressed: (){
                  if(isLoaded){
                    interstitialAd!.show();
                  }
                  Navigator.of(context).pop(true);
                },
              ),
            )),

          ],
        ),
      ),
    );
  }
}
