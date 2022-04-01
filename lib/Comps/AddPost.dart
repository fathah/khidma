import 'dart:convert';
import 'dart:io';

import 'package:dawa/Functions/addPost.dart';
import 'package:dawa/inc/Const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';

// ignore: must_be_immutable
class AddPost extends StatefulWidget {
  AddPost({Key? key}) : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  String body = mainBox!.get('postTemp') ?? "";
  bool isLoading = false;
  File? _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (mainBox!.get('postImageTemp') != null) {
      setState(() {
        _image = File(mainBox!.get('postImageTemp'));
      });
    }
  }

  Future<void> getImage() async {
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery, maxWidth: 1000, imageQuality: 70);

    if (pickedFile != null) {
      mainBox!.put('postImageTemp', pickedFile.path);
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
  }

// UPLOAD IMAGE
  upload(File imageFile) async {
    try {
      var stream =
          new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();

      var uri = Uri.parse(UPLOAD_URL);
      var request = new http.MultipartRequest("POST", uri);
      var multipartFile = new http.MultipartFile('file', stream, length,
          filename: basename(imageFile.path));
      request.files.add(multipartFile);
      request.fields['api'] = API_KEY;
      var response = await request.send();
      print(response.statusCode);
      // listen for response
      response.stream.transform(utf8.decoder).listen((value) async {
        var decode = json.decode(value);
        if (decode['status'] == 'success') {
          String fileLink = decode['file'];
          await addPost(body, fileLink: fileLink);
          setState(() => isLoading = false);
        }
      });
    } catch (e) {
      print(e);
      snack(text: "Please check your connection!");
    }
  }

  OutlineInputBorder border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.transparent,
        width: 0,
      ),
      borderRadius: const BorderRadius.all(Radius.circular(4.0)));

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        width: Get.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            br(20),
            Text(
              'Add Post',
              style: TextStyle(
                  fontSize: 23, fontFamily: raleway, color: Colors.black38),
            ),
            br(20),
            TextFormField(
              initialValue: body,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 4,
              onChanged: (val) {
                setState(() => body = val);

                mainBox!.put('postTemp', val);
              },
              autofocus: true,
              decoration: InputDecoration(
                  hintText: "Type Here...",
                  hintStyle: TextStyle(fontStyle: FontStyle.italic),
                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                  enabledBorder: border,
                  focusedBorder: border,
                  errorBorder: border,
                  focusedErrorBorder: border),
              style: TextStyle(fontFamily: raleway),
            ),
            br(5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                        radius: 25,
                        backgroundColor: bgPale,
                        child: _image != null
                            ? InkWell(
                                onTap: () {
                                  getImage();
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: FileImage(_image!),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(50)),
                                ),
                              )
                            : IconButton(
                                tooltip: "Add Image",
                                onPressed: () {
                                  getImage();
                                },
                                icon: Icon(LineIcons.image))),
                    brw(5),
                    if (_image != null)
                      TextButton(
                          onPressed: () {
                            mainBox!.put('postImageTemp', null);
                            setState(() {
                              _image = null;
                            });
                          },
                          child: Text('Remove',
                              style: TextStyle(color: Colors.red[800])))
                  ],
                ),
                ElevatedButton(
                  onPressed: body.length > 3 || _image != null
                      ? () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          setState(() => isLoading = true);
                          if (_image != null) {
                            upload(_image!);
                          } else {
                            await addPost(body);
                            setState(() => isLoading = false);
                          }
                        }
                      : null,
                  child: Text("Post"),
                ),
              ],
            ),
            br(15),
            isLoading
                ? Row(
                    children: [
                      CupertinoActivityIndicator(),
                      brw(10),
                      Text("Posting...")
                    ],
                  )
                : Container(),
            br(10),
          ],
        ));
  }
}
