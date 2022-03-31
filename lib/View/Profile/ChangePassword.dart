import 'package:dawa/Comps/Buttons.dart';
import 'package:dawa/Comps/Input.dart';
import 'package:dawa/Functions/updateProfile.dart';
import 'package:dawa/inc/Const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final formKey = GlobalKey<FormState>();

  String? password1;
  String? password2;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Password"),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: Container(
          child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            br(15),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "Change your password",
                style: TextStyle(fontSize: 20),
              ),
            ),
            FxInput(
                labelText: "Password",
                onChanged: (val) => setState(() => password1 = val),
                obscureText: true,
                minValue: 4,
                pass1: password1,
                pass2: password2),
            FxInput(
                labelText: "Verify Password",
                onChanged: (val) => setState(() => password2 = val),
                obscureText: true,
                minValue: 4,
                pass1: password1,
                pass2: password2),
            FxButton(
                onClick: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (formKey.currentState!.validate()) {
                    setState(() {
                      loading = true;
                    });
                    updateProfile({'password': password1!.trim()})
                        .then((value) {
                      formKey.currentState!.reset();
                      setState(() {
                        loading = false;
                      });
                    });
                  }
                },
                text: "Login",
                textWidget: loading
                    ? Container(
                        width: 30,
                        child: SpinKitWave(
                          color: Colors.white,
                          size: 20,
                        ))
                    : Text("Change Password"),
                align: Alignment.center)
          ],
        ),
      )),
    );
  }
}
