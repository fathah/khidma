import 'package:dawa/Functions/getComments.dart';
import 'package:dawa/Functions/getSurvey.dart';
import 'package:dawa/View/Profile/UpdateTeam.dart';
import 'package:dawa/View/Survey.dart';
import 'package:dawa/View/Index.dart';
import 'package:dawa/View/Profile.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'Functions/getPosts.dart';
import 'View/Notes.dart';
import 'inc/Const.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {
  int? tab;
  Home({Key? key, this.tab}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController tabController;
  static var body = <Widget>[Index(), Ideas(), Notes(), Profile()];
  static const tabs = <Tab>[
    Tab(
      icon: Icon(
        LineIcons.stream,
        color: primaryColor,
      ),
    ),
    Tab(
      icon: Icon(
        LineIcons.pollH,
        color: primaryColor,
      ),
    ),
    Tab(
      icon: Icon(
        LineIcons.stickyNote,
        color: primaryColor,
      ),
    ),
    Tab(
      icon: Icon(
        LineIcons.user,
        color: primaryColor,
      ),
    )
  ];

  @override
  void initState() {
    if (mainBox!.get('team') == null || mainBox!.get('team').length < 4) {
      Future.delayed(Duration(seconds: 1), () {
        Get.off(UpdateTeam(isnew: true));
      });
    }
    getPosts();
    getSurveys();
    getComments();
    tabController = TabController(
        vsync: this, length: tabs.length, initialIndex: widget.tab ?? 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(controller: tabController, children: body),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            border: Border(
                top: BorderSide(
                    color: primaryColor.withOpacity(0.2), width: 0.3))),
        child:
            TabBar(indicatorWeight: 3, controller: tabController, tabs: tabs),
      ),
    );
  }

  tabIcon(icon) {
    return Icon(icon, color: primaryColor);
  }
}
