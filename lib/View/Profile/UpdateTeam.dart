import 'dart:convert';

import 'package:dawa/Functions/getTeams.dart';
import 'package:dawa/Functions/updateProfile.dart';
import 'package:dawa/Home.dart';
import 'package:dawa/inc/Const.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class UpdateTeam extends StatefulWidget {
  bool isnew;
  UpdateTeam({Key? key, this.isnew = false}) : super(key: key);

  @override
  _UpdateTeamState createState() => _UpdateTeamState();
}

class _UpdateTeamState extends State<UpdateTeam> {
  DropdownEditingController<String>? controller =
      DropdownEditingController<String>();
  List<String> teams = [];

  setTeams() {
    if (mainBox!.get('teamList') != null) {
      List<String> tempList = [];
      mainBox!.get('teamList').forEach((team) {
        tempList.add(team['name']);
      });
      setState(() {
        teams = tempList;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    controller!.addListener(() {});

    if (mainBox!.get('team') != null) {
      controller!.value = mainBox!.get('team');
    }
    setTeams();

    getTeams().then((value) => {
          if (value) {setTeams()}
        });
  }

  String updatedTo = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Team"),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: Container(
          child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            br(20),
            if (widget.isnew)
              Text(
                "Please select your team to continue using the app",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.red[800]),
              ),
            br(10),
            Text(
              "Select Team",
              style: TextStyle(fontSize: 20),
            ),
            br(8),
            TextDropdownFormField(
              controller: controller,
              options: teams,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                  labelText: "Team"),
              dropdownHeight: Get.height / 2,
              onChanged: (dynamic val) {
                updateProfile({
                  'team': val,
                }).then((value) {
                  if (value) {
                    setState(() => updatedTo = "Team Updated to $val");
                    mainBox!.put('team', val);
                  }
                });
              },
            ),
            br(15),
            Text(updatedTo),
            br(15),
            if (widget.isnew && updatedTo.length > 4)
              ElevatedButton(
                  onPressed: () {
                    Get.off(Home());
                  },
                  child: Text("Go to Home"))
            // ElevatedButton(
            //     onPressed: () async {
            //       teamsAll.forEach((name) async {
            //         final response = await http.post(
            //           Uri.parse(BASE_URL + "team"),
            //           body: {
            //             'api': API_KEY,
            //             'name': name,
            //             'id': (teamsAll.indexOf(name) + 1).toString()
            //           },
            //         );
            //         if (response.statusCode == 200) {
            //           print(json.decode(response.body));
            //         }
            //         Future.delayed(Duration(milliseconds: 500));
            //       });
            //     },
            //     child: Text("Update"))
          ],
        ),
      )),
    );
  }
}

List teamsAll = [
  "Kayalpattinam",
  "Vellur",
  "Oddanchatram",
  "Coimbatore",
  "Pollachi",
  "Udumalaipettai",
  "Ooty",
  "Kangeyam",
  "Tiruchirappalli",
  "Keelakarai",
  "Adirampattinam",
  "Kottaippattinam ",
  "Madurai",
  "Chennai",
  "Salem",
  "Tiruppur",
  "Nagore",
  "Puducherry",
  "Thanjavur"
];
