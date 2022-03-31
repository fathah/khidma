import 'package:dawa/Comps/Record.dart';
import 'package:dawa/Functions/addComment.dart';
import 'package:dawa/Functions/deleteComment.dart';
import 'package:dawa/View/Index.dart';
import 'package:dawa/inc/Const.dart';
import 'package:fabexdateformatter/fabexdateformatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'DeleteDialog.dart';

class Comments extends StatefulWidget {
  var post;
  Comments({Key? key, required this.post}) : super(key: key);

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  TextEditingController commentController = TextEditingController();
  final commentFormKey = GlobalKey<FormState>();
  bool posting = false;

  FlutterSoundPlayer myPlayer = FlutterSoundPlayer();

  OutlineInputBorder border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey,
        width: 0,
      ),
      borderRadius: const BorderRadius.all(Radius.circular(4.0)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          color: bgPale,
          child: Column(
            children: [
              br(20),
              SinglePost(
                post: widget.post,
                isInnerComment: true,
              ),
              ValueListenableBuilder(
                  valueListenable: commentBox!.listenable(),
                  builder: (context, Box cmntBox, snapshot) {
                    List comments = cmntBox.values.toList();
                    comments.sort((a, b) {
                      return a['createdAt'].compareTo(b['createdAt']);
                    });
                    List finalComments = comments.where((element) {
                      return element['postId'] == widget.post['key'];
                    }).toList();
                    finalComments = finalComments.reversed.toList();
                    return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Form(
                          key: commentFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RecordVoice(
                                postId: widget.post['key'],
                              ),
                              br(15),
                              TextFormField(
                                textCapitalization:
                                    TextCapitalization.sentences,
                                maxLines: 2,
                                controller: commentController,
                                validator: (value) {
                                  if (value!.length < 1) {
                                    return "Please enter something to comment.";
                                  }
                                },
                                decoration: InputDecoration(
                                    hintText: "Add new comment",
                                    hintStyle:
                                        TextStyle(fontStyle: FontStyle.italic),
                                    enabledBorder: border,
                                    focusedBorder: border,
                                    errorBorder: border,
                                    focusedErrorBorder: border),
                                style: TextStyle(fontFamily: raleway),
                              ),
                              br(5),
                              Align(
                                alignment: Alignment.centerRight,
                                child: OutlinedButton.icon(
                                    onPressed: !posting
                                        ? () {
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                            if (commentFormKey.currentState!
                                                .validate()) {
                                              setState(() => posting = true);
                                              addComment(commentController.text,
                                                      widget.post['key'])
                                                  .then((value) {
                                                commentController.text = "";
                                                setState(() => posting = false);
                                              });
                                            }
                                          }
                                        : null,
                                    icon: Icon(Icons.send),
                                    label: Text(
                                        !posting ? "Comment" : "Postng...")),
                              ),
                              br(15),
                              if (finalComments.length > 0) ...[
                                Text(
                                  "Comments",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                ListView.builder(
                                  itemBuilder: (ctx, index) {
                                    var data = finalComments[index];
                                    return data['type'] == 'voice'
                                        ? VoiceMessage(data: data, index: index)
                                        : Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white38,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            padding: EdgeInsets.all(10),
                                            margin: EdgeInsets.symmetric(
                                                vertical: 4),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    CircleAvatar(
                                                        backgroundColor:
                                                            primaryColor
                                                                .withOpacity(
                                                                    0.2),
                                                        child: Text(
                                                          data['createdBy'][0]
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                              color:
                                                                  primaryColor),
                                                        )),
                                                    brw(10),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                  data[
                                                                      'createdBy'],
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              Text(
                                                                  "(${data['team'] ?? "Unknown"})",
                                                                  style: TextStyle(
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .italic,
                                                                      color: Colors
                                                                          .grey)),
                                                            ],
                                                          ),
                                                          Text(
                                                            data['body'],
                                                            style: TextStyle(),
                                                          ),
                                                          br(5),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                FabexFormatter()
                                                                    .dateTimeToStringDate(
                                                                        DateTime.parse(
                                                                            "${data['createdAt']}")),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black38),
                                                              ),
                                                              if (data[
                                                                      'createdBy'] ==
                                                                  mainBox!.get(
                                                                      'user'))
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          8.0),
                                                                  child:
                                                                      InkWell(
                                                                          onTap:
                                                                              () {
                                                                            deleteDialog(context,
                                                                                title: "Comment",
                                                                                onDelete: () {
                                                                              deleteComment(data['key']);
                                                                            });
                                                                          },
                                                                          child: Text(
                                                                              "Delete",
                                                                              style: TextStyle(color: Colors.red[800]))),
                                                                )
                                                            ],
                                                          ),
                                                          br(5),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                br(5),
                                              ],
                                            ),
                                          );
                                  },
                                  itemCount: finalComments.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                ),
                              ] else ...[
                                Container(
                                  height: Get.height * 0.3,
                                  child: Center(
                                    child: Text("No comments yet"),
                                  ),
                                )
                              ],
                            ],
                          ),
                        ));
                  }),
            ],
          ),
        ),
      ),
    );
  }

  int currentPlayIndex = -1;
  int playState = 0; // 0 = stopped, 1 = playing, 2 = paused

  Widget VoiceMessage({required data, required index}) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white38, borderRadius: BorderRadius.circular(5)),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                  backgroundColor: primaryColor.withOpacity(0.2),
                  child: Text(
                    "${data['createdBy'][0].toUpperCase()}",
                    style: TextStyle(color: primaryColor),
                  )),
              brw(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("${data['createdBy']}",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("(${data['team'] ?? "Unknown"})",
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey)),
                      ],
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          if (myPlayer.isPlaying && currentPlayIndex == index) {
                            setState(() => playState = 2);
                            myPlayer.pausePlayer();
                          } else if (myPlayer.isPaused &&
                              currentPlayIndex == index) {
                            setState(() => playState = 1);
                            myPlayer.resumePlayer();
                          } else {
                            myPlayer.openPlayer().then((value) {
                              setState(() {
                                currentPlayIndex = index;
                                playState = 1;
                              });
                              myPlayer.startPlayer(
                                fromURI: FILES_URL + data['fileLink'],
                                whenFinished: () {
                                  setState(() {
                                    currentPlayIndex = -1;
                                    playState = 0;
                                  });
                                  myPlayer.closePlayer();
                                },
                              );
                            });
                          }
                        },
                        child: Row(
                          children: [
                            Icon(
                              currentPlayIndex == index && playState == 1
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: mainSecColor,
                            ),
                            Text(
                                currentPlayIndex == index && playState == 1
                                    ? "Tap to Pause"
                                    : currentPlayIndex == index &&
                                            playState == 2
                                        ? "Tap to Resume"
                                        : "Play Voice Message",
                                style: TextStyle(
                                  color: mainSecColor,
                                ))
                          ],
                        ),
                      ),
                    ),
                    br(5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          FabexFormatter().dateTimeToStringDate(
                              DateTime.parse("${data['createdAt']}")),
                          style: TextStyle(color: Colors.black38),
                        ),
                        if (data['createdBy'] == mainBox!.get('user'))
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: InkWell(
                                onTap: () {
                                  deleteDialog(context, title: "Comment",
                                      onDelete: () {
                                    deleteComment(data['key']);
                                  });
                                },
                                child: Text("Delete",
                                    style: TextStyle(color: Colors.red[800]))),
                          )
                      ],
                    ),
                    br(5),
                  ],
                ),
              )
            ],
          ),
          br(5),
        ],
      ),
    );
  }
}
