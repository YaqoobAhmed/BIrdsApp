import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Views/Foodmart/Tabs/Buy/food_product_view.dart';
import 'package:flutter/material.dart';

class FoodBuyScreen extends StatelessWidget {
  Stream<QuerySnapshot> fetchData() async* {
    int retries = 0;
    const maxRetries = 5;
    const baseDelay = Duration(seconds: 1);

    while (true) {
      try {
        yield* FirebaseFirestore.instance.collection("FoodAdds").snapshots();
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
      body: StreamBuilder<QuerySnapshot>(
        stream: fetchData(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
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
                      builder: (context) => FoodProductView(
                        image: postMap["foodPic"],
                        name: postMap["name"],
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
                                image: NetworkImage(postMap["foodPic"]),
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
                              title: Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                children: [
                                  Text(postMap["name"]),
                                  Text("\$ ${postMap["price"]}"),
                                ],
                              ),
                              // subtitle: Text(postMap["breed"]),
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
