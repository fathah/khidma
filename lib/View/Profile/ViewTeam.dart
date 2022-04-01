import 'package:dawa/Functions/getTeams.dart';
import 'package:dawa/Functions/getUsers.dart';
import 'package:dawa/inc/Const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ViewTeams extends StatefulWidget {
  ViewTeams({Key? key}) : super(key: key);

  @override
  _ViewTeamsState createState() => _ViewTeamsState();
}

class _ViewTeamsState extends State<ViewTeams> {
  @override
  void initState() {
    super.initState();
    getTeams().then((value) => {
          if (value) {setState(() => teams = mainBox!.get('teamList') ?? [])}
        });
    getUsers().then((value) => {
          if (value) {setState(() => users = mainBox!.get('allUsers') ?? [])}
        });
  }

  String updatedTo = "";

  List teams = mainBox!.get('teamList') ?? [];
  List users = mainBox!.get('allUsers') ?? [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Teams"),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: teams.length < 1 || users.length < 1
            ? Container(
                height: Get.height,
                child: Center(child: CupertinoActivityIndicator()))
            : Container(
                child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    br(10),
                    Text("Teams",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    br(10),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: teams.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 2.0, vertical: 4),
                          child: Material(
                            elevation: 1,
                            borderRadius: BorderRadius.all(Radius.circular(3)),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 8),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${teams[index]['name']}",
                                      style: TextStyle(
                                          fontSize: 18, color: mainSecColor)),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: users
                                          .where((user) =>
                                              user['team'] != null &&
                                              user['team'] ==
                                                  teams[index]['name'])
                                          .toList()
                                          .map((e) {
                                        return Text("⇌ ${e['fullname']}");
                                      }).toList())
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )),
      ),
    );
  }
}
