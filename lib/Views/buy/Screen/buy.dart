import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Views/product_view/Screen/product_view.dart';
import 'package:firebase/colors.dart';
import 'package:flutter/material.dart';

class BuyScreen extends StatefulWidget {
  const BuyScreen({super.key});

  @override
  BuyScreenState createState() => BuyScreenState();
}

class BuyScreenState extends State<BuyScreen> {
  TextEditingController searchController = TextEditingController();
  bool _isSearching = false;

  Stream<QuerySnapshot> fetchData(String query) async* {
    int retries = 0;
    const maxRetries = 5;
    const baseDelay = Duration(seconds: 1);

    while (true) {
      try {
        yield* FirebaseFirestore.instance
            .collection("birdAds")
            .where("name", isGreaterThanOrEqualTo: query.toUpperCase())
            .where("name", isLessThan: '${query.toUpperCase()}z')
            .snapshots();
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

  Widget _buildSearchField() {
    return TextFormField(
      controller: searchController,
      style: TextStyle(color: whiteColor),
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Search Birds...',
        border: InputBorder.none,
      ),
      onChanged: (query) {
        setState(() {
          fetchData(query);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching ? _buildSearchField() : Text('Buy Birds'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.cancel : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  searchController.clear();
                }
              });
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fetchData(searchController.text),
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
                        description: postMap["description"],
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
                        boxShadow: const [
                          BoxShadow(
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
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: Text(
                                        postMap["breed"],
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                    Text(
                                      "Rs.${postMap["price"]}",
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
