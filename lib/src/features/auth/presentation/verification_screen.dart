import 'dart:async';

import 'package:do_now/src/data/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await FirebaseAuth.instance.currentUser?.reload();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Bitte checke dein Postfach, um deine Email zu bestätigen.",
                style: Theme.of(context).textTheme.displayMedium,
              ),
              IconButton(
                onPressed: () async {
                  final auth = context.read<AuthRepository>();
                  await auth.signOut();
                },
                icon: Icon(Icons.exit_to_app),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
