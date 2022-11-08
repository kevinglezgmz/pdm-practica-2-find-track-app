import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica_2_kevin_gonzalez/blocs/auth_bloc/auth_bloc.dart';

class SignupPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Regístrate"),
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                label: Text("Nombre de usuario"),
              ),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                label: Text("Correo"),
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                label: Text("Contraseña"),
              ),
              obscureText: true,
            ),
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthLoggedInState) {
                  Navigator.of(context).pop();
                } else if (state is AuthNotLoggedInState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Error al registrar usuario",
                      ),
                    ),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 15.0),
                child: ElevatedButton(
                  child: const Text("Crear cuenta"),
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          AuthEmailSignupEvent(
                            email: _emailController.text.trim(),
                            username: _usernameController.text.trim(),
                            password: _passwordController.text,
                          ),
                        );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
