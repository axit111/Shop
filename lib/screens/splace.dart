// import 'dart:async';
// import 'package:flutter/material.dart';
//
// import '../main.dart';
//
//
// class SplaceScreen extends StatefulWidget {
//   const SplaceScreen({Key? key}) : super(key: key);
//
//   @override
//   State<SplaceScreen> createState() => _SplaceScreenState();
// }
//
// class _SplaceScreenState extends State<SplaceScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Timer(const Duration(seconds: 5), () {
//       Navigator.of(context).pushNamedAndRemoveUntil(MyApp().toString(), (route) => false);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         alignment: Alignment.center,
//         color: const Color(0XFFffffff),
//         child: Image.asset(
//               "assets/images/logo/logo.png",
//               height: 100,
//             ),
//
//       ),
//     );
//   }
// }
