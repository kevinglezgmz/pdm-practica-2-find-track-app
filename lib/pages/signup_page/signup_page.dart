import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica_2_kevin_gonzalez/blocs/auth_bloc/auth_bloc.dart';
import 'package:practica_2_kevin_gonzalez/components/password_input.dart';

class SignupPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      resizeToAvoidBottomInset: true,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/space.gif"),
            opacity: 0.3,
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 180),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Registra una cuenta",
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      label: Text("Nombre de usuario"),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      label: Text("Correo"),
                    ),
                  ),
                  const SizedBox(height: 24),
                  PasswordInput(controller: _passwordController),
                  const SizedBox(height: 32),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
