import 'package:animate_do/animate_do.dart';
import 'package:dawa/View/Login.dart';
import 'package:dawa/inc/Const.dart';
import 'package:flutter/material.dart';

import '../Home.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 4), () {
      if (mainBox!.get('user') != null) {
        Get.off(Home());
      } else {
        Get.off(Login());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            br(Get.height / 2),
            FadeInUp(
                child: Image.asset(
              'assets/logo.png',
              width: Get.width * 0.2,
            )),
            br(Get.height * 0.3),
            FadeIn(
              delay: Duration(milliseconds: 1500),
              child: Text("BATCH 16",
                  style: TextStyle(
                      fontFamily: raleway, fontWeight: FontWeight.bold)),
            ),
            FadeIn(
              delay: Duration(milliseconds: 2000),
              child: Text("Jamia Madeenathunnoor",
                  style: TextStyle(fontFamily: raleway, color: Colors.black54)),
            )
          ],
        ),
      ),
    );
  }
}
