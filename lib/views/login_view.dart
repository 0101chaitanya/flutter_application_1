import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
          title: const Text("Login"),
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
                  .signInWithEmailAndPassword(email: email, password: password);
              print(userCredential);
            } on FirebaseAuthException catch (e) {
              print(e.code);

              if (e.code == "user-not-found") {
                print("user not found");
              } else if (e.code == "wrong-password") {
                print("wrong password");
              } else {
                print("SOMETHING ELSE HAPPENED");
                print(e.code);
              }
            } catch (e) {
              print("foul");
            }
          },
          child: const Text("Login"),
        ),
      ],
    );
  }
}
