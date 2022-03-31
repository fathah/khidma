import 'package:dawa/inc/Const.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget FxButton(
    {required onClick,
    required text,
    textWidget,
    color,
    textColor,
    Alignment align = Alignment.centerRight}) {
  return Padding(
    padding: const EdgeInsets.only(right: 10, top: 10),
    child: Align(
      alignment: align,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(color ?? primaryColor)),
        onPressed: onClick,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: textWidget ??
              Text(
                text,
                style: TextStyle(color: textColor ?? Colors.white),
              ),
        ),
      ),
    ),
  );
}
