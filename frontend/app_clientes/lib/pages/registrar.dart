import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class Registrar extends StatefulWidget {
  const Registrar({super.key});

  static const String ROUTE = "/registrar";

  @override
  State<Registrar> createState() => _RegistrarState();
}

class _RegistrarState extends State<Registrar> {

  final AuthService authService = AuthService();
  final usuarioController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool loading = false;
  bool visible = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 200), (){
      setState(() {
        visible = true;
      });
    });
  }

  void registrar() async {

    if (!_formKey.currentState!.validate()) return;

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Las contraseñas no coinciden"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => loading = true);

    bool success = await authService.register(
  usuarioController.text,
  emailController.text,
  passwordController.text
);

setState(() => loading = false);

if(success){

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Usuario registrado correctamente"),
      backgroundColor: Colors.green,
    ),
  );

  Navigator.pop(context);

}else{

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Error al registrar usuario"),
      backgroundColor: Colors.red,
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

                            const Icon(
                              Icons.person_add,
                              size: 80,
                              color: Color(0xFF2980B9),
                            ),

                            const SizedBox(height: 15),

                            const Text(
                              "Crear Cuenta",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 20),

                            
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
                                      ? "Ingrese usuario"
                                      : null,
                            ),

                            const SizedBox(height: 15),

                            
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText: "Email",
                                prefixIcon: const Icon(Icons.email),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Ingrese email";
                                }
                                if (!value.contains("@")) {
                                  return "Email inválido";
                                }
                                return null;
                              },
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
                                  (value == null || value.length < 4)
                                      ? "Mínimo 4 caracteres"
                                      : null,
                            ),

                            const SizedBox(height: 15),

                            
                            TextFormField(
                              controller: confirmPasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: "Confirmar contraseña",
                                prefixIcon: const Icon(Icons.lock_outline),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              validator: (value) =>
                                  (value == null || value.isEmpty)
                                      ? "Confirme la contraseña"
                                      : null,
                            ),

                            const SizedBox(height: 25),

                            
                            loading
                                ? const CircularProgressIndicator()
                                : ElevatedButton(
                                    onPressed: registrar,
                                    style: ElevatedButton.styleFrom(
                                      shape: const CircleBorder(),
                                      padding: const EdgeInsets.all(20),
                                      backgroundColor: const Color(0xFF2980B9),
                                      elevation: 5,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      size: 28,
                                      color: Colors.white,
                                    ),
                                  ),

                            const SizedBox(height: 15),

                            
                            TextButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              child: const Text("¿Ya tienes cuenta? Inicia sesión"),
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