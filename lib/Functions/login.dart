import 'dart:convert';

import 'package:dawa/Home.dart';
import 'package:dawa/inc/Const.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future login(username, password) async {
  Map<String, dynamic> body = {
    'api': API_KEY,
    'username': username,
    'password': password
  };

  try {
    final response = await http.post(
      Uri.parse(BASE_URL + "login"),
      body: body,
    );
    var decod = json.decode(response.body);
    if (decod['status'] == true) {
      var user = decod['user'];

      mainBox!.put("user", user['username']);
      mainBox!.put("fullname", user['fullname']);
      mainBox!.put("jamiaId", user['jamiaId']);
      mainBox!.put("key", user['key']);
      mainBox!.put("team", user['team']);
      mainBox!.put("userstatus", user['status'] ?? "user");
      Get.offAll(Home());
    } else {
      Get.snackbar("Password", decod['message'],
          titleText: br(0),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 4,
          margin: EdgeInsets.all(10));
    }
  } catch (e) {
    print(e);
  }
}
