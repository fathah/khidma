import 'dart:convert';

import 'package:dawa/inc/Const.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future addSurvey(String question, String postBody) async {
  Map<String, dynamic> body = {
    'api': API_KEY,
    'question': question,
    'body': postBody,
    'createdBy': mainBox!.get('user'),
    'createdAt': DateTime.now().toString(),
    'team': mainBox!.get('team') ?? "",
  };

  try {
    final response = await http.post(
      Uri.parse(BASE_URL + "survey"),
      body: body,
    );
    var decod = json.decode(response.body);
    if (decod['status'] == true) {
      surveyBox!.put(decod['data']['key'], decod['data']);
      mainBox!.put('surveyQuestion', null);
      mainBox!.put('surveyReport', null);
      Get.back();
    } else {
      Get.snackbar("Failed", decod['message'],
          titleText: br(0),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 4,
          margin: EdgeInsets.all(10));
    }
  } catch (e) {
    print(e);
    Get.snackbar("Failed", "Please check your connection!",
        titleText: br(0),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 4,
        margin: EdgeInsets.all(10));
  }
}
