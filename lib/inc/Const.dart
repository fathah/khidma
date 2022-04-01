import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';
export 'package:get/get.dart';

const MaterialColor primaryColor = MaterialColor(
  _primaryColorVal,
  <int, Color>{
    50: Color(0xFF8e44ad),
    100: Color(0xffdcdde1),
    200: Color(0xff74b9ff),
    300: Color(_primaryColorVal),
    400: Color(0xFF2ecc71),
    500: Color(_primaryColorVal),
    600: Color(0xFF000000),
    700: Color(0xFF000000),
    800: Color(0xFF000000),
    900: Color(0xFF000000),
  },
);
const int _primaryColorVal = 0xff485A54;

const bgPale = Color(0xffEEE8E4);
const mainSecColor = Color(0xFF8B6957);

const modalBorderRadius = RoundedRectangleBorder(
  borderRadius: BorderRadius.only(
      topLeft: Radius.circular(20), topRight: Radius.circular(20)),
);

br(double height) {
  return SizedBox(
    height: height,
  );
}

brw(double width) {
  return SizedBox(
    width: width,
  );
}

const raleway = "Raleway";
const nunito = "Nunito";

Box? mainBox;
Box? postBox;
Box? commentBox;
Box? surveyBox;
Box? noteBox;

const BASE_URL = 'https://dawa.deta.dev/';
const UPLOAD_URL = 'https://markazgarden.org/fieldstudy/uploads/upload.php';
const FILES_URL = 'https://markazgarden.org/fieldstudy/uploads/';
const API_KEY = "3b6e5a2f0b61da03e364d11621b467ea";

snack({required text, bgcolor}) {
  Get.snackbar("Failed", text,
      titleText: br(0),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: bgcolor ?? Colors.red,
      colorText: Colors.white,
      borderRadius: 4,
      margin: EdgeInsets.all(10));
}
