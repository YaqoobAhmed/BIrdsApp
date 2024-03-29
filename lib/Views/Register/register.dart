import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/SnackBar/snackBar.dart';
import 'package:firebase/Views/Onboarding/Screen/onboarding.dart';
import 'package:firebase/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();
  TextEditingController nicController = TextEditingController();
  bool isLoading = false;
  File? profilePick;
  String? phoneErrorText;
  void RegisterUser() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String cPassword = cPasswordController.text.trim();
    String phone = phoneController.text.trim();
    String nic = nicController.text.trim();

    if (name == "" ||
        email == "" ||
        nic == "" ||
        phone == "" ||
        password == "" ||
        cPassword == "") {
      print("Please fill all fields");
      CustomSnackBar.showCustomSnackBar(context, "Please Fill in all fields.");
    } else if (password != cPassword) {
      CustomSnackBar.showCustomSnackBar(context, "Password does not match");
      print("Password does not match");
    } else if (phone.length != 11) {
      CustomSnackBar.showCustomSnackBar(
          context, "Contact# must contain 11 digits");
      print("Contact# must contain 11 digits");
    } else if (nic.length != 15) {
      CustomSnackBar.showCustomSnackBar(
          context, "NiC must contain 15 character including '-' ");
      print("NiC must contain 15 character including '-' ");
    } else {
      try {
        setState(() {
          isLoading = true;
        });
        // ignore: unused_local_variable
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        //fore storing user info
        FirebaseFirestore _firestore = FirebaseFirestore.instance;
        Map<String, dynamic> userdata = {
          // "uid": uid,
          "displayName": name.toUpperCase(),
          "email": email.toLowerCase(),
          "phoneNumber": phone,
          "nic": nic
          // "profilePick": donwnloadUrl
        };
        await _firestore
            .collection("user")
            .doc(userCredential.user!.email)
            .set(userdata);

        print("User created");
        CustomSnackBar.showCustomSnackBar(
            context, "$name, Welcome to Avian Tech Emporium");

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => OnboardingScreen()));
      } on FirebaseAuthException catch (ex) {
        CustomSnackBar.showCustomSnackBar(context, ex.code.toString());
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
      appBar: AppBar(
        title: Text(
          "Signup Page",
          style: TextStyle(color: whiteColor),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      textCapitalization: TextCapitalization.words,
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: blueColor),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16)),
                        suffixIcon: Icon(
                          Icons.person,
                          color: blueColor,
                        ),
                        labelText: "Full Name",
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textCapitalization: TextCapitalization.none,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: blueColor),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16)),
                        suffixIcon: Icon(
                          Icons.email,
                          color: blueColor,
                        ),
                        labelText: "Email",
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone, // Allow only numbers
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter
                            .digitsOnly, // Allow only digits
                      ],
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
                      height: 10,
                    ),
                    TextFormField(
                      controller: nicController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: "42101-5XXXXXX-X",
                        labelStyle: TextStyle(color: blueColor),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16)),
                        suffixIcon: Icon(
                          Icons.credit_card,
                          color: blueColor,
                        ),
                        labelText: "NIC",
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: passwordController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: blueColor),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16)),
                        suffixIcon: Icon(
                          Icons.lock,
                          color: blueColor,
                        ),
                        labelText: "Password",
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: cPasswordController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: blueColor),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16)),
                        suffixIcon: Icon(
                          Icons.lock,
                          color: blueColor,
                        ),
                        labelText: "Confirm Password",
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    GestureDetector(
                      onTap: () {
                        RegisterUser();
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                            color: blueColor,
                            borderRadius: BorderRadius.circular(16)),
                        child: const Center(
                          child: Text(
                            "Signup",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
          ),

          // Conditionally show CircularProgressIndicator based on isLoading
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
