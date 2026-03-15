import 'dart:convert';
import 'package:app_clientes/config/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CrearCliente extends StatefulWidget {

  static const String ROUTE = "/crear";

  @override
  State<CrearCliente> createState() => _CrearClienteState();

}

class _CrearClienteState extends State<CrearCliente> {

  final _formKey = GlobalKey<FormState>();

  final dpiController = TextEditingController();
  final nombreController = TextEditingController();
  final emailController = TextEditingController();
  final telefonoController = TextEditingController();

  Map? clienteEditar;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {

      final args = ModalRoute.of(context)!.settings.arguments as Map?;

      if(args != null){

        setState(() {

          clienteEditar = args;

          dpiController.text = clienteEditar!["Dpi"] ?? "";
          nombreController.text = clienteEditar!["Nombre"] ?? "";
          emailController.text = clienteEditar!["Email"] ?? "";
          telefonoController.text = clienteEditar!["Telefono"] ?? "";

        });

      }

    });

  }

  Future guardarCliente() async {

  try {

    final response = await http
        .post(
          Uri.parse("${Api.baseUrl}/clientes"),
          headers: {
            "Content-Type": "application/json"
          },
          body: jsonEncode({
            "dpi": dpiController.text,
            "nombre": nombreController.text,
            "email": emailController.text,
            "telefono": telefonoController.text
          }),
        )
        .timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cliente guardado correctamente")),
      );

      Navigator.pop(context, true);

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error del servidor (${response.statusCode})")),
      );

    }

  } catch (e) {

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("No se pudo conectar con la API")),
    );
  }
}

 Future actualizarCliente(int id) async {

  try {

    final response = await http
        .put(
          Uri.parse("${Api.baseUrl}/clientes/$id"),
          headers: {
            "Content-Type": "application/json"
          },
          body: jsonEncode({
            "dpi": dpiController.text,
            "nombre": nombreController.text,
            "email": emailController.text,
            "telefono": telefonoController.text
          }),
        )
        .timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cliente actualizado correctamente")),
      );

      Navigator.pop(context, true);

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error del servidor (${response.statusCode})")),
      );

    }

  } catch (e) {

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("No se pudo conectar con la API")),
    );

  }
}
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text(
          clienteEditar == null ? "Crear cliente" : "Editar cliente"
        ),
      ),

      body: Padding(

        padding: const EdgeInsets.all(15),

        child: Form(

          key: _formKey,

          child: Column(

            children: [

              TextFormField(

                controller: dpiController,

                validator: (value){

                  if(value == null || value.isEmpty){
                    return "Campo obligatorio";
                  }

                  return null;

                },

                decoration: const InputDecoration(
                  labelText: "DPI"
                ),

              ),

              const SizedBox(height: 15),

              TextFormField(

                controller: nombreController,

                validator: (value){

                  if(value == null || value.isEmpty){
                    return "Campo obligatorio";
                  }

                  return null;

                },

                decoration: const InputDecoration(
                  labelText: "Nombre"
                ),

              ),

              const SizedBox(height: 15),

              TextFormField(

                controller: emailController,

                validator: (value){

                  if(value == null || value.isEmpty){
                    return "Campo obligatorio";
                  }

                  if(!value.contains("@")){
                    return "Ingrese un email válido";
                  }

                  return null;

                },

                decoration: const InputDecoration(
                  labelText: "Email"
                ),

              ),

              const SizedBox(height: 15),

              TextFormField(

                controller: telefonoController,

                validator: (value){

                  if(value == null || value.isEmpty){
                    return "Campo obligatorio";
                  }

                  return null;

                },

                decoration: const InputDecoration(
                  labelText: "Telefono"
                ),

              ),

              const SizedBox(height: 20),

              ElevatedButton(

                child: Text(
                  clienteEditar == null ? "Guardar" : "Actualizar"
                ),

                onPressed: (){

                  if(_formKey.currentState!.validate()){

                    if(clienteEditar == null){

                      guardarCliente();

                    }else{

                      actualizarCliente(clienteEditar!["ID"]);

                    }

                  }

                },

              )

            ],

          ),

        ),

      ),

    );

  }

}