import 'dart:convert';

import 'package:dawa/inc/Const.dart';
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
        await mainBox!.put('allUsers', tempUsers);
        return true;
      }
    }
  } catch (e) {
    print("$e");
    snack(
      text: "Please check your connection!",
    );
  }
}
