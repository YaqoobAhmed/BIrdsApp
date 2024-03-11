import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/colors.dart';
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
    try {
      String newTitle = _titleController.text;
      String newDescription = _descriptionController.text;

      // Update the article in Firestore using the docId
      await FirebaseFirestore.instance
          .collection("articlePosts")
          .doc(widget.docId)
          .update({
        "title": newTitle,
        "description": newDescription,
      });

      // Navigate back to the previous screen after successful update
      Navigator.pop(context);
    } catch (error) {
      // Handle error
      print("Error updating article: $error");
    }
  }
}
