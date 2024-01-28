import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Views/Onboarding/Screen/onboarding.dart';
import 'package:firebase/Views/product_view/Screen/product_view.dart';
import 'package:firebase/colors.dart';
import 'package:flutter/material.dart';

class BuyScreen extends StatelessWidget {
  Stream<QuerySnapshot> fetchData() async* {
    int retries = 0;
    const maxRetries = 5;
    const baseDelay = Duration(seconds: 1);

    while (true) {
      try {
        yield* FirebaseFirestore.instance.collection("adds").snapshots();
        return;
      } catch (e) {
        if (retries >= maxRetries) {
          throw Exception("Failed after $maxRetries retries: $e");
        }
        final delay = baseDelay * (retries + 1);
        await Future.delayed(delay);
        retries++;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => OnboardingScreen(),
              ),
            );
          },
          icon: Icon(
            Icons.arrow_back,
            color: whiteColor,
          ),
        ),
        backgroundColor: blueColor,
        title: Text(
          "Buy Birds",
          style: TextStyle(color: whiteColor),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              color: Colors.white,
              size: 30,
            ),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fetchData(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            return GridView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                Map<String, dynamic> postMap =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;

                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductView(
                        image: postMap["birdPic"],
                        name: postMap["name"],
                        breed: postMap["breed"],
                        age: postMap["age"],
                        description: postMap["discription"],
                        address: postMap["address"],
                        price: postMap["price"],
                        contact: postMap["contact"],
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      height: 194,
                      width: MediaQuery.of(context).size.height * 0.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          const BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 0.5,
                            blurRadius: 5,
                            offset: Offset(-2, 3),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.12,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(postMap["birdPic"]),
                                fit: BoxFit.fill,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 65,
                            child: ListTile(
                              title: Text(
                                postMap["name"],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              subtitle: Wrap(
                                  alignment: WrapAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: Text(
                                        postMap["breed"],
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                    Text(
                                      "\$${postMap["price"]}",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: blueColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
