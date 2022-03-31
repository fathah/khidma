import 'dart:convert';

import 'package:dawa/inc/Const.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future getUsers() async {
  try {
    final response = await http.get(
      Uri.parse(BASE_URL + "users?api=" + API_KEY),
    );
    if (response.statusCode == 200) {
      var decod = json.decode(response.body);
      if (decod['items'].length > 0) {
        List tempUsers = [];
        decod['items'].forEach((item) {
          tempUsers.add(item);
        });
        mainBox!.put('allUsers', tempUsers);
      }
    }
  } catch (e) {
    print("$e");
    Get.snackbar("Failed", "Please check your connection!",
        titleText: br(0),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 4,
        margin: EdgeInsets.all(10));
  }
}
