import 'package:firebase/colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  File? scanPic;
  bool imageselected = false;

  @override
  void initState() {
    super.initState();
    _selectImageFromCamera();
  }
  //

  Future<void> _selectImageFromCamera() async {
    XFile? selectedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (selectedImage != null) {
      File convertedfile = File(selectedImage.path);
      setState(() {
        imageselected = true;
        scanPic = convertedfile;
      });
      print("Image selected");
    } else {
      print("Image is not selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/settings.jpg"),
                fit: BoxFit.fill)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  border: Border.all(),
                  color: Colors.grey.withOpacity(0.5),
                  image: scanPic != null
                      ? DecorationImage(
                          image: FileImage(scanPic!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                // Set a background color if no image is selected
                child: imageselected
                    ? null
                    : Icon(
                        Icons.add_photo_alternate,
                        color: blueColor,
                      ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _selectImageFromCamera(); // Retake button functionality
                },
                child: Text("Retake"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
