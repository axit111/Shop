import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/custom_button.dart';
import 'package:shop/utils/application_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _loadingButton = false;

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


  void  signOutButtonPressed(){
    setState((){
      _loadingButton = true;
    });
    Provider.of<ApplicationState>(context,listen: false).signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text('Hi There',style: Theme.of(context).textTheme.headlineLarge,),
          ),
          Container(
            height: 50,

            child: AdWidget(
              ad: bannerAd!,
            ),
          ),
          CustomButton(text: "SIGN OUT", onPress: signOutButtonPressed,loading: _loadingButton,)
        ],
      ),
    );
  }
}
