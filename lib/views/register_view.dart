import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Building");
    return Scaffold(
        appBar: AppBar(
          title: const Text("Register"),
        ),
        body: FutureBuilder(
            future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform,
            ),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  {
                    return RegisterColumnWidget(
                        email: _email, password: _password);
                  }
                default:
                  return const Text("Loading...");
              }
            }));
  }
}

class RegisterColumnWidget extends StatelessWidget {
  const RegisterColumnWidget({
    super.key,
    required TextEditingController email,
    required TextEditingController password,
  })  : _email = email,
        _password = password;

  final TextEditingController _email;
  final TextEditingController _password;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          enableSuggestions: false,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          decoration: const InputDecoration(hintText: "Enter your email here"),
          controller: _email,
        ),
        TextField(
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          controller: _password,
          decoration:
              const InputDecoration(hintText: "Enter your password here"),
        ),
        TextButton(
          onPressed: () async {
            final email = _email.text;
            final password = _password.text;
            try {
              final userCredential = await FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                      email: email, password: password);
              print(userCredential);
            } on FirebaseAuthException catch (e) {
              if (e.code == "weak-password") {
                print("weak password");
              } else if (e.code == "email-already-in-use") {
                print("email already in use");
              } else if (e.code == "invalid-email") {
                print("invalid email");
              } else {
                print(e.code);
              }
            }
          },
          child: const Text("Register"),
        ),
      ],
    );
  }
}