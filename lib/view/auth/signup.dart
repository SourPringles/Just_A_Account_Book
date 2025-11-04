import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../uivalue.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
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
                nameInput(),
                SizedBox(height: UIValue.mediumGap),
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

  TextFormField nameInput() {
    return TextFormField(
      controller: _nameController,
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
        hintText: 'Input your name.',
        labelText: 'Name',
        labelStyle: UIValue.labelStyle(context),
      ),
    );
  }

  TextFormField emailInput() {
    return TextFormField(
      controller: _emailController,
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
          try {
            await AuthService.signUpWithEmailPassword(
              email: _emailController.text,
              password: _pwdController.text,
              name: _nameController.text,
            );
            if (mounted) {
              Navigator.pushNamed(context, "/");
            }
          } on FirebaseAuthException catch (e) {
            String message = 'An error occurred';
            if (e.code == 'weak-password') {
              message = 'The password provided is too weak.';
            } else if (e.code == 'email-already-in-use') {
              message = 'The account already exists for that email.';
            }
            if (mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(message)));
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
            }
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
