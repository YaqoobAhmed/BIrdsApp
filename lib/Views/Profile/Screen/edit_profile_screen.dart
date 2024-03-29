import 'package:firebase/SnackBar/snackBar.dart';
import 'package:firebase/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

TextEditingController _newPasswordController = TextEditingController();
TextEditingController _confirmPasswordController = TextEditingController();
TextEditingController _oldPasswordController = TextEditingController();

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
  late bool ShowPasswordFields = false;

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
    _newPasswordController.clear();
    _oldPasswordController.clear();
    _confirmPasswordController.clear();

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
                          Visibility(
                            visible: ShowPasswordFields == false,
                            child: Column(
                              children: [
                                TextFormField(
                                  textCapitalization: TextCapitalization.words,
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
                                  textCapitalization: TextCapitalization.none,
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
                              ],
                            ),
                          ),
                          Visibility(
                            visible: ShowPasswordFields,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                  controller: _oldPasswordController,
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
                                    labelText: "Old Password",
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                  controller: _newPasswordController,
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
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                ShowPasswordFields = !ShowPasswordFields;
                              });
                            },
                            child: Center(
                              child: Text(
                                ShowPasswordFields
                                    ? "Change Profile Data"
                                    : "Change Password",
                                style: TextStyle(
                                  color: blueColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
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
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;
    String oldPassword = _oldPasswordController.text;

    // Check if any field is empty
    if (newName.isEmpty ||
        newEmail.isEmpty ||
        newNic.isEmpty ||
        newContact.isEmpty) {
      // Show a snackbar to indicate empty fields
      CustomSnackBar.showCustomSnackBar(context, "Please Fill in all fields.");
      return;
    } else if (newContact.length != 11) {
      CustomSnackBar.showCustomSnackBar(
          context, "Contact# must contain 11 digits.");
      return;
    } else if (newNic.length != 15) {
      CustomSnackBar.showCustomSnackBar(
          context, "NiC must contain 15 character including ' - ' ");
      return;
    }

    // Check if newPassword field is not empty
    if (newPassword.isNotEmpty) {
      // Check if confirm password field is empty
      if (confirmPassword.isEmpty) {
        CustomSnackBar.showCustomSnackBar(
            context, "Please confirm your password.");
        return;
      }

      // Check if old password field is empty
      if (oldPassword.isEmpty) {
        CustomSnackBar.showCustomSnackBar(
            context, "Please enter your old password.");
        return;
      }

      // Check if passwords match
      if (newPassword != confirmPassword) {
        CustomSnackBar.showCustomSnackBar(context, "Password do not match.");
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
        "displayName": newName.toUpperCase(),
        "email": newEmail,
        "nic": newNic,
        "phoneNumber": newContact,
      });

      // Update user password if newPassword is not empty
      if (newPassword.isNotEmpty) {
        // Re-authenticate user
        User user = FirebaseAuth.instance.currentUser!;
        bool reauthenticated = false;
        String enteredOldPassword = oldPassword;

        while (!reauthenticated) {
          AuthCredential credential = EmailAuthProvider.credential(
              email: user.email!, password: enteredOldPassword);

          try {
            // Attempt reauthentication
            await user.reauthenticateWithCredential(credential);
            reauthenticated = true; // Reauthentication successful
          } on FirebaseAuthException catch (e) {
            if (e.code == 'wrong-password') {
              // Old password is incorrect
              CustomSnackBar.showCustomSnackBar(
                  context, "Incorrect old password.");

              enteredOldPassword = "";
            } else {
              // Handle other FirebaseAuthException errors
              CustomSnackBar.showCustomSnackBar(context, 'Error: ${e.message}');

              return;
            }
          }
        }

        // Update password if reauthentication is successful
        if (reauthenticated) {
          await user.updatePassword(newPassword);
          CustomSnackBar.showCustomSnackBar(
              context, 'Password updated successfully.');
        }
      }
      CustomSnackBar.showCustomSnackBar(
          context, 'Profile updated successfully..');
      // Navigate back to the previous screen
      Navigator.pop(context);
    } catch (e) {
      // Handle errors
      CustomSnackBar.showCustomSnackBar(context, 'Error updating profile: $e');
      print("Error updating profile: $e");
    }
  }
}
