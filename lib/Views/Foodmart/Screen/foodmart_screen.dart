import 'package:firebase/colors.dart';
import 'package:flutter/material.dart';

class FoodMartScreen extends StatefulWidget {
  const FoodMartScreen({super.key});

  @override
  State<FoodMartScreen> createState() => _FoodMartScreenState();
}

class _FoodMartScreenState extends State<FoodMartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Food Mart",
          style: TextStyle(color: whiteColor),
        ),
        centerTitle: true,
        backgroundColor: blueColor,
      ),
      body: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container();
        },
      ),
    );
  }
}
