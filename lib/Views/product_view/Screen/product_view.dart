import 'package:firebase/colors.dart';
import 'package:flutter/material.dart';

class ProductView extends StatelessWidget {
  ProductView(
      {super.key,
      required this.image,
      required this.name,
      required this.breed,
      required this.age,
      required this.description,
      required this.address,
      required this.price,
      required this.contact});
  final String image;
  final String name;
  final String breed;
  var age;
  final String description;
  final String address;
  var price;
  final String contact;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 60),
                  child: Container(
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      boxShadow: [
                        BoxShadow(
                            color: blueColor,
                            spreadRadius: 2,
                            blurRadius: 22,
                            offset: const Offset(-4, 4))
                      ],
                      image: DecorationImage(
                          image: NetworkImage(image), fit: BoxFit.fill),
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 14,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: iconColor,
                      child: const Icon(
                        Icons.close,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                  ),
                )
              ]),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(color: iconColor, boxShadow: [
                    BoxShadow(
                        spreadRadius: 0.1, blurRadius: 10, color: blueColor)
                  ]),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 26),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        RichText(
                          text: TextSpan(
                              text: "Breed: ",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Colors.black),
                              children: [
                                TextSpan(
                                    text: breed,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal))
                              ]),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        RichText(
                          text: TextSpan(
                              text: "Age: ",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Colors.black),
                              children: [
                                TextSpan(
                                    text: age.toString(),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal))
                              ]),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        RichText(
                          text: TextSpan(
                              text: "Description: ",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Colors.black),
                              children: [
                                TextSpan(
                                    text: description,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal))
                              ]),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        RichText(
                          text: TextSpan(
                              text: "Address: ",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Colors.black),
                              children: [
                                TextSpan(
                                    text: address,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal))
                              ]),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Price: \$${price.toString()}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 20),
                            ),
                            Container(
                              height: 40,
                              width: 120,
                              decoration: BoxDecoration(
                                  color: blueColor,
                                  borderRadius: BorderRadius.circular(16)),
                              child: Center(
                                  child: Text(
                                contact,
                                style: TextStyle(
                                    color: whiteColor,
                                    fontWeight: FontWeight.bold),
                              )),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              )
            ],
          ),
        ),
      ),
    );
  }
}
