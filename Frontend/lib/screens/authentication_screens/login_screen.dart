import 'package:flutter/material.dart';
import 'package:magisterka/custom_widgets/custom_button.dart';
import 'package:magisterka/theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:magisterka/api/api_client.dart';
import 'package:magisterka/api/secure_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen(this.onLog, {super.key});
  final void Function() onLog;

  @override
  State<StatefulWidget> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    if (_usernameController.text.trim().isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fill in all fields")),
      );
        return;
      }

    try {
      final res = await ApiClient.post("/auth/login", {
        "userName": _usernameController.text,
        "password": _passwordController.text,
      });

      final token = res["token"];

      if (token != null) {
        await SecureStorage.saveToken(token);
        if (mounted) Navigator.pushNamed(context, '/menu-screen');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login error: $e")),
        );
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Theme_Colors.background1, Theme_Colors.background2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.white, Color.fromARGB(255, 216, 210, 210)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Login',
                  style: GoogleFonts.lato(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme_Colors.primary,
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: "UserName",
                    hintStyle: TextStyle(color: Theme_Colors.primary),
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: TextStyle(color: Theme_Colors.primary),
                  ),
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _login,
                  
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme_Colors.buttonBackgroundColor,
                      foregroundColor: Theme_Colors.foreBackgroundColor,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Login"),
                ),
                
                const SizedBox(height: 20),
                CustomButton('/register-screen', "Create an account"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}