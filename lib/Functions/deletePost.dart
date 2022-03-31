import 'package:dawa/inc/Const.dart';
import 'package:http/http.dart' as http;

Future deletePost(key) async {
  try {
    final response = await http
        .delete(Uri.parse(BASE_URL + "posts/$key"), body: {'api': API_KEY});
    if (response.statusCode == 200) {
      var itemData = postBox!.get(key);
      postBox!.delete(key);
      snack(text: "Post Deleted", bgcolor: mainSecColor);
      if (itemData['fileLink'] != null && itemData['fileLink'].length > 5) {
        await http.post(Uri.parse(FILES_URL + "delete.php"),
            body: {'api': API_KEY, 'filename': itemData['fileLink']});
      }
    } else {
      snack(
        text: "Failed to delete post",
      );
    }
  } catch (e) {
    print("$e");
    snack(text: "Please check your connection");
  }
}
