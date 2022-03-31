import 'dart:convert';

import 'package:dawa/inc/Const.dart';
import 'package:http/http.dart' as http;

Future updateProfile(Map body) async {
  Map<String, dynamic> bodyData = {'api': API_KEY, ...body};

  try {
    final response = await http.put(
      Uri.parse(BASE_URL + "profile/" + mainBox!.get('key')),
      body: bodyData,
    );
    var decod = json.decode(response.body);
    if (decod['status'] == true) {
      snack(text: "Successfully Updated!", bgcolor: mainSecColor);
      return true;
    } else {
      snack(text: decod['message']);
      return false;
    }
  } catch (e) {
    print(e);
    snack(text: "Please check your connection!");
    return false;
  }
}
