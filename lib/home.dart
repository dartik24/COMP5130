import 'package:firebase_ui_auth/firebase_ui_auth.dart' hide AuthProvider;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

List card = [];
List filtered = [];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<void> _dataFuture;
  final DatabaseReference ref = FirebaseDatabase.instance.ref("Card");
  final TextEditingController searchController = TextEditingController();

  Future<void> activateListeners() async {
    try {
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
    filtered = List.from(card);
    setState(() {});
  }

  void filter(String input) {
    if (input.isEmpty) {
      setState(() {
        filtered = List.from(card);
      });
    } else {
      setState(() {
        filtered = card.where((element) {
          var CardData = element.values.first;
          return CardData["Name"]
                  .toString()
                  .toLowerCase()
                  .contains(input.toLowerCase()) ||
              CardData["Game"]
                  .toString()
                  .toLowerCase()
                  .contains(input.toLowerCase()) ||
              CardData["ID"]
                  .toString()
                  .toLowerCase()
                  .contains(input.toLowerCase());
        }).toList();
      });
    }
  }

  Future<void> add(
      String id, String name, String value, String image, String game) async {
    try {
      await ref.update({
        "ID/$name": id,
        "Name/$name": name,
        "Value/$name": value,
        "Image/$name": image,
        "Game/$name": game,
      });

      print("Card added successfully");
      setState(() {
        card.add({
          name: {
            'ID': id,
            'Name': name,
            'Value': value,
            'Image': image,
            'Game': game,
          }
        });
      });
    } catch (e) {
      print("Error adding card to Firebase: $e");
    }
  }

  void CardForm(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController idController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController valueController = TextEditingController();
    final TextEditingController imageController = TextEditingController();
    final TextEditingController gameController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: idController,
                    decoration:
                        const InputDecoration(labelText: 'Card Owner Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                      if (!emailRegex.hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Card Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a card name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: valueController,
                    decoration: const InputDecoration(labelText: 'Card Value'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a value';
                      }
                      final intValue = int.tryParse(value);
                      if (intValue == null || intValue < 0 || intValue > 10) {
                        return 'Value must be between 0 and 10';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: imageController,
                    decoration:
                        const InputDecoration(labelText: 'Card Image URL'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an image URL';
                      }
                      final urlRegex =
                          RegExp(r'^(https?|ftp):\/\/[^\s/$.?#].[^\s]*$');
                      if (!urlRegex.hasMatch(value)) {
                        return 'Please enter a valid URL';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: gameController,
                    decoration: const InputDecoration(labelText: 'Card Game'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a game name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        add(
                          idController.text,
                          nameController.text,
                          valueController.text,
                          imageController.text,
                          gameController.text,
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Add Card'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _dataFuture = activateListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.black,
        backgroundColor: Colors.deepPurple,
        title: Row(
          children: [
            const Text(
              "Welcome to Card Trader!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              width: 16,
            ),
            Flexible(
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Input Card/Game/Seller Name...",
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 16.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: (value) {
                  filter(value);
                },
              ),
            ),
          ],
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
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  var cardData = filtered[index].values.first;

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
                                Text("Owner: ${cardData['ID']}",
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => CardForm(context),
        child: const Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
