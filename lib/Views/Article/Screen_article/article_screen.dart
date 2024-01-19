import 'package:firebase/colors.dart';
import 'package:flutter/material.dart';

class ArticleScreen extends StatelessWidget {
  const ArticleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blueColor,
        title: Text(
          "Articles",
          style: TextStyle(color: whiteColor),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/articleimage.jpg'),
                          fit: BoxFit.cover)),
                ),
              ),
            ),
            Title(
                color: Colors.black,
                child: Text(
                  "What is a horned screamer?",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                )),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                  textAlign: TextAlign.center,
                  "Horned screamers are the unicorns of the bird world. Over the course of their lives, these birds grow long, white spines of cartilage in the middle of their foreheads. Some birds possess horns approaching six inches in length. No other birds on earth have anything like it.Unlike with rams and rhinos, the screamer’ \n\n s horn doesn’t seem to be a weapon, because it is only loosely attached to the skull and known to snap off once it grows too long. In time, broken horns even grow back. This leads scientists to believe the horns serve an ornamental purpose rather than a functional one.\n\n While the horns are harmless, the screamers are not. Each bird sports a pair of sharpened bone spurs on its wings. These are used to defend territory and battle with each other for mates. After particularly nasty encounters, scientists have even found pieces of spur broken off and lodged in other birds’ \n\n chest like shrapnel. Aside from their strange horns, these birds also possess some interesting anatomy below the surface. Inside their bones and skin are tons of tiny air sacs that reduce the weight of these large birds, which is thought to help them soar long distances without using muscle energy. These air sacs sometimes collapse simultaneously when the horned screamer takes off, creating a loud crackling noise. As its name suggests, this bird is also known for \n\n the loud calls it creates. The main one is described as sounding like, “mo-coo-ca,” leading some indigenous peoples to call the birds “mahooka.” This call sounds a bit like a goose, a close relative of horned screamers."),
            )
          ],
        ),
      ),
    );
  }
}
