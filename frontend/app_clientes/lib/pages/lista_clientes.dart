import 'dart:convert';
import 'package:app_clientes/config/api.dart';
import 'package:app_clientes/pages/crear_clientes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListaClientes extends StatefulWidget {
  static const String ROUTE = "/lista";

  @override
  State<ListaClientes> createState() => _ListaClientesState();
}

class _ListaClientesState extends State<ListaClientes> {
  List clientes = [];
  bool cargando = true;
  final TextEditingController buscarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cargarClientes();
  }

  Future cargarClientes() async {
    setState(() => cargando = true);

    try {
      final response = await http
          .get(Uri.parse("${Api.baseUrl}/clientes"))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        setState(() {
          clientes = jsonDecode(response.body);
          cargando = false;
        });
      } else {
        throw Exception("Error al cargar clientes");
      }
    } catch (e) {
      setState(() => cargando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error de conexión con el servidor"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future buscarClientePorId(String id) async {
    if (id.isEmpty) {
      cargarClientes();
      return;
    }

    try {
      final response = await http
          .get(Uri.parse("${Api.baseUrl}/clientes/$id"))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final cliente = jsonDecode(response.body);
        setState(() {
          clientes = [cliente];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Cliente no encontrado"),
            backgroundColor: Colors.orangeAccent,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error al buscar cliente"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future eliminarCliente(int id) async {
    try {
      final response = await http.delete(Uri.parse("${Api.baseUrl}/clientes/$id"));
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Cliente eliminado"),
            backgroundColor: Colors.green,
          ),
        );
        cargarClientes();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error al eliminar cliente"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void confirmarEliminar(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Eliminar cliente"),
        content: const Text("¿Desea eliminar este cliente?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              eliminarCliente(id);
              Navigator.pop(context);
            },
            child: const Text(
              "Eliminar",
              style: TextStyle(color: Colors.red),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Listado de clientes"),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4CAF50),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.pushNamed(context, CrearCliente.ROUTE).then((value) {
            if (value == true) cargarClientes();
          });
        },
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF4CAF50)))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: buscarController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Buscar cliente por ID",
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          buscarController.clear();
                          cargarClientes();
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: (value) {
                      if (value.isEmpty) cargarClientes();
                    },
                    onSubmitted: (value) => buscarClientePorId(value),
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    color: const Color(0xFF4CAF50),
                    onRefresh: cargarClientes,
                    child: ListView.builder(
                      itemCount: clientes.length,
                      itemBuilder: (context, index) {
                        final cliente = clientes[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 2,
                          child: ListTile(
                            leading: const Icon(Icons.person, size: 35, color: Color(0xFF4CAF50)),
                            title: Text(
                              cliente["Nombre"] ?? "Sin nombre",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("ID: ${cliente["ID"]}"),
                                Text(cliente["Email"] ?? ""),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      CrearCliente.ROUTE,
                                      arguments: cliente,
                                    ).then((value) {
                                      if (value == true) cargarClientes();
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => confirmarEliminar(cliente["ID"]),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}