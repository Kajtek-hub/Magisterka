import 'package:flutter/material.dart';
import 'package:magisterka/custom_widgets/custom_button.dart';
import 'package:magisterka/theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:magisterka/api/api_client.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen(this.onRegister, {super.key});
  final void Function() onRegister;

  @override
  State<StatefulWidget> createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _ageController = TextEditingController();
  String? _selectedSex;

  Future<bool> _registerUser() async {

    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("UserName cannot be empty")),
      );
      return false;
    }

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password cannot be empty")),
      );
      return false;
    }

    if (username.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("UserName too short")),
      );
      return false;
    }

    if (_selectedSex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Choose your gender")),
      );
      return false;
    }

    final age = int.tryParse(_ageController.text);
    if (age == null || age <= 0 || age > 150) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter the correct age")),
      );
      return false;
    }

    if (confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Confirm password cannot be empty")),
      );
      return false;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return false;
    }

    try {
      await ApiClient.post("/auth/register", {
        "userName": _usernameController.text,
        "password": _passwordController.text,
        "age": age,
        "sex": _selectedSex,
      });
      return true;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration error: $e")),
        );
      }
      return false;
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _ageController.dispose();
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
          child: SingleChildScrollView(
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
                    'Register',
                    style: GoogleFonts.lato(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme_Colors.primary,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: "User Name"),
                    validator: (v) =>
                        v == null || v.isEmpty ? "Required field" : null,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _ageController,
                          decoration: const InputDecoration(labelText: "Age"),
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            final n = int.tryParse(v ?? '');
                            if (n == null || n <= 0) return "Enter your age";
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(labelText: 'Sex'),
                          items: const [
                            DropdownMenuItem(value: "male",   child: Text("Male")),
                            DropdownMenuItem(value: "female", child: Text("Female")),
                            DropdownMenuItem(value: "other",  child: Text("Other")),
                          ],
                          onChanged: (value) {
                            _selectedSex = value;
                          },
                          validator: (v) =>
                              v == null ? "Select your gender" : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: "Password"),
                    obscureText: true,
                    validator: (v) {
                      if (v == null || v.length < 6) {
                        return "Password must be at least 6 characters long";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration:
                        const InputDecoration(labelText: "Confirm Password"),
                    obscureText: true,
                    validator: (v) {
                      if (v != _passwordController.text) {
                        return "The passwords are not identical";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final ok = await _registerUser();
                      if (ok && mounted) {
                        Navigator.pushNamed(context, '/menu-screen');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme_Colors.buttonBackgroundColor,
                      foregroundColor: Theme_Colors.foreBackgroundColor,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Register account"),
                  ),
                  const SizedBox(height: 20),
                  CustomButton('/login-screen', "Have an account? Log in"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}