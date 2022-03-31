import 'package:dawa/Comps/Logout.dart';
import 'package:dawa/inc/Const.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import 'Profile/ChangePassword.dart';
import 'Profile/UpdateTeam.dart';
import 'Profile/ViewTeam.dart';

class Profile extends StatelessWidget {
  List items = [
    {
      "title": "View Teams",
      "to": "viewTeams",
      "icon": LineIcons.users,
    },
    {
      "title": "Update Team",
      "to": "updateTeam",
      "icon": LineIcons.usersCog,
    },
    {
      "title": "Change Password",
      "to": "changePassword",
      "icon": LineIcons.lock,
    },
    {
      "title": "Logout",
      "to": "logout",
      "icon": LineIcons.alternateSignOut,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Panel"),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: Container(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 0.2,
                    ),
                  ),
                ),
                child: ListTile(
                  leading: Icon(items[index]["icon"]),
                  title: Text(items[index]["title"]),
                  onTap: () {
                    switch (items[index]["to"]) {
                      case "viewTeams":
                        Get.to(ViewTeams());
                        break;
                      case "updateTeam":
                        Get.to(UpdateTeam());
                        break;
                      case "changePassword":
                        Get.to(ChangePassword());
                        break;
                      case "logout":
                        logout(context);
                        break;
                      default:
                    }
                  },
                ));
          },
        ),
      ),
    );
  }
}
