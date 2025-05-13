import 'package:do_now/src/features/auth/presentation/login_screen.dart';
import 'package:do_now/src/features/auth/presentation/widgets/social_login_button.dart';
import 'package:do_now/src/features/todo/presentation/home_screen.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 16,
            children: [
              Text(
                "Herzlich Willkommen!",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(
                height: 16,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "Email eingeben",
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Name",
                  hintText: "Name eingeben",
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                    icon: Icon(
                        _isObscured ? Icons.visibility : Icons.visibility_off),
                  ),
                  labelText: "Passwort",
                  hintText: "Passwort eingeben",
                  border: OutlineInputBorder(),
                ),
                obscureText: _isObscured,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Passwort wiederholen",
                  hintText: "Passwort nochmal eingeben",
                  border: OutlineInputBorder(),
                ),
                obscureText: _isObscured,
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text("Registrieren"),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                spacing: 16,
                children: [
                  Expanded(child: Divider()),
                  Text("oder"),
                  Expanded(child: Divider()),
                ],
              ),
              SizedBox(height: 16),
              Row(
                spacing: 16,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SocialLoginButton(icon: Icons.g_mobiledata),
                  SocialLoginButton(icon: Icons.apple),
                  SocialLoginButton(icon: Icons.facebook),
                ],
              ),
              Spacer(),
              Wrap(
                alignment: WrapAlignment.end,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                children: [
                  Text("Du hast bereits einen Account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text("Login"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
