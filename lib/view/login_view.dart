import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F6F8),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.edit_calendar,
                          color: Color(0xFF003280),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'iNote',
                          style: TextStyle(
                            color: Color(0xFF003280),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    TextField(
                      keyboardType: TextInputType.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        labelText: 'E-mail',
                        prefixIcon: const Icon(Icons.email),
                        filled: true,
                        fillColor: Color(0xFFE0E3E5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      obscureText: _obscureText,
                      keyboardType: TextInputType.visiblePassword,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        prefixIcon: const Icon(Icons.lock),
                        filled: true,
                        fillColor: Color(0xFFE0E3E5),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Lógica para recuperar senha aqui
                          print("Navegar para tela de recuperação");
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 4,
                          ),
                          tapTargetSize: MaterialTapTargetSize
                              .shrinkWrap, // Reduz o espaço de clique fantasma
                        ),
                        child: const Text(
                          'Esqueceu sua senha?',
                          style: TextStyle(
                            color: Color(0xFF003280),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // BOTÃO DE ENTRAR
                    ElevatedButton(
                      onPressed: () {
                        print("Fazendo login...");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFF003280,
                        ), // Azul escuro do iNote
                        foregroundColor: Colors.white, // Cor do texto
                        minimumSize: const Size(
                          double.infinity,
                          50,
                        ), // Botão largo
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        'ENTRAR',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // BOTÃO DE CADASTRAR
                    OutlinedButton(
                      onPressed: () {
                        print("Ir para tela de cadastro");
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xFF003280),
                          width: 2,
                        ), // Borda azul
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'CRIAR CONTA',
                        style: TextStyle(
                          color: Color(0xFF003280),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
