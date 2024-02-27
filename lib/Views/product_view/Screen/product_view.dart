import 'package:firebase/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class ProductView extends StatefulWidget {
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
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  void launchWhatsapp({required String number, required String message}) async {
    String url = "whatsapp://send?phone=$number&text=$message";
    String defaultSmsUrl = "sms:$number?body=$message";

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      print("WhatsApp not available, opening default messaging app...");
      await launchUrl(Uri.parse(defaultSmsUrl));
    }
  }

  void launchDialer({
    required String number,
  }) async {
    String url = "tel:$number";

    await launchUrl(Uri.parse(url));
  }

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
                          image: NetworkImage(widget.image), fit: BoxFit.fill),
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
                          widget.name,
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
                                    text: widget.breed,
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
                                    text: widget.age.toString(),
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
                                    text: widget.description,
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
                                    text: widget.address,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal))
                              ]),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Price: \$${widget.price.toString()}",
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                launchDialer(number: widget.contact);
                              },
                              child: Container(
                                height: 40,
                                width: 135,
                                decoration: BoxDecoration(
                                    color: blueColor,
                                    borderRadius: BorderRadius.circular(16)),
                                child: Center(
                                    child: Wrap(children: [
                                  Icon(
                                    Icons.call,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    widget.contact,
                                    style: TextStyle(
                                        color: whiteColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ])),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                launchWhatsapp(
                                    number: widget.contact,
                                    message:
                                        "Hello, I want to talk about your ad '${widget.name}' on Avian Tech Emporium");
                              },
                              child: Container(
                                height: 40,
                                width: 135,
                                decoration: BoxDecoration(
                                    color: Colors.green[500],
                                    borderRadius: BorderRadius.circular(16)),
                                child: Center(
                                    child: Wrap(children: [
                                  FaIcon(
                                    FontAwesomeIcons.whatsapp,
                                    size: 20,
                                    color: whiteColor,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    widget.contact,
                                    style: TextStyle(
                                        color: whiteColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ])),
                              ),
                            ),
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
