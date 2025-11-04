import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../uivalue/ui_layout.dart';
import '../uivalue/ui_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Firebase App")),
      body: Container(
        padding: EdgeInsets.all(UILayout.mediumGap),
        child: Center(
          child: Form(
            key: _key,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                emailInput(),
                SizedBox(height: UILayout.mediumGap),
                passwordInput(),
                SizedBox(height: UILayout.mediumGap),
                loginButton(),
                SizedBox(height: UILayout.mediumGap),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/signup'),
                  child: const Text("Sign Up"),
                ),
                temporaryLoginButton(),
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
        labelStyle: UIText.labelStyle(context),
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
        labelStyle: UIText.labelStyle(context),
      ),
    );
  }

  ElevatedButton loginButton() {
    return ElevatedButton(
      onPressed: () async {
        if (_key.currentState!.validate()) {
          try {
            await AuthService.signInWithEmailPassword(
              email: _emailController.text,
              password: _pwdController.text,
            );
            if (mounted) {
              Navigator.pushNamed(context, "/");
            }
          } on FirebaseAuthException catch (e) {
            String message = 'An error occurred';
            if (e.code == 'user-not-found') {
              message = 'No user found for that email.';
            } else if (e.code == 'wrong-password') {
              message = 'Wrong password provided for that user.';
            }
            if (mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(message)));
            }
          }
        }
      },
      child: Container(
        padding: EdgeInsets.all(UILayout.mediumGap),
        child: Text(
          "Login",
          style: TextStyle(fontSize: UIText.mediumFontSize),
        ),
      ),
    );
  }

  ElevatedButton temporaryLoginButton() {
    return ElevatedButton(
      onPressed: () async {
        try {
          await AuthService.signInAnonymously();
          if (mounted) {
            Navigator.pushNamed(context, "/");
          }
        } on FirebaseAuthException catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
          }
        }
      },
      child: Container(
        padding: EdgeInsets.all(UILayout.mediumGap),
        child: Text(
          "temporary login",
          style: TextStyle(fontSize: UIText.mediumFontSize),
        ),
      ),
    );
  }
}
