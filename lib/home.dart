import 'package:firebase_ui_auth/firebase_ui_auth.dart' hide AuthProvider;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

List card = [];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<void> _dataFuture;

  Future<void> _activateListeners() async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref("Card");
      DatabaseEvent event = await ref.once();

      if (event.snapshot.exists) {
        final map = event.snapshot.value as Map<dynamic, dynamic>;
        print(map);

        for (var cardName in map['Name'].keys) {
          var cardData = {
            'ID': map['ID'][cardName],
            'Name': map['Name'][cardName],
            'Value': map['Value'][cardName],
            'Image': map['Image'][cardName],
            'Game': map['Game'][cardName],
          };

          card.add({cardName: cardData});
        }
      } else {
        print("No data found at the 'Card' reference.");
      }
    } catch (e) {
      print("Error fetching data from Firebase: $e");
    }

    print(card);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _dataFuture = _activateListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.black,
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "Welcome to Card Trader!",
          style: TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<ProfileScreen>(
                  builder: (context) => ProfileScreen(
                    appBar: AppBar(
                      shadowColor: Colors.black,
                      backgroundColor: Colors.deepPurple,
                      title: const Text('User Profile'),
                    ),
                    actions: [
                      SignedOutAction((context) {
                        Navigator.of(context).pop();
                      })
                    ],
                  ),
                ),
              );
            },
          )
        ],
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: card.length,
                itemBuilder: (context, index) {
                  var cardData = card[index].values.first;

                  return Card(
                    shadowColor: Colors.black,
                    color: Colors.purple.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    borderOnForeground: true,
                    elevation: 5,
                    margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.network(
                              cardData['Image'],
                              width: 150,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cardData['Name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 32,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text("Game: ${cardData['Game']}",
                                    style: const TextStyle(
                                      fontSize: 20,
                                    )),
                                Text("ID: ${cardData['ID']}",
                                    style: const TextStyle(
                                      fontSize: 20,
                                    )),
                                Text("Value: ${cardData['Value']}",
                                    style: const TextStyle(
                                      fontSize: 20,
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
