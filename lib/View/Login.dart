import 'package:dawa/Comps/Buttons.dart';
import 'package:dawa/Comps/Input.dart';
import 'package:dawa/Functions/login.dart';
import 'package:dawa/inc/Const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// ignore: must_be_immutable
class Login extends StatelessWidget {
  ValueNotifier usename = ValueNotifier("");
  ValueNotifier password = ValueNotifier("");
  ValueNotifier<bool> loading = ValueNotifier<bool>(false);

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            br(20),
            FxInput(
                labelText: "Username",
                onChanged: (val) => usename.value = val,
                minValue: 4),
            FxInput(
                labelText: "Password",
                onChanged: (val) => password.value = val,
                obscureText: true,
                minValue: 4),
            ValueListenableBuilder(
                valueListenable: loading,
                builder: (context, bool load, child) {
                  return FxButton(
                      onClick: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (formKey.currentState!.validate()) {
                          loading.value = true;
                          login(usename.value.trim(), password.value.trim())
                              .then((value) => loading.value = false);
                        }
                      },
                      text: "Login",
                      textWidget: load
                          ? Container(
                              width: 30,
                              child: SpinKitWave(
                                color: Colors.white,
                                size: 20,
                              ))
                          : Text("Login"),
                      align: Alignment.center);
                }),
            br(20),
          ],
        ),
      ),
    );
  }
}
