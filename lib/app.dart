import 'dart:convert';

import 'package:app_flutter/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppForm extends StatefulWidget {
  const AppForm({Key? key}) : super(key: key);

  @override
  _AppFormState createState() => _AppFormState();
}

class _AppFormState extends State<AppForm> {
  List _usuarios = [];

  String _nameuser = '';
  String _password = '';
  final TextEditingController _nameusercontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/usuarios.json');
    final data = await json.decode(response);
    setState(() {
      _usuarios = data["usuarios"] ?? [];
    });
  }

  void validateAndSubmit() {
    _nameuser = _nameusercontroller.text;
    _password = _passwordcontroller.text;

    if (_nameuser.isNotEmpty && _password.isNotEmpty) {
      final user = _usuarios.firstWhere(
        (u) => u['username'] == _nameuser && u['password'] == _password,
        orElse: () => null,
      );

      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Información'),
              content: const Text('Nombre de usuario o contraseña inválidos'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cerrar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Información'),
            content: const Text('Nombre de usuario o contraseña inválidos'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cerrar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    // Limpia los controladores cuando se desecha el Widget
    _nameusercontroller.dispose();
    _passwordcontroller.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    readJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 244, 244),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 90.0),
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100.0,
                height: 100.0,
                child: const CircleAvatar(
                  radius:
                      50.0, // Cambiar el valor del radio según tus necesidades
                  backgroundColor: Color.fromARGB(130, 255, 255, 255),
                  backgroundImage: AssetImage('images/logo.png'),
                ),
              ),
              const SizedBox(
                width: 256.0,
                height: 15.0,
              ),
              const Text(
                'Login',
                style: TextStyle(fontFamily: 'ui-sans-serif', fontSize: 35.0),
              ),
              SizedBox(
                width: 400.0,
                height: 45.0,
                child: Divider(
                  color: Colors.blueGrey[600],
                  thickness: 1.0,
                ),
              ),
              TextField(
                controller: _nameusercontroller,
                enableInteractiveSelection: false,
                autofocus: true,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  hintText: 'Usuario',
                  labelText: 'Nombre de Usuario',
                  suffixIcon: Icon(
                    Icons.verified_user,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7.0))),
                ),
                onSubmitted: (value) {
                  _nameuser = value;
                },
              ),
              const Divider(
                height: 18.0,
              ),
              TextField(
                controller: _passwordcontroller,
                enableInteractiveSelection: false,
                obscureText: true,
                autofocus: true,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  hintText: 'Clave',
                  labelText: 'Ingrese Clave',
                  suffixIcon: Icon(
                    Icons.lock_outline,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7.0))),
                ),
                onSubmitted: (value) {
                  _password = value;
                },
              ),
              const Divider(
                height: 18.0,
              ),
              SizedBox(
                child: TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                    minimumSize:
                        MaterialStateProperty.all<Size>(const Size(300, 48)),
                  ),
                  onPressed: validateAndSubmit,
                  child: const Text('Ingresar'),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
