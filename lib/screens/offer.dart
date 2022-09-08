import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shop/utils/custom_theme.dart';
import 'package:scratcher/scratcher.dart';
import '../components/grid_card.dart';

class OfferScreen extends StatefulWidget {
  const OfferScreen({Key? key}) : super(key: key);

  @override
  State<OfferScreen> createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  List<String> scratchBackground = [
    "assets/images/scratch/s-1.jpg",
    // "assets/images/scratch/s-2.jpg",
    "assets/images/scratch/s-8.jpg",
    // "assets/images/scratch/s-4.jpg",
    // "assets/images/scratch/s-5.jpg",
    // "assets/images/scratch/s-6.jpg",
    "assets/images/scratch/s-7.jpg",
  ];

  final scratchKey = GlobalKey<ScratcherState>();

  RewardedAd? rewardedAd;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    RewardedAd.load(
        adUnitId: "ca-app-pub-3940256099942544/5224354917",
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
          print('Reawarded Ad Loaded');
          rewardedAd = ad;
          setState(() {
            isLoaded = true;
          });
        }, onAdFailedToLoad: (error) {
          print('Rewarded Ad Failed to Load');
        }));
  }

  double _opacity = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                color: CustomTheme.yellow.withOpacity(0.8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Win money : ',
                            style:
                                CustomTheme.getTheme().textTheme.headlineSmall,
                          ),
                          Container(
                              padding: EdgeInsets.only(left: 10),
                              alignment: Alignment.centerLeft,
                              height: 40,
                              width: 200,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '\$ 0.00',
                                style: CustomTheme.getTheme()
                                    .textTheme
                                    .headlineSmall,
                              )),
                          GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Icon(
                                          Icons.info,
                                          color: CustomTheme.yellow,
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            Text(
                                                'Step-1 : Click on Watch button and watch video. \n \n'
                                                'Step-2 : After watch video you recive a one scratch card. \n \n '
                                                'Step-3 : Recive card on click and scratched by card and you win a cashback,discount and many offers...')
                                          ],
                                        ),
                                      );
                                    });
                              },
                              child: Icon(
                                Icons.info,
                                color: Colors.black.withOpacity(0.7),
                                size: 23,
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
              )),
          Expanded(
            flex: 12,
            child: Container(
              child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: scratchBackground.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    // mainAxisSpacing: 5,
                    // mainAxisExtent: 250,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          GridTile(
                            child: GestureDetector(
                              child: Container(
                                width: 200,
                                height: 180,
                                // height: 180,
                                // width: 180,
                                decoration: BoxDecoration(
                                    color: Colors.blueAccent.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        image: AssetImage(
                                          scratchBackground[index],
                                        ),
                                        fit: BoxFit.cover,
                                        opacity: 0.5)),
                                // child: Scratcher(
                                //   key: scratchKey ,
                                //   color: Colors.red,
                                //   brushSize: 35,
                                //   threshold: 40,
                                //   onChange: (value) => print("$value%  Scratched"),
                                //   onThreshold: () => Container(child: Text('done'),),
                                //   child: Container(
                                //     height: 300,
                                //     width: 300,
                                //     color: Colors.green,
                                //   ),
                                // ),

                                // child: Column(
                                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                //   children: [
                                //     Text('Scratch & Win',style: TextStyle(
                                //       color: Colors.black.withOpacity(0.7),
                                //       fontWeight: FontWeight.w600,
                                //     ),),
                                //     Image(image: AssetImage(scratchBackground[index],),height: 150,width: double.infinity,)
                                //     // Image.asset('assets/images/scratch/success.png',color: Colors.black.withOpacity(0.5),scale: 6,),
                                //   ],
                                // ),
                              ),
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:BorderRadius.circular(10)),

                                        title: const Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                              'Scratch and Win'),
                                        ),
                                        content: StatefulBuilder(
                                          builder:
                                              (context, StateSetter setState) {
                                            return Scratcher(
                                              key: scratchKey,
                                              accuracy: ScratchAccuracy.medium,
                                              threshold: 50,
                                              onThreshold: () {
                                                setState(() {
                                                  _opacity = 1;
                                                });
                                              },
                                              image: Image.asset(
                                                  scratchBackground[index],),
                                              onChange: (value) =>
                                                  print('Progress $value%'),
                                              brushSize: 20,
                                              child: AnimatedOpacity(
                                                duration: const Duration(
                                                    milliseconds: 1000),
                                                opacity: _opacity,
                                                child: Container(
                                                    width: 180,
                                                    height: 180,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                        border: Border.all(color:CustomTheme.yellow),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        const Image(
                                                          image: AssetImage(
                                                            'assets/images/scratch/sorry.png',
                                                          ),
                                                          height: 110,
                                                        ),
                                                        Text(
                                                          'Better Luck',
                                                          style: CustomTheme
                                                                  .getTheme()
                                                              .textTheme
                                                              .headlineMedium,
                                                        ),
                                                        Text(
                                                          'Next Time',
                                                          style: CustomTheme
                                                                  .getTheme()
                                                              .textTheme
                                                              .headlineMedium,
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    });
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              // color: Colors.red,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: CustomTheme.yellow,
          child: Icon(
            Icons.slow_motion_video_rounded,
            color: Colors.black.withOpacity(0.7),
            size: 40,
          ),
          onPressed: () {
            setState(
              () {
                rewardedAd!.show(onUserEarnedReward: (ad, reward) {
                  print('User Watch Compllete Video \n User Earned Reward');
                });
              },
            );
          }),
    );
  }
}
