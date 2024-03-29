import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/SnackBar/snackBar.dart';
import 'package:firebase/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditArticleScreen extends StatefulWidget {
  final String docId;
  final String title;
  final String description;

  const EditArticleScreen({
    Key? key,
    required this.docId,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  _EditArticleScreenState createState() => _EditArticleScreenState();
}

class _EditArticleScreenState extends State<EditArticleScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _descriptionController = TextEditingController(text: widget.description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Article"),
      ),
      body: Center(
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  TextFormField(
                    textCapitalization: TextCapitalization.words,
                    controller: _titleController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                      labelStyle: TextStyle(color: blueColor),
                      labelText: "Title:",
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 15,
                    controller: _descriptionController,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                      labelStyle: TextStyle(color: blueColor),
                      labelText: "Description:",
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  GestureDetector(
                    onTap: updateArticle,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                          color: blueColor,
                          borderRadius: BorderRadius.circular(16)),
                      child: Center(
                        child: Text(
                          "Update Article",
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
          ),
        ),
      ),
    );
  }

  void updateArticle() async {
    String newTitle = _titleController.text.trim();
    String newDescription = _descriptionController.text.trim();

    // Update the article in Firestore using the docId

    if (newTitle.isEmpty || newDescription.isEmpty) {
      CustomSnackBar.showCustomSnackBar(context, "Please fill in all fields");
      print("Please fill all fields");
      return;
    } else {
      try {
        // Store user info
        Center(
          child: CircularProgressIndicator(),
        );
        await FirebaseFirestore.instance
            .collection("article")
            .doc(widget.docId)
            .update({
          "title": newTitle,
          "description": newDescription,
        });

        CustomSnackBar.showCustomSnackBar(context, "Article Updated!.");
      } on FirebaseAuthException catch (ex) {
        CustomSnackBar.showCustomSnackBar(
            context, "Error: ${ex.code.toString()}");
      } finally {
        Navigator.pop(context);
      }
    }
  }

  // Navigate back to the previous screen after successful update
}
