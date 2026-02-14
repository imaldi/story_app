import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/auth_provider.dart';

import '../model/user.dart';

class RegisterScreen extends StatefulWidget {
  final Function() onRegister;
  final Function() onLogin;

  const RegisterScreen({
    Key? key,
    required this.onRegister,
    required this.onLogin,
  }) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final userNameController = TextEditingController();
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Screen"),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: userNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name.';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "User Name",
                  ),
                ),
                const SizedBox(height: 8),

                TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email.';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Email",
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Password",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                context.watch<AuthProvider>().isLoadingRegister
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final User user = User(
                        name: userNameController.text,
                        email: emailController.text,
                        password: passwordController.text,
                      );
                      final authRead = context.read<AuthProvider>();

                      final result = await authRead.register(user);
                      if (result) {
                        widget.onRegister();
                        Fluttertoast.showToast(
                            msg: "Success Register",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.greenAccent,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else {
                        Fluttertoast.showToast(
                            msg: "Failed Register (Email might have been taken)",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.greenAccent,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    }
                  },
                  child: const Text("REGISTER"),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () => widget.onLogin(),
                  child: const Text("LOGIN"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}