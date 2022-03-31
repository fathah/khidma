import 'dart:convert';
import 'package:dawa/inc/Const.dart';
import 'package:http/http.dart' as http;

Future getTeams() async {
  try {
    final response = await http.get(
      Uri.parse(BASE_URL + "team?api=" + API_KEY),
    );
    if (response.statusCode == 200) {
      var decod = json.decode(response.body);
      if (decod['items'].length > 0) {
        mainBox!.put("teamList", decod['items']);
      }
    }
  } catch (e) {
    print("$e");
    snack(text: "Please check your connection!");
  }
}
