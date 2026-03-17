import 'dart:convert';
import 'package:app_clientes/config/api.dart';
import 'package:app_clientes/pages/crear_clientes.dart';
import 'package:app_clientes/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:app_clientes/main.dart';
import 'package:http/http.dart' as http;

class ListaClientes extends StatefulWidget {
  static const String ROUTE = "/lista";

  @override
  State<ListaClientes> createState() => _ListaClientesState();
}

class _ListaClientesState extends State<ListaClientes> {

  List clientes = [];
  List clientesFiltrados = [];
  bool cargando = true;

  final TextEditingController buscarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    validarSesion();
    cargarClientes();
  }

  void validarSesion() async {
    final auth = AuthService();
    bool logged = await auth.isLoggedIn();

    if(!logged){
      Navigator.pushNamedAndRemoveUntil(
        context,
        "/login",
        (route) => false,
      );
    }
  }

  
  Future cargarClientes() async {

    setState(() => cargando = true);

    try {

      final response = await http
          .get(Uri.parse("${Api.baseUrl}/clientes"))
          .timeout(const Duration(seconds: 5));

      if(response.statusCode == 200){

        final data = jsonDecode(response.body);

        setState(() {
          clientes = data;
          clientesFiltrados = data;
          cargando = false;
        });

      } else {
        throw Exception();
      }

    } catch(e){

      setState(() => cargando = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error de conexión"),
          backgroundColor: Colors.red
        )
      );
    }
  }

  
  Future eliminarCliente(int id) async {

    final response = await http.delete(
      Uri.parse("${Api.baseUrl}/clientes/$id")
    );

    if(response.statusCode == 200){
      cargarClientes();
    }
  }

  
  void cerrarSesion() async {

    bool confirmar = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Cerrar sesión"),
        content: const Text("¿Deseas salir de la aplicación?"),
        actions: [
          TextButton(
            onPressed: ()=> Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: ()=> Navigator.pop(context, true),
            child: const Text("Salir", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ?? false;

    if(!confirmar) return;

    final auth = AuthService();
    await auth.logout();

    Navigator.pushNamedAndRemoveUntil(
      context,
      "/login",
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      drawer: _buildDrawer(),

      body: Stack(
        children: [

          
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF6DD5FA),
                  Color(0xFF2980B9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          SafeArea(

            child: Column(
              children: [

                
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      const Text(
                        "Clientes",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      Row(
                        children: [

                          
                          IconButton(
                            icon: const Icon(Icons.dark_mode, color: Colors.white),
                            onPressed: (){
                              MyApp.of(context)?.cambiarTema();
                            },
                          ),

                          
                          IconButton(
                            icon: const Icon(Icons.refresh, color: Colors.white),
                            onPressed: cargarClientes,
                          ),

                          
                          IconButton(
                            icon: const Icon(Icons.logout, color: Colors.white),
                            onPressed: cerrarSesion,
                          ),

                        ],
                      )
                    ],
                  ),
                ),

                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextField(
                      controller: buscarController,
                      decoration: const InputDecoration(
                        hintText: "Buscar cliente...",
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                      ),
                      onChanged: (value){

                        final resultado = clientes.where((cliente){

                          final nombre = (cliente["Nombre"] ?? "").toLowerCase();
                          return nombre.contains(value.toLowerCase());

                        }).toList();

                        setState(() {
                          clientesFiltrados = resultado;
                        });

                      },
                    ),
                  ),
                ),

                const SizedBox(height: 10),

              
                Expanded(
                  child: cargando

                  ? const Center(child: CircularProgressIndicator())

                  : clientesFiltrados.isEmpty

                  ? _emptyState()

                  : RefreshIndicator(
                      onRefresh: cargarClientes,
                      child: ListView.builder(
                        itemCount: clientesFiltrados.length,
                        itemBuilder: (context, index){

                          final cliente = clientesFiltrados[index];

                          return _clienteCard(cliente);

                        },
                      ),
                    ),
                )

              ],
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2980B9),
        child: const Icon(Icons.add),
        onPressed: (){
          Navigator.pushNamed(context, CrearCliente.ROUTE)
          .then((value){
            if(value == true) cargarClientes();
          });
        },
      ),
    );
  }

  Widget _clienteCard(cliente){

    return Dismissible(

      key: Key(cliente["ID"].toString()),
      direction: DismissDirection.endToStart,

      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),

      confirmDismiss: (_) async {
        return await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Eliminar"),
            content: const Text("¿Seguro que deseas eliminar?"),
            actions: [
              TextButton(onPressed: ()=> Navigator.pop(context, false), child: const Text("No")),
              TextButton(onPressed: ()=> Navigator.pop(context, true), child: const Text("Sí", style: TextStyle(color: Colors.red))),
            ],
          ),
        );
      },

      onDismissed: (_) => eliminarCliente(cliente["ID"]),

      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
            )
          ],
        ),

        child: ListTile(
          leading: const CircleAvatar(
            backgroundColor: Color(0xFF2980B9),
            child: Icon(Icons.person, color: Colors.white),
          ),
          title: Text(cliente["Nombre"] ?? ""),
          subtitle: Text(cliente["Email"] ?? ""),
          trailing: IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: (){
              Navigator.pushNamed(
                context,
                CrearCliente.ROUTE,
                arguments: cliente
              ).then((value){
                if(value == true) cargarClientes();
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _emptyState(){
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 90, color: Colors.white70),
          SizedBox(height: 10),
          Text(
            "No hay clientes",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(){
    return Drawer(
      child: ListView(
        children: [

          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6DD5FA), Color(0xFF2980B9)],
              ),
            ),
            child: Text("Menú", style: TextStyle(color: Colors.white)),
          ),

          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text("Cambiar tema"),
            onTap: (){
              MyApp.of(context)?.cambiarTema();
            },
          ),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Cerrar sesión"),
            onTap: cerrarSesion,
          ),
        ],
      ),
    );
  }
}