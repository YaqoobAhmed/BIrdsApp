import 'package:firebase/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

TextEditingController _passwordController = TextEditingController();
TextEditingController _confirmPasswordController = TextEditingController();

class EditProfileScreen extends StatefulWidget {
  final String uId;
  final String phoneNumber;
  final String displayName;
  final String email;
  final String nic;

  EditProfileScreen({
    required this.uId,
    required this.displayName,
    required this.email,
    required this.nic,
    required this.phoneNumber,
  });

  @override
  _EditAdScreenState createState() => _EditAdScreenState();
}

class _EditAdScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _nicController;
  late TextEditingController _contactController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.displayName);
    _emailController = TextEditingController(text: widget.email);
    _nicController = TextEditingController(text: widget.nic);
    _contactController = TextEditingController(text: widget.phoneNumber);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _nicController.dispose();
    _contactController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
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
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: blueColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              suffixIcon: Icon(
                                Icons.person,
                                color: blueColor,
                              ),
                              labelText: "Full Name",
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            readOnly: true,
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              suffixIcon: Icon(
                                Icons.email,
                                color: Colors.grey,
                              ),
                              labelText: "Email",
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: _contactController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: blueColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              suffixIcon: Icon(
                                Icons.phone,
                                color: blueColor,
                              ),
                              labelText: "Contact",
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: _nicController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "42101-5XXXXXX-X",
                              labelStyle: TextStyle(color: blueColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              suffixIcon: Icon(
                                Icons.credit_card,
                                color: blueColor,
                              ),
                              labelText: "NIC",
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: blueColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              suffixIcon: Icon(
                                Icons.lock,
                                color: blueColor,
                              ),
                              labelText: "New Password",
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: blueColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              suffixIcon: Icon(
                                Icons.lock,
                                color: blueColor,
                              ),
                              labelText: "Confirm New Password",
                            ),
                          ),
                          SizedBox(
                            height: 35,
                          ),
                          GestureDetector(
                            onTap: updateProfile,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.05,
                              width: MediaQuery.of(context).size.width * 0.8,
                              decoration: BoxDecoration(
                                color: blueColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Text(
                                  "Update Profile",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void updateProfile() async {
    // Get the values from the text controllers
    String newName = _nameController.text;
    String newEmail = _emailController.text;
    String newNic = _nicController.text;
    String newContact = _contactController.text;
    String newPassword = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    // Check if any field is empty
    if (newName.isEmpty ||
        newEmail.isEmpty ||
        newNic.isEmpty ||
        newContact.isEmpty) {
      // Show a snackbar to indicate empty fields
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    // Check if newPassword field is not empty
    if (newPassword.isNotEmpty) {
      // Check if confirm password field is empty
      if (confirmPassword.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please confirm your password.')),
        );
        return;
      }

      // Check if passwords match
      if (newPassword != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Passwords do not match.')),
        );
        return;
      }
    }

    try {
      // Show a loading indicator
      Center(child: CircularProgressIndicator());

      // Update user profile
      await FirebaseFirestore.instance
          .collection("user")
          .doc(widget.uId)
          .update({
        "displayName": newName,
        "email": newEmail,
        "nic": newNic,
        "phoneNumber": newContact,
      });

      // Update user password if newPassword is not empty
      if (newPassword.isNotEmpty) {
        // Confirm password before updating
        await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
      }

      // Navigate back to the previous screen
      Navigator.pop(context);
    } catch (e) {
      // Handle errors
      print("Error updating profile: $e");
    }
  }
}
