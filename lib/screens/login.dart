import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/custom_button.dart';
import 'package:shop/components/custom_text_input.dart';
import 'package:shop/main.dart';
import 'package:shop/utils/application_state.dart';
import 'package:shop/utils/custom_theme.dart';

import '../utils/login_data.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loadingButton = false;

  Map<String, String> data = {};

  // _loginScreenState() {
  //   data = LoginData.signIn;
  // }


  @override
  void initState() {
    super.initState();
    data = LoginData.signIn;
    initialization();
    }

    void initialization() async {
      // // This is where you can initialize the resources needed by your app while
      // // the splash screen is displayed.  Remove the following example because
      // // delaying the user experience is a bad design practice!
      // // ignore_for_file: avoid_print
      // print('ready in 3...');
      // await Future.delayed(const Duration(seconds: 1));
      // print('ready in 2...');
      // await Future.delayed(const Duration(seconds: 1));
      // print('ready in 1...');
      // await Future.delayed(const Duration(seconds: 1));
      // print('go!');
      FlutterNativeSplash.remove();
    }


  void switchLogin() {
    setState(() {
      if (mapEquals(data, LoginData.signUp)) {
        data = LoginData.signIn;
      } else {
        data = LoginData.signUp;
      }
    });
  }


  loginError(FirebaseAuthException e){
    if(e.message != ''){

      setState((){
        _loadingButton = false;
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Icon(Icons.error,color: Colors.red,),
            content: const Text("Incorrect input / Data not found"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: CustomTheme.yellow,

                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(14),
                  child: const Text("okay",style: TextStyle(
                    color:Colors.black,
                  ),),
                ),
              ),
            ],

          ),
        );

      });

    }
  }

  void loginButtonPressed(){
    setState((){
      _loadingButton = true;
    });
    ApplicationState applicationState = Provider.of<ApplicationState>(context,listen: false);
    if(mapEquals(data,LoginData.signUp)){
      applicationState.signUp(_emailController.text, _passwordController.text,loginError);
      //     .whenComplete(() {
      //   Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp(),));
      // });
    }else{
      applicationState.signIn(_emailController.text, _passwordController.text,loginError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 40.0, bottom: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text(
                          data['heading'].toString(),
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ),
                      Text(
                        data['subHeading'].toString(),
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    ],
                  ),
                ),
                model(data, _emailController, _passwordController),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                      child: GestureDetector(
                        onTap: switchLogin,
                        child: Text(
                              data['footer'].toString(),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                      ),
                      // child: TextButton(
                      //   onPressed: switchLogin,
                      //   child: Text(
                      //     data['footer'].toString(),
                      //     style: Theme.of(context).textTheme.bodyLarge,
                      //   ),
                      // ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  model(Map<String, String> data, TextEditingController emailController,
      TextEditingController passwordController) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.only(right: 20,left: 20,top: 30,bottom: 56),
      decoration: CustomTheme.getCardDecoration(),
      child: Column(
        children: [
          CustomTextInput(label: "Youe email address", placeholder: 'email@address.com', icon: Icons.person_outline, textEditingController: _emailController),
          CustomTextInput(label: 'Password', placeholder: 'Password', icon: Icons.lock_outline,password: true, textEditingController: _passwordController),

        CustomButton(text: data['label'] as String, onPress: loginButtonPressed,loading: _loadingButton,)
        ],
      ),
    );
  }
}
