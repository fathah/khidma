import 'dart:convert';

import 'package:dawa/inc/Const.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future addComment(commentBody, postId,
    {String type = 'text',
    String category = 'post',
    String fileLink = ''}) async {
  Map<String, dynamic> body = {
    'api': API_KEY,
    'body': commentBody,
    'createdBy': mainBox!.get('user'),
    'createdAt': DateTime.now().toString(),
    'team': mainBox!.get('team') ?? "",
    'postId': postId,
    'type': type,
    'category': category,
    'fileLink': fileLink,
    'userstatus': mainBox!.get('userstatus') ?? "user",
  };

  try {
    final response = await http.post(
      Uri.parse(BASE_URL + "comments"),
      body: body,
    );
    var decod = json.decode(response.body);
    if (decod['status'] == true) {
      commentBox!.put(decod['data']['key'], decod['data']);
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
