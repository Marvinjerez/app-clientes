import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/login.dart';
import 'pages/registrar.dart';
import 'pages/lista_clientes.dart';
import 'pages/crear_clientes.dart';

import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    cargarTema();
  }

  void cargarTema() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool("darkMode") ?? false;
    setState(() {
      themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void cambiarTema() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      themeMode = themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
    await prefs.setBool(
      "darkMode",
      themeMode == ThemeMode.dark,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedTheme(
      duration: const Duration(milliseconds: 300),
      data: themeMode == ThemeMode.dark
          ? AppTheme.darkTheme
          : AppTheme.lightTheme,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: themeMode,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        initialRoute: "/login",
        routes: {
          "/login": (context) => Login(),
          "/lista": (context) => ListaClientes(),
          "/crear": (context) => CrearCliente(),
          "/registrar": (context) => Registrar(),
        },
      ),
    );
  }
}