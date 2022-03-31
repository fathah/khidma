import 'package:cached_network_image/cached_network_image.dart';
import 'package:dawa/Comps/AddPost.dart';
import 'package:dawa/Comps/Comments.dart';
import 'package:dawa/Comps/DeleteDialog.dart';
import 'package:dawa/Comps/TopSheet.dart';
import 'package:dawa/Functions/deletePost.dart';
import 'package:dawa/Functions/getPosts.dart';
import 'package:dawa/inc/Const.dart';
import 'package:fabexdateformatter/fabexdateformatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:line_icons/line_icons.dart';

class Index extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rihla"),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return getPosts();
        },
        child: Container(
          child: ValueListenableBuilder(
              valueListenable: postBox!.listenable(),
              builder: (context, Box postsData, child) {
                List posts = postsData.values.toList();
                posts.sort((a, b) {
                  return a['createdAt'].compareTo(b['createdAt']);
                });
                posts = posts.reversed.toList();
                return posts.length < 1
                    ? Center(
                        child: CupertinoActivityIndicator(),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.only(top: 10),
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          return SinglePost(post: posts[index]);
                        },
                      );
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showTopModalSheet(
            context: context,
            height: 400,
            child: AddPost(),
          );
        },
        child: Icon(
          LineIcons.feather,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class SinglePost extends StatelessWidget {
  Map post;
  bool isInnerComment;
  SinglePost({Key? key, required this.post, this.isInnerComment = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
            child: Container(
              color: Colors.white,
              child: Material(
                elevation: 1,
                borderRadius: BorderRadius.circular(3),
                child: InkWell(
                  onTap: () {
                    Get.to(Comments(post: post),
                        transition: Transition.cupertino);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                                  post['createdBy'][0].toUpperCase(),
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold),
                                )),
                            brw(8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${post['createdBy']}",
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontFamily: raleway,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Team ${post['team'] ?? 'Unknown'}",
                                  style: TextStyle(color: Colors.black38),
                                ),
                              ],
                            )
                          ],
                        ),
                        if (post['body'] != null &&
                            post['body'].length > 0) ...[
                          br(10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              "${post['body']}",
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 18),
                            ),
                          ),
                        ],
                        if (post['fileLink'] != null &&
                            post['fileLink'].length > 6)
                          InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return Dialog(
                                      child: Container(
                                        width: Get.width,
                                        height: Get.height / 2,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              FILES_URL + post['fileLink'],
                                          fit: BoxFit.cover,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            width: Get.width,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: imageProvider,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              width: Get.width,
                              height: 200,
                              child: CachedNetworkImage(
                                imageUrl: FILES_URL + post['fileLink'],
                                fit: BoxFit.cover,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        br(12),
                        Text(
                          FabexFormatter().dateTimeToStringDate(
                              DateTime.parse("${post['createdAt']}")),
                          style: TextStyle(color: Colors.black38),
                        ),
                        br(10),
                        if (!isInnerComment) ...[
                          ValueListenableBuilder(
                              valueListenable: commentBox!.listenable(),
                              builder: (context, Box cmntBox, snapshot) {
                                List comments = cmntBox.values.toList();
                                List moderatorPosts = comments.where((comment) {
                                  return comment['postId'] == post['key'] &&
                                      comment['userstatus'] != null &&
                                      comment['userstatus'] == 'moderator';
                                }).toList();

                                List voicePosts = comments.where((comment) {
                                  return comment['postId'] == post['key'] &&
                                      comment['type'] == 'voice';
                                }).toList();

                                List currentPostComments =
                                    comments.where((comment) {
                                  return comment['postId'] == post['key'];
                                }).toList();

                                return Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: bgPale,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(LineIcons.commentAlt),
                                            brw(4),
                                            Text(
                                                "${currentPostComments.length}")
                                          ]),
                                    ),
                                    if (moderatorPosts.length > 0) ...[
                                      brw(8),
                                      CircleAvatar(
                                          backgroundColor: bgPale,
                                          radius: 16,
                                          child: Icon(LineIcons.user)),
                                    ],
                                    if (voicePosts.length > 0) ...[
                                      brw(8),
                                      CircleAvatar(
                                          backgroundColor: bgPale,
                                          radius: 16,
                                          child: Icon(LineIcons.microphone)),
                                    ],
                                    Spacer(),
                                    if (post['createdBy'] ==
                                        mainBox!.get('user'))
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 15.0),
                                        child: InkWell(
                                          onTap: () {
                                            deleteDialog(context, title: "Post",
                                                onDelete: () {
                                              deletePost(post['key']);
                                            });
                                          },
                                          child: CircleAvatar(
                                              backgroundColor: bgPale,
                                              radius: 16,
                                              child: Icon(LineIcons.trash)),
                                        ),
                                      ),
                                  ],
                                );
                              })
                        ],
                        br(10),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          br(10),
        ],
      ),
    );
  }
}
