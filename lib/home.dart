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
        map.forEach((key, value) {
          value.forEach((k, v) {
            if (v is Map) {
              Map<String, dynamic> cardData = {
                'ID': value['ID'],
                'Name': value['Name'],
                'Value': value['Value'],
                'Image': value['Image'],
                'Game': value['Game'],
              };
              card.add(cardData);
            }
          });
        });
      } else {
        print("No data found at the 'Card' reference.");
      }
    } catch (e) {
      print("Error fetching data from Firebase: $e");
    }

    setState(() {}); // Update the UI when data is fetched
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
        title: const Text("Welcome to Card Trader!"),
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
                      child: ListTile(
                        leading: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            child: Text("${card[index]['Name']}")),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
