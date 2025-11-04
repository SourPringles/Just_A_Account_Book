import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../uivalue.dart';

class LinkPage extends StatefulWidget {
  const LinkPage({super.key});

  @override
  State<LinkPage> createState() => _LinkPageState();
}

class _LinkPageState extends State<LinkPage> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Firebase App")),
      body: Container(
        padding: EdgeInsets.all(UIValue.mediumGap),
        child: Center(
          child: Form(
            key: _key,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                emailInput(),
                SizedBox(height: UIValue.mediumGap),
                passwordInput(),
                SizedBox(height: UIValue.mediumGap),
                submitButton(),
                SizedBox(height: UIValue.mediumGap),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField emailInput() {
    return TextFormField(
      controller: _emailController,
      autofocus: true,
      validator: (val) {
        if (val!.isEmpty) {
          return 'The input is empty.';
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Input your email address.',
        labelText: 'Email Address',
        labelStyle: UIValue.labelStyle(context),
      ),
    );
  }

  TextFormField passwordInput() {
    return TextFormField(
      controller: _pwdController,
      obscureText: true,
      autofocus: true,
      validator: (val) {
        if (val!.isEmpty) {
          return 'The input is empty.';
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Input your password.',
        labelText: 'Password',
        labelStyle: UIValue.labelStyle(context),
      ),
    );
  }

  ElevatedButton submitButton() {
    return ElevatedButton(
      onPressed: () async {
        if (_key.currentState!.validate()) {
          // 여기에 작성
          try {
            final credential = EmailAuthProvider.credential(
              email: _emailController.text,
              password: _pwdController.text,
            );
            await FirebaseAuth.instance.currentUser?.linkWithCredential(
              credential,
            );
            if (!mounted) return;
            Navigator.pushNamed(context, "/");
          } on FirebaseAuthException catch (e) {
            if (e.code == 'weak-password') {
              debugPrint('The password provided is too weak.');
            } else if (e.code == 'email-already-in-use') {
              debugPrint('The account already exists for that email.');
            } else if (e.code == 'provider-already-linked') {
              debugPrint('The provider has already been linked to the user.');
            } else if (e.code == 'invalid-credential') {
              debugPrint('The provider\'s credential is not valid.');
            }
          } catch (e) {
            debugPrint(e.toString());
          }
        }
      },
      child: Container(
        padding: EdgeInsets.all(UIValue.mediumGap),
        child: Text(
          "Sign Up",
          style: TextStyle(fontSize: UIValue.mediumFontSize),
        ),
      ),
    );
  }
}
