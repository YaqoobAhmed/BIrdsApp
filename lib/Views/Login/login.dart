import 'package:firebase/SnackBar/snackBar.dart';
import 'package:firebase/Views/Onboarding/Screen/onboarding.dart';
import 'package:firebase/Views/Register/register.dart';
import 'package:firebase/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false; // Added a boolean to manage loading state

  Future<void> login() async {
    String emailAddress = emailController.text.trim();
    String password = passwordController.text.trim();

    if (emailAddress.isEmpty || password.isEmpty) {
      print("Please fill all fields");
      CustomSnackBar.showCustomSnackBar(context, "Please Fill in all fields.");

      return;
    }

    try {
      setState(() {
        isLoading =
            true; // Set loading state to true when starting login process
      });

      // ignore: unused_local_variable
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress.toLowerCase(),
        password: password,
      );

      // After successful login, navigate to the OnboardingScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
      CustomSnackBar.showCustomSnackBar(context, "Loged in Successfully..");
    } on FirebaseAuthException catch (e) {
      print('Error Code: ${e.code}');
      print('Error Message: ${e.message}');

      setState(() {
        isLoading = false; // Set loading state to false after login attempt
      });
      if (e.code == 'user-not-found') {
        CustomSnackBar.showCustomSnackBar(
            context, "No user found for that email..");
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        CustomSnackBar.showCustomSnackBar(context, "Wrong Password..");
        print('Wrong password provided.');
      } else {
        CustomSnackBar.showCustomSnackBar(context, "Error: ${e.message}");
        print('Error: ${e.message}');
      }
    } finally {
      setState(() {
        isLoading = false; // Set loading state to false after login attempt
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: blueColor,
        title: Text(
          "Login Page",
          style: TextStyle(color: whiteColor),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.email,
                            color: blueColor,
                          ),
                          labelStyle: TextStyle(color: blueColor),
                          iconColor: blueColor,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16)),
                          //icon: Icon(Icons.email),
                          labelText: "Email",
                        ),
                      ),
                      const SizedBox(height: 10),
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
                          //icon: Icon(Icons.lock),
                          labelText: "Password",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: () {
                  login();
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    color: blueColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Wrap(
                children: [
                  const Text("Don't have an account ? "),
                  GestureDetector(
                    child: Text(
                      "Register",
                      style: TextStyle(color: darkblueColor),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const RegisterView(),
                        ),
                      );
                    },
                  )
                ],
              ),
            ],
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
