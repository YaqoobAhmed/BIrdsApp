import 'package:firebase/colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditItemsScreen extends StatefulWidget {
  final String adId;
  final Map<String, dynamic> initialData;

  EditItemsScreen({required this.adId, required this.initialData});

  @override
  _EditAdScreenState createState() => _EditAdScreenState();
}

class _EditAdScreenState extends State<EditItemsScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _addressController;
  late TextEditingController _priceController;
  late TextEditingController _contactController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialData["name"]);

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
        title: Text("Edit Items"),
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
                            controller: _nameController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: blueColor),
                              labelText: "Title:",
                            ),
                          ),
                          TextFormField(
                            controller: _addressController,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: blueColor),
                              labelText: "Discription:",
                            ),
                          ),
                          TextFormField(
                            controller: _contactController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: blueColor),
                              labelText: "Contact:",
                            ),
                          ),
                          TextFormField(
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: blueColor),
                              labelText: "Price:",
                            ),
                          ),
                          TextFormField(
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
                            onTap: updateItem,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.05,
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
      ),
    );
  }

  void updateItem() {
    String newName = _nameController.text;
    String newDescription = _descriptionController.text;
    String newAddress = _addressController.text;
    String newPrice = _priceController.text;
    String newContact = _contactController.text;

    // Update the ad in Firestore
    FirebaseFirestore.instance.collection("adds").doc(widget.adId).update({
      "name": newName,
      "description": newDescription,
      "address": newAddress,
      "price": newPrice,
      "contact": newContact,
    });

    // Navigate back to the previous screen
    Navigator.pop(context);
  }
}
