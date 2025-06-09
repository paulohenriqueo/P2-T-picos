import 'package:prova2/database/database.dart';
import 'package:flutter/material.dart';
import 'package:prova2/style/style.dart'; // Importando o arquivo de estilos

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  _TelaCadastroState createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final formKey = GlobalKey<FormState>();
  final sobrenomeController = TextEditingController();
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final databaseHelper = DatabaseHelper();

  void register() async {
    if (formKey.currentState!.validate()) {
      if (await databaseHelper.getUser(emailController.text) != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'E-mail já cadastrado',
              style: TextStyle(color: AppStyles.backgroundColor),
            ),
            backgroundColor: AppStyles.errorColor,
          ),
        );
        return;
      }

      await databaseHelper.insertUser(
        nomeController.text,
        sobrenomeController.text,
        emailController.text,
        passwordController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Usuário registrado com sucesso',
            style: TextStyle(color: AppStyles.backgroundColor),
          ),
          backgroundColor: AppStyles.successColor,
        ),
      );

      await Future.delayed(const Duration(seconds: 1));
      Navigator.pop(context); // Volta para a tela de login
    }
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
        automaticallyImplyLeading: true,
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
                    // Campo Nome
                    TextFormField(
                      controller: nomeController,
                      decoration: AppStyles.inputDecoration('Nome'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor digite o seu nome';
                        } else if (!RegExp(
                          r'^[A-Za-zÀ-ÿ\s]+$',
                        ).hasMatch(value)) {
                          return 'O nome deve conter apenas letras e espaços';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Campo Sobrenome
                    TextFormField(
                      controller: sobrenomeController,
                      decoration: AppStyles.inputDecoration('Sobrenome'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor digite o seu Sobrenome';
                        } else if (!RegExp(
                          r'^[A-Za-zÀ-ÿ\s]+$',
                        ).hasMatch(value)) {
                          return 'O Sobrenome deve conter apenas letras e espaços';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Campo Email
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

                    // Campo Senha
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

                    // Botão Cadastrar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: register,
                        style: AppStyles.primaryButtonStyle,
                        child: Text(
                          'Cadastrar',
                          style: AppStyles.buttonTextStyle,
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
