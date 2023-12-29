import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Routes/authentification.dart';
import 'package:flutter_application_1/State_manager/user_manager.dart';
import 'package:flutter_application_1/Views/register.page.dart';
import 'package:flutter_application_1/main.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    unawaited(
      SystemChrome.setPreferredOrientations(<DeviceOrientation>[
        DeviceOrientation.portraitUp,
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute<RegisterPage>(
                  builder: (BuildContext context) => const RegisterPage(),
                ),
              );
            },
            child: Text(
              'Register',
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Text(
                'Geo Cache App',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    floatingLabelAlignment: FloatingLabelAlignment.center,
                    icon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                    labelText: 'Email or Username',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  onSubmitted: (String value) {
                    FocusScope.of(context).unfocus();
                  },
                  decoration: const InputDecoration(
                    icon: Icon(Icons.lock),
                    floatingLabelAlignment: FloatingLabelAlignment.center,
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
                onPressed: () async {
                  final User? user =
                      await AuthenticationService().signInWithEmailAndPassword(
                    _emailController.text,
                    _passwordController.text,
                  );
                  debugPrint(user.toString());
                  if (user == null) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Email or password is incorrect'),
                        ),
                      );
                    }
                  } else {
                    if (context.mounted) {
                      context.read<UserModel>().setUser(user);
                      await Navigator.of(context).pushReplacement(
                        MaterialPageRoute<MyHomePage>(
                          builder: (BuildContext context) => const MyHomePage(),
                        ),
                      );
                    }
                  }
                },
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
