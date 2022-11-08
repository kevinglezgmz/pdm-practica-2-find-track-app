import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica_2_kevin_gonzalez/blocs/auth_bloc/auth_bloc.dart';
import 'package:practica_2_kevin_gonzalez/pages/signup_page/signup_page.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tuks Divide')),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _addWidgetWithPadding(
              35.0,
              8.0,
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  label: Text("Email"),
                ),
              ),
            ),
            _addWidgetWithPadding(
              8.0,
              8.0,
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  label: Text("Password"),
                ),
                obscureText: true,
              ),
            ),
            _addWidgetWithPadding(
                18.0,
                30.0,
                ElevatedButton(
                  child: const Text("Iniciar Sesión"),
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthEmailLoginEvent(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                        ));
                  },
                )),
            _addWidgetWithPadding(
              8.0,
              30.0,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _createDivider(context),
                  const Text("O"),
                  _createDivider(context)
                ],
              ),
            ),
            _addWidgetWithPadding(
              8.0,
              8.0,
              ElevatedButton.icon(
                onPressed: () {
                  context.read<AuthBloc>().add(AuthGoogleLoginEvent());
                },
                icon: const FaIcon(
                  FontAwesomeIcons.google,
                ),
                label: const Text("Iniciar sesión con Google"),
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color.fromARGB(0xFF, 0xDC, 0x4E, 0x41)),
              ),
            ),
            _addWidgetWithPadding(
              50.0,
              15.0,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("¿No tienes una cuenta? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupPage()),
                      );
                    },
                    child: const Text(
                      "Crear una cuenta",
                      style: TextStyle(color: Colors.blue),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding _addWidgetWithPadding(double top, double bottom, Widget widget) {
    return Padding(
        padding: EdgeInsets.fromLTRB(15.0, top, 15.0, bottom), child: widget);
  }

  Flexible _createDivider(BuildContext context) {
    return Flexible(
      child: Divider(
        thickness: 1,
        indent: MediaQuery.of(context).size.width / 20,
        endIndent: MediaQuery.of(context).size.width / 20,
      ),
    );
  }
}
