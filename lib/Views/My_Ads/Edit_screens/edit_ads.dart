import 'package:flutter/material.dart';
import 'package:firebase/SnackBar/snackBar.dart';
import 'package:firebase/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class EditAdScreen extends StatefulWidget {
  final String adId;
  final Map<String, dynamic> initialData;

  EditAdScreen({required this.adId, required this.initialData});

  @override
  _EditAdScreenState createState() => _EditAdScreenState();
}

class _EditAdScreenState extends State<EditAdScreen> {
  late TextEditingController _nameController;
  late TextEditingController _breedController;
  late TextEditingController _ageController;
  late TextEditingController _descriptionController;
  late TextEditingController _addressController;
  late TextEditingController _priceController;
  late TextEditingController _contactController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialData["name"]);
    _breedController = TextEditingController(text: widget.initialData["breed"]);
    _ageController = TextEditingController(text: widget.initialData["age"]);
    _descriptionController =
        TextEditingController(text: widget.initialData["description"]);
    _addressController =
        TextEditingController(text: widget.initialData["address"]);
    _priceController = TextEditingController(text: widget.initialData["price"]);
    _contactController =
        TextEditingController(text: widget.initialData["contact"]);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _priceController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Ad"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SizedBox(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Form(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: SizedBox(
                        // height: MediaQuery.of(context).size.height * 0.75,
                        child: Column(
                          children: [
                            TextFormField(
                              textCapitalization: TextCapitalization.words,
                              controller: _nameController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(color: blueColor),
                                labelText: "Title:",
                              ),
                            ),
                            TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              controller: _breedController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(color: blueColor),
                                labelText: "Breed:",
                              ),
                            ),
                            TextFormField(
                              controller: _ageController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  labelStyle: TextStyle(color: blueColor),
                                  labelText: "Age:",
                                  hintText: "1.2"),
                            ),
                            TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              controller: _descriptionController,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(color: blueColor),
                                labelText: "Discription:",
                              ),
                            ),
                            TextFormField(
                              controller: _contactController,
                              keyboardType:
                                  TextInputType.phone, // Allow only numbers
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter
                                    .digitsOnly, // Allow only digits
                              ],
                              decoration: InputDecoration(
                                labelStyle: TextStyle(color: blueColor),
                                labelText: "Contact",
                              ),
                            ),
                            TextFormField(
                              controller: _priceController,
                              keyboardType:
                                  TextInputType.number, // Allow only numbers
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter
                                    .digitsOnly, // Allow only digits
                              ],
                              decoration: InputDecoration(
                                labelStyle: TextStyle(color: blueColor),
                                labelText: "Price",
                              ),
                            ),
                            TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              controller: _addressController,
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
                              onTap: () => updateAd(),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                width: MediaQuery.of(context).size.width * 0.8,
                                decoration: BoxDecoration(
                                    color: blueColor,
                                    borderRadius: BorderRadius.circular(16)),
                                child: Center(
                                  child: Text(
                                    "Update Post",
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
            ),
          ),
        ));
  }

  void updateAd() async {
    String newTitle = _nameController.text.trim();
    String newBreed = _breedController.text.trim();
    String newAge = _ageController.text.trim();
    String newDescription = _descriptionController.text.trim();
    String newAddress = _addressController.text.trim();
    String newPrice = _priceController.text.trim();
    String newContact = _contactController.text.trim();
    if (newTitle == "" ||
        newBreed == "" ||
        newAge == "" ||
        newDescription == "" ||
        newPrice == "" ||
        newAddress == "" ||
        newContact == "") {
      // print("${currentUser!.phoneNumber}");
      // print("${contact}");
      CustomSnackBar.showCustomSnackBar(context, "Please fill in all fields");
      print("Please fill all fields");
      return;
    } else if (newContact.length != 11) {
      CustomSnackBar.showCustomSnackBar(
          context, "Contact must contain 11 Digits");
      return;
    } else if (newPrice == '0') {
      CustomSnackBar.showCustomSnackBar(context, "Price Can not be 0.");
      return;
    } else {
      try {
        // Store user info
        Center(
          child: CircularProgressIndicator(),
        );
        await FirebaseFirestore.instance
            .collection("birdAds")
            .doc(widget.adId)
            .update({
          "name": newTitle.toUpperCase(),
          "breed": newBreed,
          "age": newAge,
          "description": newDescription,
          "address": newAddress,
          "price": newPrice,
          "contact": newContact,
        });

        CustomSnackBar.showCustomSnackBar(context, "Ad Updated!.");
      } on FirebaseAuthException catch (ex) {
        CustomSnackBar.showCustomSnackBar(
            context, "Error: ${ex.code.toString()}");
      } finally {
        Navigator.pop(context);
      }
    }
  }
}
