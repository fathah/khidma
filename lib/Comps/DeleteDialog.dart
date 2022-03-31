import 'package:dawa/inc/Const.dart';
import 'package:flutter/material.dart';

deleteDialog(context, {String title = "", required Function onDelete}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Delete $title"),
        content: Text(
            "Are you sure you want to delete this ${title.toLowerCase()}?"),
        actions: <Widget>[
          TextButton(
            child: Text("Cancel"),
            onPressed: () {
              Get.back();
            },
          ),
          TextButton(
            child:
                Text("Delete Anyway", style: TextStyle(color: Colors.red[700])),
            onPressed: () {
              onDelete();
              Get.back();
            },
          ),
          brw(10)
        ],
      );
    },
  );
}
