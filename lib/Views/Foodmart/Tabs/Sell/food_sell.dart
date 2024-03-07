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

class FoodSellScreen extends StatefulWidget {
  FoodSellScreen({super.key});

  @override
  State<FoodSellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<FoodSellScreen> {
  TextEditingController titleControlle = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController discriptionController = TextEditingController();
  bool isLoading = false;
  File? foodPic;
  bool imageselected = false;

  XFile? image;

  final picker = ImagePicker();

  // method to pick single image while replacing the photo
  Future imagePicker() async {
    image = (await picker.pickImage(source: ImageSource.camera));
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

      foodPic = File(result.path);

      setState(() {});
    }
  }

  void AddPost() async {
    String title = titleControlle.text.trim();
    var contact = contactController.text.trim();
    var price = priceController.text.trim();
    String address = addressController.text.trim();
    String discription = discriptionController.text.trim();

    if (title == "" ||
        contact == "" ||
        price == "" ||
        address == "" ||
        discription == "" ||
        foodPic == null) {
      print("Please fill all fields");
    } else {
      try {
        setState(() {
          isLoading = true;
        });

        UploadTask uploadTask = FirebaseStorage.instance
            .ref()
            .child("foodPictures")
            .child(Uuid().v1())
            .putFile(foodPic!);

        TaskSnapshot taskSnapshot = await uploadTask;
        String donwnloadUrl = await taskSnapshot.ref.getDownloadURL();
        User? currentUser = FirebaseAuth.instance.currentUser;
        //fore storing user info
        FirebaseFirestore _firestore = FirebaseFirestore.instance;
        Map<String, dynamic> foodSellData = {
          "uid": currentUser!.uid,
          "name": title,
          "contact": contact,
          "price": price,
          "address": address,
          "discription": discription,
          "foodPic": donwnloadUrl
        };
        await _firestore.collection("FoodAdds").add(foodSellData);

        print("Add posted");

        //show bottom snackbar
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: blueColor,
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          content: const Text(
            "Post Added",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ));

        //clearing all the data after successful post
        titleControlle.clear();
        contactController.clear();
        priceController.clear();
        priceController.clear();
        addressController.clear();
        discriptionController.clear();
        setState(() {
          foodPic = null;
          imageselected = false;
        });
      } on FirebaseAuthException catch (ex) {
        print(ex.code.toString());
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
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
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                  ),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          imagePicker();
                          setState(() {
                            imageselected = true;
                          });
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
                              foodPic != null ? FileImage(foodPic!) : null,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Upload a Picture",
                        style: TextStyle(
                          color: blueColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Form(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: SizedBox(
                    // height: MediaQuery.of(context).size.height * 0.9,
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
                          height: 50,
                        ),
                        GestureDetector(
                          onTap: AddPost,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.8,
                            decoration: BoxDecoration(
                                color: blueColor,
                                borderRadius: BorderRadius.circular(16)),
                            child: Center(
                              child: Text(
                                "Add Post",
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
