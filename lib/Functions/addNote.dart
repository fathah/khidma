import 'package:dawa/inc/Const.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NewNote extends StatefulWidget {
  @override
  _NewNoteState createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  TextEditingController feedTextCtrlr = TextEditingController();
  @override
  void initState() {
    feedTextCtrlr.text = mainBox!.get('note') ?? "";
    feedTextCtrlr.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 320,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            br(10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "New Note",
                style: TextStyle(fontSize: 20),
              ),
            ),
            br(10),
            TextFormField(
                style: TextStyle(color: Colors.black),
                controller: feedTextCtrlr,
                textCapitalization: TextCapitalization.sentences,
                autofocus: true,
                maxLines: 5,
                decoration: feedsInputDeco(),
                maxLength: 200,
                onChanged: (value) {
                  mainBox!.put('note', value);
                }),
            br(10),
            Align(
              alignment: Alignment.centerRight,
              child: feedTextCtrlr.text.length > 2
                  ? ElevatedButton(
                      onPressed: () {
                        noteBox!.add({
                          "time": DateTime.now(),
                          "content": feedTextCtrlr.text
                        }).then((value) {
                          mainBox!.put('note', null);
                        });
                        Get.back();
                      },
                      child: Text(
                        "Add Note",
                      ),
                    )
                  : br(5),
            )
          ],
        ));
  }

  InputDecoration feedsInputDeco() {
    OutlineInputBorder border = OutlineInputBorder(
        borderSide: BorderSide(
      color: Colors.transparent,
    ));
    return InputDecoration(
        hintText: "Type here...",
        hintStyle: TextStyle(color: Colors.black38),
        enabledBorder: border,
        focusedBorder: border,
        isDense: true,
        counterStyle: TextStyle(color: Colors.white));
  }
}
