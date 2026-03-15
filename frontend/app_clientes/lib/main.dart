import 'package:app_clientes/pages/crear_clientes.dart';
import 'package:app_clientes/pages/lista_clientes.dart';
import 'package:flutter/material.dart';

void main() {

  runApp(const MyApp());

}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      title: "Clientes App",

      initialRoute: ListaClientes.ROUTE,

      routes: {

        ListaClientes.ROUTE : (context) => ListaClientes(),

        CrearCliente.ROUTE : (context) => CrearCliente(),

      },

    );

  }

}