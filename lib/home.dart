import 'package:firebase_ui_auth/firebase_ui_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<ProfileScreen>(
                  builder: (context) => ProfileScreen(
                    appBar: AppBar(
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
                  itemCount: 35,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.purple.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      borderOnForeground: true,
                      elevation: 5,
                      margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: const ListTile(
                        leading: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            child: Text("Sample")),
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
