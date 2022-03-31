import 'package:dawa/inc/Const.dart';
import 'package:http/http.dart' as http;

Future deleteSurvey(key) async {
  try {
    final response = await http
        .delete(Uri.parse(BASE_URL + "survey/$key"), body: {'api': API_KEY});
    if (response.statusCode == 200) {
      surveyBox!.delete(key);
      snack(text: "Survey Deleted", bgcolor: mainSecColor);
    } else {
      snack(
        text: "Failed to delete comment",
      );
    }
  } catch (e) {
    print("$e");
    snack(text: "Please check your connection");
  }
}
