import 'package:dawa/Functions/addSurvey.dart';
import 'package:dawa/inc/Const.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AddSurvey extends StatefulWidget {
  AddSurvey({Key? key}) : super(key: key);

  @override
  _AddSurveyState createState() => _AddSurveyState();
}

class _AddSurveyState extends State<AddSurvey> {
  String question = "";
  String body = "";
  bool isLoading = false;

  @override
  void initState() {
    setState(() {
      question = mainBox!.get('surveyQuestion') ?? "";
      body = mainBox!.get('surveyReport') ?? "";
    });
    super.initState();
  }

  OutlineInputBorder border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey,
        width: 0,
      ),
      borderRadius: const BorderRadius.all(Radius.circular(4.0)));

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        width: Get.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            br(20),
            Text(
              'New Survey',
              style: TextStyle(
                  fontSize: 23, fontFamily: raleway, color: Colors.black38),
            ),
            br(20),
            TextFormField(
              initialValue: question,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (val) {
                setState(() => question = val);
                mainBox!.put('surveyQuestion', val);
              },
              autofocus: true,
              decoration: InputDecoration(
                  hintText: "Survey Problem",
                  hintStyle: TextStyle(fontStyle: FontStyle.italic),
                  enabledBorder: border,
                  focusedBorder: border,
                  errorBorder: border,
                  focusedErrorBorder: border),
              style: TextStyle(fontFamily: raleway),
            ),
            br(15),
            TextFormField(
              initialValue: body,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 4,
              onChanged: (val) {
                setState(() => body = val);
                mainBox!.put('surveyReport', val);
              },
              autofocus: true,
              decoration: InputDecoration(
                  hintText: "Report",
                  hintStyle: TextStyle(fontStyle: FontStyle.italic),
                  enabledBorder: border,
                  focusedBorder: border,
                  errorBorder: border,
                  focusedErrorBorder: border),
              style: TextStyle(fontFamily: raleway),
            ),
            br(10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: question.length > 4 && body.length > 3
                    ? () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        setState(() => isLoading = true);
                        await addSurvey(question, body);
                        setState(() => isLoading = false);
                      }
                    : null,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Text("Post"),
                ),
              ),
            ),
            br(10),
            Text(
              isLoading ? "Posting survey..." : "",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            br(10),
          ],
        ));
  }
}
