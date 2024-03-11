import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class SellScreen extends StatefulWidget {
  SellScreen({super.key});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  TextEditingController titleControlle = TextEditingController();
  TextEditingController breedControlle = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController discriptionController = TextEditingController();
  bool isLoading = false;
  File? birdPic;
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

      birdPic = File(result.path);

      setState(() {});
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

  void AddPost() async {
    String title = titleControlle.text.trim();
    String breed = breedControlle.text.trim();
    String age = ageController.text.trim();
    String price = priceController.text.trim();
    String address = addressController.text.trim();
    String discription = discriptionController.text.trim();
    String contact = contactController.text.trim();

    // Get the current user's phone number
    User? currentUser = FirebaseAuth.instance.currentUser;
    // String contact = FirebaseAuth.instance.currentUser?.phoneNumber ?? '';

    if (title == "" ||
        breed == "" ||
        contact == "" ||
        age == "" ||
        price == "" ||
        address == "" ||
        discription == "" ||
        birdPic == null) {
      // print("${currentUser!.phoneNumber}");
      // print("${contact}");
      print("Please fill all fields");
    } else {
      try {
        setState(() {
          isLoading = true;
        });

        UploadTask uploadTask = FirebaseStorage.instance
            .ref()
            .child("birdPictures")
            .child(Uuid().v1())
            .putFile(birdPic!);

        TaskSnapshot taskSnapshot = await uploadTask;
        String donwnloadUrl = await taskSnapshot.ref.getDownloadURL();

        // Store user info
        print("${currentUser!.phoneNumber}");
        print("${contact}");

        FirebaseFirestore _firestore = FirebaseFirestore.instance;
        Map<String, dynamic> sellData = {
          "uid": currentUser.uid,
          "name": title,
          "breed": breed,
          "contact": contact,
          "age": age,
          "price": price,
          "address": address,
          "discription": discription,
          "birdPic": donwnloadUrl
        };
        await _firestore.collection("adds").add(sellData);

        print("Add posted");

        // Show bottom snackbar
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: blueColor,
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          content: const Text(
            "Post Added",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ));
      } on FirebaseAuthException catch (ex) {
        print(ex.code.toString());
      } finally {
        setState(() {
          isLoading = false;
          clear();
        });
      }
    }
  }

  void clear() {
    priceController.clear();
    contactController.clear();
    titleControlle.clear();
    breedControlle.clear();
    ageController.clear();
    discriptionController.clear();
    priceController.clear();
    addressController.clear();
    image = null; // Fixed the assignment operator
    birdPic = null; // Fixed the assignment operator
    setState(() {
      imageselected = false; // Reset imageselected to false
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: whiteColor,
            )),
        backgroundColor: blueColor,
        title: Text(
          "Enter Details",
          style: TextStyle(color: whiteColor),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 15,
                  ),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          _showImageSourceDialog(context);
                        },
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey.withOpacity(
                              0.5), // Set a background color if no image is selected
                          child: imageselected
                              ? null
                              : Icon(
                                  Icons.add_photo_alternate,
                                  color: blueColor,
                                ),
                          backgroundImage:
                              birdPic != null ? FileImage(birdPic!) : null,
                        ),
                      ),
                      SizedBox(
                        height: 5,
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
                ),
                Form(
                    autovalidateMode: AutovalidateMode.always,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: SizedBox(
                        // height: MediaQuery.of(context).size.height * 0.75,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: titleControlle,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(color: blueColor),
                                labelText: "Title:",
                              ),
                            ),
                            TextFormField(
                              controller: breedControlle,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(color: blueColor),
                                labelText: "Breed:",
                              ),
                            ),
                            TextFormField(
                              controller: ageController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  labelStyle: TextStyle(color: blueColor),
                                  labelText: "Age:",
                                  hintText: "1.2"),
                            ),
                            TextFormField(
                              controller: discriptionController,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(color: blueColor),
                                labelText: "Discription:",
                              ),
                            ),
                            TextFormField(
                              controller: contactController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(color: blueColor),
                                labelText: "Contact:",
                              ),
                            ),
                            TextFormField(
                              controller: priceController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(color: blueColor),
                                labelText: "Price:",
                              ),
                            ),
                            TextFormField(
                              controller: addressController,
                              keyboardType: TextInputType.streetAddress,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(color: blueColor),
                                labelText: "Address:",
                              ),
                            ),
                            SizedBox(
                              height: 35,
                            ),
                            GestureDetector(
                              onTap: AddPost,
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                width: MediaQuery.of(context).size.width * 0.8,
                                decoration: BoxDecoration(
                                    color: blueColor,
                                    borderRadius: BorderRadius.circular(16)),
                                child: Center(
                                  child: Text(
                                    "Add Post",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
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
                    )),
              ],
            ),
          ),

          //Conditionally show CircularProgressIndicator based on isLoading
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
