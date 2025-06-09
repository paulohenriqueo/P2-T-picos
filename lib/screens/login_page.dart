import 'package:prova2/database/database.dart';
import 'package:flutter/material.dart';
import 'package:prova2/screens/cadastro_page.dart';
import 'package:prova2/screens/calc_page.dart';
import 'package:prova2/style/style.dart'; // Importando o arquivo de estilos

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  loginScreenState createState() => loginScreenState();
}

class loginScreenState extends State<TelaLogin> {
  final formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final databaseHelper = DatabaseHelper();

  void login() async {
    if (formKey.currentState!.validate()) {
      final user = await databaseHelper.getUser(emailController.text);
      if (user != null && user['password'] == passwordController.text) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CalculadoraIMC(email: emailController.text),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Invalid Email or Password',
              style: TextStyle(color: AppStyles.backgroundColor),
            ),
            backgroundColor: AppStyles.errorColor,
          ),
        );
      }
    }
  }

  void limpaCampos() {
    emailController.clear();
    passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/academia.png'),
        ),
        title: Text(
          'Calculadora IMC',
          style: AppStyles.titleStyle.copyWith(color: Colors.white),
        ),
        backgroundColor: AppStyles.primaryColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    // Campo de Email
                    TextFormField(
                      controller: emailController,
                      decoration: AppStyles.inputDecoration('E-mail'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor digite o seu e-mail';
                        } else if (!RegExp(
                          r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}',
                        ).hasMatch(value)) {
                          return 'Por favor digite um endereço de e-mail válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Campo de Senha
                    TextFormField(
                      controller: passwordController,
                      decoration: AppStyles.inputDecoration('Senha'),
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, digite sua senha';
                        } else if (value.length < 8) {
                          return 'A senha deve ter pelo menos 8 caracteres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Botões de Login e Limpar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 120,
                          child: ElevatedButton(
                            onPressed: login,
                            style: AppStyles.loginButtonStyle,
                            child: Text(
                              'Login',
                              style: AppStyles.buttonTextStyle,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        SizedBox(
                          width: 120,
                          child: ElevatedButton(
                            onPressed: limpaCampos,
                            style: AppStyles.loginButtonStyle,
                            child: Text(
                              'Limpar',
                              style: AppStyles.buttonTextStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Link para Cadastro
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TelaCadastro(),
                          ),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          text: 'Não tem conta? ',
                          style: TextStyle(
                            color: AppStyles.textColor.withOpacity(0.7),
                          ),
                          children: [
                            TextSpan(
                              text: 'Cadastre-se aqui',
                              style: TextStyle(
                                color: AppStyles.primaryColor,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
