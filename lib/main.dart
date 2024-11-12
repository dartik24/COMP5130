import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import 'firebase_options.dart';

const clientId = 'YOUR_CLIENT_ID';

List card = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    //The below line needs to be enabled prior to Android application building
    // name: "COMP5130",
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}
