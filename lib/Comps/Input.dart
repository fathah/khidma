import 'package:dawa/inc/Const.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget FxInput(
    {onChanged,
    String labelText = "",
    bool obscureText = false,
    int minValue = 0,
    pass1,
    pass2}) {
  OutlineInputBorder border = OutlineInputBorder(
      borderSide: BorderSide(
        color: primaryColor,
        width: 1,
      ),
      borderRadius: const BorderRadius.all(Radius.circular(3.0)));

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
    child: TextFormField(
      onChanged: (val) => onChanged(val),
      obscureText: obscureText,
      validator: (value) {
        if (value!.length < minValue) return "Please enter a valid $labelText";
        if (pass1 != null && pass1 != null) {
          if (pass1 != pass2) {
            return "Passwords do not match";
          }
        }
      },
      decoration: InputDecoration(
          labelText: labelText,
          hintText: labelText,
          enabledBorder: border,
          focusedBorder: border,
          errorBorder: border,
          focusedErrorBorder: border),
      style: TextStyle(fontFamily: raleway),
    ),
  );
}
