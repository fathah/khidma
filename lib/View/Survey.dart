import 'package:dawa/Comps/AddSurvey.dart';
import 'package:dawa/Comps/DeleteDialog.dart';
import 'package:dawa/Comps/TopSheet.dart';
import 'package:dawa/Functions/deleteSurvey.dart';
import 'package:dawa/Functions/getPosts.dart';
import 'package:dawa/Functions/getSurvey.dart';
import 'package:dawa/inc/Const.dart';
import 'package:fabexdateformatter/fabexdateformatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Ideas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Survey"),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return getSurveys();
        },
        child: Container(
          child: ValueListenableBuilder(
              valueListenable: surveyBox!.listenable(),
              builder: (context, Box surveysData, child) {
                List surveys = surveysData.values.toList();
                surveys.sort((a, b) {
                  return a['createdAt'].compareTo(b['createdAt']);
                });
                surveys = surveys.reversed.toList();

                return surveys.length < 1
                    ? Center(
                        child: CupertinoActivityIndicator(),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.only(top: 10),
                        itemCount: surveys.length,
                        itemBuilder: (context, index) {
                          return SinglePost(survey: surveys[index]);
                        },
                      );
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showTopModalSheet(
            context: context,
            child: AddSurvey(),
          );
        },
        child: Icon(
          Icons.post_add_outlined,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class SinglePost extends StatelessWidget {
  Map survey;
  SinglePost({Key? key, required this.survey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(3),
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              Container(
                width: Get.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                            backgroundColor: primaryColor.withOpacity(0.2),
                            child: Text(
                              survey['createdBy'][0].toUpperCase(),
                              style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold),
                            )),
                        brw(8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${survey['createdBy']}",
                              style: TextStyle(
                                color: primaryColor,
                                fontFamily: raleway,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Team ${survey['team'] ?? 'Unknown'}",
                              style: TextStyle(color: Colors.black38),
                            ),
                          ],
                        )
                      ],
                    ),
                    br(10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${survey['question']}",
                            style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold),
                          ),
                          Linkify(
                            text: "${survey['body']}",
                            style: TextStyle(color: Colors.black87),
                            onOpen: (link) async {
                              if (await canLaunch(link.url)) {
                                await launch(link.url);
                              } else {
                                throw 'Could not launch $link';
                              }
                            },
                          ),
                          br(12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                FabexFormatter()
                                    .dateTimeToStringDate(DateTime.parse(
                                        "${survey['createdAt']}"))
                                    .split("-")[1],
                                style: TextStyle(color: Colors.black38),
                              ),
                              if (survey['createdBy'] == mainBox!.get('user'))
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: InkWell(
                                      onTap: () {
                                        deleteDialog(context, title: "Survey",
                                            onDelete: () {
                                          deleteSurvey(survey['key']);
                                        });
                                      },
                                      child: Text("Delete",
                                          style: TextStyle(
                                              color: Colors.red[800]))),
                                )
                            ],
                          ),
                        ],
                      ),
                    ),
                    br(20),
                  ],
                ),
              ),
              br(10),
            ],
          ),
        ),
      ),
    );
  }
}
