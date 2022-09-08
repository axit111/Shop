import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/custom_button.dart';
import 'package:shop/components/list_card.dart';
import 'package:shop/components/loader.dart';
import 'package:shop/utils/application_state.dart';
import 'package:shop/utils/common.dart';
import 'package:shop/utils/custom_theme.dart';
import 'package:shop/utils/firestore.dart';

import '../models/cart_model.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // final carts = ["1","2"];

  BannerAd? bannerAd;
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
  }


  Future<List<Cart>>? carts;
  bool _checkoutButtonLoading = false;

  @override
  void initState(){
    super.initState();
    carts = FirestoreUtil.getCart(Provider.of<ApplicationState>(context,listen: false).user);
  }

  void checkout()async{
    setState((){
  _checkoutButtonLoading = true;
    });

    // String error = CommonUtil.checkoutFlow(Provider.of<ApplicationState>(context,listen: false).user!).toString() ;

    // if(error.isEmpty){}
    // else{}
    // await Future.delayed(const Duration(seconds: 2));
    setState((){
      _checkoutButtonLoading = false;
      carts = FirestoreUtil.getCart(Provider.of<ApplicationState>(context,listen: false).user);
    });
    //checkout flow
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Cart>>(
        future: carts,
        builder: ( context,AsyncSnapshot<List<Cart>> snapshot) {
      if(snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty ){
        return Column(
          children: [
            Expanded(
              flex: 9,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics:NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(vertical: 30),
                  itemCount:snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListCard(cart: snapshot.data![index]);
               // return ListCard(snapshot.data![index]);
              }),
            ),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  priceFooter(snapshot.data!),
                  Container(padding: EdgeInsets.symmetric(vertical: 20,horizontal: 30),
                  child: CustomButton(
                    text: "CHECKOUT",
                    onPress: checkout,
                    loading: false,
                  ),),
                ],
              ),
            )
          ],
        );
      }
      else if(snapshot.data != null && snapshot.data!.isEmpty){
        return const Center(
          child: Icon(Icons.add_shopping_cart_sharp,color: CustomTheme.yellow,size: 150,),
        );
      }
      return const Center(child: Loader());
    });


  }
  priceFooter(List<Cart> carts){
    return Padding(padding:EdgeInsets. symmetric(horizontal: 30),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
        height: 2,
        color: CustomTheme.grey,
        thickness: 2,),
        Padding(padding: EdgeInsets.only(top:20 ),
        child: Row(
          children: [
            Text("Total : ",style: Theme.of(context).textTheme.headlineSmall,),
            const Spacer(),
            Text('\$ ' + FirestoreUtil.getCartTotal(carts).toString(),style: Theme.of(context).textTheme.headlineSmall,)
          ],
        ),)
      ],
    ),);
  }
}