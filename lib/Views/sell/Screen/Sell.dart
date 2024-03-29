import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/SnackBar/snackBar.dart';
import 'package:firebase/colors.dart';
import 'package:firebase/provider/phone_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class SellScreen extends StatefulWidget {
  SellScreen({super.key});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController breedController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool _isLoading = false;
  File? _birdPic;
  bool _imageselected = false;

  Future<void> imagePicker(ImageSource source) async {
    XFile? image = await ImagePicker().pickImage(source: source);

    if (image != null) {
      final bytes = await image.readAsBytes();
      final kb = bytes.length / 1024;
      final mb = kb / 1024;

      if (kDebugMode) {
        print('original image size: $mb MB');
      }

      final dir = await path_provider.getTemporaryDirectory();
      final targetPath = '${dir.absolute.path}/temp.jpg';

      final result = await FlutterImageCompress.compressAndGetFile(
        image.path,
        targetPath,
        minHeight: 800,
        minWidth: 800,
        quality: 80,
      );

      final data = await result!.readAsBytes();
      final newKb = data.length / 1024;
      final newMb = newKb / 1024;

      if (kDebugMode) {
        print('compressed image size: $newMb MB');
      }

      setState(() {
        _birdPic = File(result.path);
        ;
        _imageselected = true; // Update _imageselected to true
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
                          onPressed: () {
                            imagePicker(ImageSource.camera);

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
                          onPressed: () {
                            imagePicker(ImageSource.gallery);

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
    PhoneProvider phoneProvider =
        Provider.of<PhoneProvider>(context, listen: false);
    String title = titleController.text.trim();
    String breed = breedController.text.trim();
    String age = ageController.text.trim();
    String price = priceController.text.trim();
    String address = addressController.text.trim();
    String description = descriptionController.text.trim();
    String? contact =
        phoneProvider.phoneNumber; // Get the current user's phone number

    User? currentUser = FirebaseAuth.instance.currentUser;

    if (title == "" ||
        breed == "" ||
        contact == "" ||
        age == "" ||
        price == "" ||
        address == "" ||
        description == "" ||
        _birdPic == null) {
      CustomSnackBar.showCustomSnackBar(context, "Please fill in all fields");
      print("Please fill all fields");
    } else if (contact?.length != 11) {
      CustomSnackBar.showCustomSnackBar(
          context, "Contact must contain 11 Digits");
      return;
    } else if (price == '0') {
      CustomSnackBar.showCustomSnackBar(context, "Price Can not be 0.");
      return;
    } else {
      try {
        setState(() {
          _isLoading = true;
        });

        UploadTask uploadTask = FirebaseStorage.instance
            .ref()
            .child("birdPictures")
            .child(Uuid().v1())
            .putFile(_birdPic!);

        TaskSnapshot taskSnapshot = await uploadTask;
        String donwnloadUrl = await taskSnapshot.ref.getDownloadURL();

        // Store user info

        FirebaseFirestore _firestore = FirebaseFirestore.instance;
        Map<String, dynamic> sellData = {
          "uid": currentUser?.uid,
          "name": title.toUpperCase(),
          "breed": breed,
          "contact": contact,
          "age": age,
          "price": price,
          "address": address,
          "description": description,
          "birdPic": donwnloadUrl
        };
        await _firestore.collection("birdAds").add(sellData);
        CustomSnackBar.showCustomSnackBar(context, "Ad Posted");

        print("Ad posted");
      } on FirebaseAuthException catch (ex) {
        CustomSnackBar.showCustomSnackBar(
            context, "Error: ${ex.code.toString()}");

        print(ex.code.toString());
      } finally {
        setState(() {
          _isLoading = false;
          clear();
        });
      }
    }
  }

  void clear() {
    titleController.clear();
    breedController.clear();
    ageController.clear();
    descriptionController.clear();
    priceController.clear();
    addressController.clear();
    _birdPic = null;
    _imageselected = false; // Update _imageselected to false
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
                              0.5), // Set a background color if no _image is selected
                          child: _imageselected
                              ? null
                              : Icon(
                                  Icons.add_photo_alternate,
                                  color: blueColor,
                                ),
                          backgroundImage:
                              _birdPic != null ? FileImage(_birdPic!) : null,
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
                        child: Column(
                          children: [
                            TextFormField(
                              textCapitalization: TextCapitalization.words,
                              controller: titleController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(color: blueColor),
                                labelText: "Title:",
                              ),
                            ),
                            TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              controller: breedController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(color: blueColor),
                                labelText: "Breed:",
                              ),
                            ),
                            TextFormField(
                              controller: ageController,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true), // Allow decimal values
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp(
                                    r'[0-9.]')), // Allow only digits and decimal point
                              ],
                              decoration: InputDecoration(
                                labelStyle: TextStyle(color: blueColor),
                                labelText: "Age:",
                                hintText: "1.2",
                              ),
                            ),
                            TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              controller: descriptionController,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(color: blueColor),
                                labelText: "Description:",
                              ),
                            ),
                            TextFormField(
                              controller: priceController,
                              keyboardType:
                                  TextInputType.number, // Allow only numbers
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter
                                    .digitsOnly, // Allow only digits
                              ],
                              decoration: InputDecoration(
                                labelStyle: TextStyle(color: blueColor),
                                labelText: "Price:",
                              ),
                            ),
                            TextFormField(
                              textCapitalization: TextCapitalization.sentences,
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

          //Conditionally show CircularProgressIndicator based on _isLoading
          if (_isLoading)
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
