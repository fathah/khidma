import 'package:dawa/Comps/TopSheet.dart';
import 'package:dawa/Functions/addNote.dart';
import 'package:dawa/inc/Const.dart';
import 'package:fabexdateformatter/fabexdateformatter.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:line_icons/line_icons.dart';

class Notes extends StatelessWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ValueListenableBuilder(
                valueListenable: noteBox!.listenable(),
                builder: (ctx, Box box, child) {
                  List notes = [];
                  box.values.toList().forEach((element) {
                    notes.add([box.values.toList().indexOf(element), element]);
                  });
                  List newNotes = notes.reversed.toList();

                  return newNotes.length > 0
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: box.length,
                            itemBuilder: (ctx, index) {
                              final note = newNotes[index][1];
                              return Container(
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 0.4,
                                              color: Colors.black38))),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              note["content"],
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: raleway),
                                            ),
                                            Text(
                                              FabexFormatter()
                                                  .dateTimeToStringDate(
                                                      note["time"]),
                                              style: TextStyle(
                                                color: Colors.black38,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            noteBox!
                                                .deleteAt(newNotes[index][0]);
                                          },
                                          icon: Icon(LineIcons.trash,
                                              color: Colors.red[800]))
                                    ],
                                  ));
                            },
                          ),
                        )
                      : Center(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                br(Get.height * 0.4),
                                Text(
                                  "No notes yet",
                                  style: TextStyle(color: Colors.black45),
                                ),
                              ]),
                        );
                })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showTopModalSheet(context: context, child: NewNote());
        },
        child: Icon(
          LineIcons.plus,
        ),
      ),
    );
  }
}
