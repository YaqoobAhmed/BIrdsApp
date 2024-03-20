import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Views/Onboarding/Screen/onboarding.dart';
import 'package:firebase/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
        password == "" ||
        cPassword == "") {
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
        // String uid = userCredential.user!.uid;

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
          // "uid": uid,
          "displayName": name,
          "email": email,
          "phoneNumber": phone,
          "nic": nic
          // "profilePick": donwnloadUrl
        };
        await _firestore
            .collection("user")
            .doc(userCredential.user!.email)
            .set(userdata);

        print("User created");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: blueColor,
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          content: Text(
            "$name, Welcome to Avian Tech Emporium",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ));
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => OnboardingScreen()));
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
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
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
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: blueColor),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16)),
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
                      keyboardType: TextInputType.number,
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

// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase/Views/Onboarding/Screen/onboarding.dart';
// import 'package:firebase/colors.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class RegisterView extends StatefulWidget {
//   const RegisterView({Key? key}) : super(key: key);

//   @override
//   State<RegisterView> createState() => _RegisterViewState();
// }

// class _RegisterViewState extends State<RegisterView> {
//   TextEditingController nameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController cPasswordController = TextEditingController();
//   bool isLoading = false;
//   File? profilePick;
//   String? errorText;

//   @override
//   void initState() {
//     super.initState();
//     // Add input formatter to enforce 11-digit numeric phone number
//     phoneController
//         .addListener(() => validatePhoneNumber(phoneController.text));
//   }

//   void validatePhoneNumber(String input) {
//     // Remove non-numeric characters
//     String phone = input.replaceAll(RegExp(r'[^0-9]'), '');
//     if (phone.length > 11) {
//       phone = phone.substring(0, 11); // Limit to 11 digits
//     }
//     setState(() {
//       phoneController.value = TextEditingValue(
//         text: phone,
//         selection: TextSelection.collapsed(offset: phone.length),
//       );
//     });
//   }

//   void registerUser() async {
//     setState(() {
//       errorText = null; // Reset error message
//     });

//     String name = nameController.text.trim();
//     String email = emailController.text.trim();
//     String password = passwordController.text.trim();
//     String cPassword = cPasswordController.text.trim();
//     String phone = phoneController.text.trim();

//     if (name.isEmpty ||
//         email.isEmpty ||
//         password.isEmpty ||
//         cPassword.isEmpty) {
//       setState(() {
//         errorText = "Please fill all fields";
//       });
//       return;
//     } else if (password != cPassword) {
//       setState(() {
//         errorText = "Passwords do not match";
//       });
//       return;
//     } else if (phone.length != 11) {
//       setState(() {
//         errorText = "Phone number must be 11 digits";
//       });
//       return;
//     }

//     try {
//       setState(() {
//         isLoading = true;
//       });

//       UserCredential userCredential = await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(email: email, password: password);

//       FirebaseFirestore _firestore = FirebaseFirestore.instance;
//       Map<String, dynamic> userdata = {
//         "name": name,
//         "email": email,
//         "phone": phone,
//       };
//       await _firestore.collection("user").add(userdata);

//       print("User created");
//       Navigator.pushReplacement(context,
//           MaterialPageRoute(builder: (context) => const OnboardingScreen()));
//     } on FirebaseAuthException catch (ex) {
//       setState(() {
//         errorText = ex.message;
//       });
//       print(ex.code.toString());
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(
//             Icons.arrow_back,
//             color: whiteColor,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: blueColor,
//         title: Text(
//           "Signup Page",
//           style: TextStyle(color: whiteColor),
//         ),
//       ),
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 40),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(height: MediaQuery.of(context).size.height * 0.05),
//                   TextFormField(
//                     controller: nameController,
//                     keyboardType: TextInputType.name,
//                     decoration: InputDecoration(
//                       labelStyle: TextStyle(color: blueColor),
//                       iconColor: blueColor,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       suffixIcon: Icon(
//                         Icons.person,
//                         color: blueColor,
//                       ),
//                       labelText: "Full Name",
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   TextFormField(
//                     controller: emailController,
//                     keyboardType: TextInputType.emailAddress,
//                     decoration: InputDecoration(
//                       labelStyle: TextStyle(color: blueColor),
//                       iconColor: blueColor,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       suffixIcon: Icon(
//                         Icons.email,
//                         color: blueColor,
//                       ),
//                       labelText: "Email",
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   TextFormField(
//                     controller: phoneController,
//                     keyboardType: TextInputType.phone,
//                     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                     decoration: InputDecoration(
//                       labelStyle: TextStyle(color: blueColor),
//                       iconColor: blueColor,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       suffixIcon: Icon(
//                         Icons.phone,
//                         color: blueColor,
//                       ),
//                       labelText: "Phone",
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   TextFormField(
//                     obscureText: true,
//                     controller: passwordController,
//                     decoration: InputDecoration(
//                       labelStyle: TextStyle(color: blueColor),
//                       iconColor: blueColor,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       suffixIcon: Icon(
//                         Icons.lock,
//                         color: blueColor,
//                       ),
//                       labelText: "Password",
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   TextFormField(
//                     obscureText: true,
//                     controller: cPasswordController,
//                     decoration: InputDecoration(
//                       labelStyle: TextStyle(color: blueColor),
//                       iconColor: blueColor,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       suffixIcon: Icon(
//                         Icons.lock,
//                         color: blueColor,
//                       ),
//                       labelText: "Confirm Password",
//                     ),
//                   ),
//                   if (errorText != null)
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         errorText!,
//                         style: TextStyle(color: Colors.red),
//                       ),
//                     ),
//                   const SizedBox(height: 20),
//                   GestureDetector(
//                     onTap: () {
//                       registerUser();
//                     },
//                     child: Container(
//                       height: MediaQuery.of(context).size.height * 0.05,
//                       width: MediaQuery.of(context).size.width * 0.8,
//                       decoration: BoxDecoration(
//                         color: blueColor,
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: const Center(
//                         child: Text(
//                           "Register",
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ),
//                   if (isLoading)
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: CircularProgressIndicator(),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
