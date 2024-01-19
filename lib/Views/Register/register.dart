import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Views/Mainpage/home.dart';
import 'package:firebase/colors.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:uuid/uuid.dart';

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
  bool isLoading = false;
  File? profilePick;

  void RegisterUser() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String cPassword = cPasswordController.text.trim();
    String phone = phoneController.text.trim();

    if (name == "" || email == "" || password == "" || cPassword == ""
        //  ||
        // profilePick == null

        ) {
      print("Please fill all fields");
    } else if (password != cPassword) {
      print("Password does not match");
    } else {
      try {
        setState(() {
          isLoading = true;
        });
        // ignore: unused_local_variable
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        // UploadTask uploadTask = FirebaseStorage.instance
        //     .ref()
        //     .child("UserProfilePictures")
        //     .child(Uuid().v1())
        //     .putFile(profilePick!);

        // TaskSnapshot taskSnapshot = await uploadTask;
        // String donwnloadUrl = await taskSnapshot.ref.getDownloadURL();

        //fore storing user info
        FirebaseFirestore _firestore = FirebaseFirestore.instance;
        Map<String, dynamic> userdata = {
          "name": name,
          "email": email,
          "phone": phone,
          // "profilePick": donwnloadUrl
        };
        await _firestore.collection("user").add(userdata);

        print("User created");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeView()));
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
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: whiteColor,
            )),
        centerTitle: true,
        backgroundColor: blueColor,
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
              child: Container(
                height: MediaQuery.of(context).size.height * 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: blueColor),
                        iconColor: blueColor,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16)),
                        suffixIcon: Icon(
                          Icons.person,
                          color: blueColor,
                        ),
                        labelText: "Full Name",
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: blueColor),
                        iconColor: blueColor,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16)),
                        suffixIcon: Icon(
                          Icons.email,
                          color: blueColor,
                        ),
                        labelText: "Email",
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: blueColor),
                        iconColor: blueColor,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16)),
                        suffixIcon: Icon(
                          Icons.phone,
                          color: blueColor,
                        ),
                        labelText: "phone",
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: passwordController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: blueColor),
                        iconColor: blueColor,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16)),
                        suffixIcon: Icon(
                          Icons.lock,
                          color: blueColor,
                        ),
                        labelText: "Password",
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: cPasswordController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: blueColor),
                        iconColor: blueColor,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16)),
                        suffixIcon: Icon(
                          Icons.lock,
                          color: blueColor,
                        ),
                        labelText: "Confirm Password",
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    GestureDetector(
                      onTap: RegisterUser,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                            color: blueColor,
                            borderRadius: BorderRadius.circular(16)),
                        child: Center(
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







 // Padding(
                //   padding: const EdgeInsets.all(30.0),
                //   child: Column(
                //     children: [
                //       InkWell(
                //         onTap: () async {
                //           XFile? selectedImage = await ImagePicker()
                //               .pickImage(source: ImageSource.gallery);
                //           if (selectedImage != null) {
                //             File convertedfile = File(selectedImage.path);
                //             setState(() {
                //               profilePick = convertedfile;
                //             });
                //             print("image selected");
                //           } else {
                //             print("image is not selected");
                //           }
                //         },
                //         child: CircleAvatar(
                //           radius: 40,
                //           backgroundImage: profilePick != null
                //               ? FileImage(profilePick!)
                //               : null,
                //         ),
                //       ),
                //       Text("Upload Picture"),
                //     ],
                //   ),
                // ),