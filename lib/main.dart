import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'Utils/Splash.dart';
import 'inc/Const.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // AndroidAlarmManager.initialize();
  //await Firebase.initializeApp();
  await Hive.initFlutter();
  mainBox = await Hive.openBox("mainBox");
  postBox = await Hive.openBox("postBox");
  commentBox = await Hive.openBox("commentBox");
  noteBox = await Hive.openBox("noteBox");
  surveyBox = await Hive.openBox("surveyBox");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bahth - Dawa Tour',
      defaultTransition: Transition.fadeIn,
      theme: ThemeData(
          primarySwatch: primaryColor,
          fontFamily: nunito,
          scaffoldBackgroundColor: Color(0xffEEE8E4),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              side: BorderSide(width: 1.0, color: primaryColor),
            ),
          )),
      home: Splash(),
    );
  }
}
