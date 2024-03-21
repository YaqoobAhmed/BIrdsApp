import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/SnackBar/snackBar.dart';
import 'package:firebase/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class PostArticleScreen extends StatefulWidget {
  PostArticleScreen({Key? key}) : super(key: key);

  @override
  _PostArticleScreenState createState() => _PostArticleScreenState();
}

class _PostArticleScreenState extends State<PostArticleScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isLoading = false;
  File? articlePic;
  bool imageselected = false;

  XFile? image;

  final picker = ImagePicker();

  // method to pick single image while replacing the photo
  Future imagePicker(ImageSource source) async {
    image = (await picker.pickImage(source: source));
    if (image != null) {
      final bytes = await image!.readAsBytes();
      final kb = bytes.length / 1024;
      final mb = kb / 1024;

      if (kDebugMode) {
        print('original image size:' + mb.toString());
      }

      final dir = await path_provider.getTemporaryDirectory();
      final targetPath = '${dir.absolute.path}/temp.jpg';

      // converting original image to compress it
      final result = await FlutterImageCompress.compressAndGetFile(
        image!.path,
        targetPath,
        minHeight: 800, //you can play with this to reduce siz
        minWidth: 800,
        quality: 80, // keep this high to get the original quality of image
      );

      final data = await result!.readAsBytes();
      final newKb = data.length / 1024;
      final newMb = newKb / 1024;

      if (kDebugMode) {
        print('compress image size:' + newMb.toString());
      }

      articlePic = File(result.path);

      setState(() {});
    }
  }

  void addPost() async {
    String title = titleController.text.trim();
    String description = descriptionController.text.trim();

    if (title.isEmpty || description.isEmpty || articlePic == null) {
      CustomSnackBar.showCustomSnackBar(
          context, "Please Fill in all the fields.");
      print("Please fill all fields");
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child("articlePictures")
          .child(Uuid().v1())
          .putFile(articlePic!);

      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      User? currentUser = FirebaseAuth.instance.currentUser;

      FirebaseFirestore _firestore = FirebaseFirestore.instance;
      Map<String, dynamic> articleData = {
        "uid": currentUser!.uid,
        "title": title.toUpperCase(),
        "description": description,
        "articlePic": downloadUrl
      };
      await _firestore.collection("article").add(articleData);

      CustomSnackBar.showCustomSnackBar(context, "Article Posted!.");

      titleController.clear();
      descriptionController.clear();
      setState(() {
        articlePic = null;
        imageselected = false;
      });
    } on FirebaseAuthException catch (ex) {
      CustomSnackBar.showCustomSnackBar(
          context, "Error: ${ex.code.toString()}");
      print(ex.code.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _showImageSourceDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Image Source'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          onPressed: () async {
                            await imagePicker(ImageSource.camera);
                            setState(() {
                              imageselected = true;
                            });
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.camera_alt),
                          color: blueColor,
                        ),
                        Text(
                          "Camera",
                          style: TextStyle(color: blueColor),
                        )
                      ],
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.17),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () async {
                            await imagePicker(ImageSource.gallery);
                            setState(() {
                              imageselected = true;
                            });
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.photo_library),
                          color: blueColor,
                        ),
                        Text(
                          "Gallery",
                          style: TextStyle(color: blueColor),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        _showImageSourceDialog(context);
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 42),
                        child: Container(
                          decoration: BoxDecoration(
                            image: articlePic != null
                                ? DecorationImage(
                                    image: FileImage(articlePic!),
                                    fit: BoxFit.contain,
                                  )
                                : null,
                            color: Colors.grey.withOpacity(0.5),
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: MediaQuery.of(context).size.width * 1,
                          child: articlePic == null
                              ? Center(
                                  child: Icon(
                                    Icons.add_photo_alternate,
                                    color: blueColor,
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _showImageSourceDialog(context),
                      child: Text(
                        "Upload a Picture",
                        style: TextStyle(
                          color: blueColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Form(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: SizedBox(
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          TextFormField(
                            textCapitalization: TextCapitalization.words,
                            controller: titleController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.0)),
                              ),
                              labelStyle: TextStyle(color: blueColor),
                              labelText: "Title:",
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            maxLines: 3,
                            controller: descriptionController,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.0)),
                              ),
                              labelStyle: TextStyle(color: blueColor),
                              labelText: "Description:",
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          GestureDetector(
                            onTap: addPost,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.05,
                              width: MediaQuery.of(context).size.width * 0.8,
                              decoration: BoxDecoration(
                                  color: blueColor,
                                  borderRadius: BorderRadius.circular(16)),
                              child: Center(
                                child: Text(
                                  "Post Article",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  color: blueColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
