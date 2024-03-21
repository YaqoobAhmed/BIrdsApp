import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Views/product_view/Screen/product_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase/Views/My_Ads/Edit_screens/edit_ads.dart'; // Import your edit screen
import 'package:firebase/colors.dart';

class MyAds extends StatelessWidget {
  final String currentUserUid;

  const MyAds({Key? key, required this.currentUserUid}) : super(key: key);

  Stream<QuerySnapshot> fetchData() async* {
    yield* FirebaseFirestore.instance
        .collection("adds")
        .where("uid", isEqualTo: currentUserUid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Ads"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fetchData(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No ads available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final postMap =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                final imageUrl = postMap['birdPic'] ?? '';
                final name = postMap['name'] ?? 'Name not available';
                final breed = postMap['breed'] ?? 'Breed not available';
                final price = postMap['price'] ?? 'Price not available';

                void deleteAd() async {
                  Center(
                    child: CircularProgressIndicator(),
                  );
                  await FirebaseFirestore.instance
                      .collection("adds")
                      .doc(snapshot.data!.docs[index].id)
                      .delete();
                }

                void editAd() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditAdScreen(
                        adId: snapshot.data!.docs[index].id,
                        initialData: postMap,
                      ),
                    ),
                  );
                }

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
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (imageUrl.isNotEmpty)
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.contain,
                              ),
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(15),
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                breed,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "\$$price",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: blueColor,
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: editAd,
                                    child: Text(
                                      'Edit',
                                      style: TextStyle(
                                          fontSize: 16, color: whiteColor),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: blueColor,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: deleteAd,
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(
                                          fontSize: 16, color: whiteColor),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red.shade500,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
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
