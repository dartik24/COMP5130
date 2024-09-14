import 'package:firebase_auth/firebase_auth.dart'
    hide AuthProvider, EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as firebase
    hide AuthProvider;
import 'package:flutter/material.dart';

import 'home.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return firebase.SignInScreen(
            providers: [
              firebase.EmailAuthProvider(),
            ],
            //signing guidance
            subtitleBuilder: (context, action) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: action == firebase.AuthAction.signIn
                    ? const Text('Welcome to COMP5310Demo, please sign in!')
                    : const Text('Welcome to COMP5310Demo, please sign up!'),
              );
            },
            //consent and notification
            footerBuilder: (context, action) {
              return const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  'By signing in, you agree to our terms and conditions.',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            },
          );
        }
        return const HomeScreen();
      },
    );
  }
}
