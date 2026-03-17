import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'lista_clientes.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  static const String ROUTE = "/login";

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final usuarioController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthService authService = AuthService();

  bool loading = false;
  bool visible = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 200), (){
      setState(() {
        visible = true;
      });
    });
  }

  void checkLogin() async {

  bool logged = await authService.isLoggedIn();

  if(logged){
    Navigator.pushReplacementNamed(context, "/lista");
  }
}

  void login() async {

    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    bool success = await authService.login(
      usuarioController.text,
      passwordController.text,
    );

    setState(() => loading = false);

    if (success) {

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (_, __, ___) => ListaClientes(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );

    } else {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Credenciales incorrectas"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

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

          Center(

            child: SingleChildScrollView(

              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 800),
                opacity: visible ? 1 : 0,

                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 800),
                  transform: Matrix4.translationValues(
                    0,
                    visible ? 0 : 50,
                    0,
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(20),

                    child: Container(

                      padding: const EdgeInsets.all(25),

                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 10),
                          )
                        ],
                      ),

                      child: Form(
                        key: _formKey,

                        child: Column(

                          mainAxisSize: MainAxisSize.min,

                          children: [

                            const Hero(
                              tag: "logo",
                              child: Icon(
                                Icons.lock,
                                size: 80,
                                color: Color(0xFF2980B9),
                              ),
                            ),

                            const SizedBox(height: 20),

                            const Text(
                              "Bienvenido",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 25),

                            TextFormField(
                              controller: usuarioController,
                              decoration: InputDecoration(
                                labelText: "Usuario",
                                prefixIcon: const Icon(Icons.person),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              validator: (value) =>
                                  (value == null || value.isEmpty)
                                      ? "Ingrese el usuario"
                                      : null,
                            ),

                            const SizedBox(height: 15),

                            TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: "Contraseña",
                                prefixIcon: const Icon(Icons.lock),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              validator: (value) =>
                                  (value == null || value.isEmpty)
                                      ? "Ingrese la contraseña"
                                      : null,
                            ),

                            const SizedBox(height: 25),

                            loading

                                ? const CircularProgressIndicator()

                                : ElevatedButton(
                                    onPressed: login,
                                    style: ElevatedButton.styleFrom(
                                      shape: const CircleBorder(),
                                      padding: const EdgeInsets.all(20),
                                      backgroundColor: const Color(0xFF2980B9),
                                      elevation: 5,
                                    ),
                                    child: const Icon(
                                      Icons.arrow_forward,
                                      size: 28,
                                      color: Colors.white,
                                    ),
                                  ),

                            const SizedBox(height: 20),

                            TextButton(
                              onPressed: (){
                                Navigator.pushNamed(context, "/registrar");
                              },
                              child: const Text(
                                "¿No tienes cuenta? Regístrate",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )

                          ],

                        ),

                      ),

                    ),

                  ),

                ),

              ),

            ),

          ),

        ],

      ),

    );

  }

}