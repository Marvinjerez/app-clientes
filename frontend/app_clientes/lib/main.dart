import 'package:flutter/material.dart';
import 'pages/login.dart';
import 'pages/lista_clientes.dart';
import 'pages/crear_clientes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  ThemeMode themeMode = ThemeMode.light;

  void cambiarTema() {

    setState(() {

      themeMode = themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;

    });

  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      themeMode: themeMode,

    theme: ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.grey[100],
    ),

    darkTheme: ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: const Color(0xFF121212),
    ),

      initialRoute: "/login",

      routes: {

        "/login": (context) => Login(),
        "/lista": (context) => ListaClientes(),
        "/crear": (context) => CrearCliente(),

      },

    );

  }

}