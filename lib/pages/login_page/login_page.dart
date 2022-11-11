import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica_2_kevin_gonzalez/blocs/auth_bloc/auth_bloc.dart';
import 'package:practica_2_kevin_gonzalez/components/password_input.dart';
import 'package:practica_2_kevin_gonzalez/pages/signup_page/signup_page.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 48),
                  const Text(
                    "Iniciar sesión",
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      label: Text("Correo"),
                    ),
                  ),
                  const SizedBox(height: 12),
                  PasswordInput(controller: _passwordController),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    child: const Text("Iniciar Sesión"),
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthEmailLoginEvent(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                          ));
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: Divider(
                          thickness: 1,
                          indent: MediaQuery.of(context).size.width / 20,
                          endIndent: MediaQuery.of(context).size.width / 20,
                        ),
                      ),
                      const Text("O"),
                      Flexible(
                        child: Divider(
                          thickness: 1,
                          indent: MediaQuery.of(context).size.width / 20,
                          endIndent: MediaQuery.of(context).size.width / 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthGoogleLoginEvent());
                    },
                    icon: const FaIcon(
                      FontAwesomeIcons.google,
                    ),
                    label: const Text("Iniciar sesión con Google"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                        0xFF,
                        0xDC,
                        0x4E,
                        0x41,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("¿No tienes una cuenta? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupPage()),
                          );
                        },
                        child: const Text(
                          "Crear una cuenta",
                          style: TextStyle(color: Colors.blue),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
