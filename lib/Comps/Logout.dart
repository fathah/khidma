import 'package:dawa/Utils/Splash.dart';
import 'package:dawa/inc/Const.dart';
import 'package:flutter/material.dart';

logout(context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Logout from Rihla"),
        content: Text("Are you sure you want to logout from the app? "),
        actions: <Widget>[
          TextButton(
            child: Text("Cancel"),
            onPressed: () {
              Get.back();
            },
          ),
          TextButton(
            child: Text("Logout", style: TextStyle(color: Colors.cyan[800])),
            onPressed: () {
              mainBox!.clear();
              postBox!.clear();
              commentBox!.clear();
              surveyBox!.clear();
              Get.offAll(Splash());
            },
          ),
          TextButton(
            child: Text("Logout & Clear Notes",
                style: TextStyle(color: Colors.red[700])),
            onPressed: () {
              mainBox!.clear();
              postBox!.clear();
              commentBox!.clear();
              surveyBox!.clear();
              noteBox!.clear();
              Get.offAll(Splash());
            },
          ),
          brw(10)
        ],
      );
    },
  );
}
