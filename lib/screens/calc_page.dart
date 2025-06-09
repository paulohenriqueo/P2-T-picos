import 'package:flutter/material.dart';
import 'package:prova2/style/style.dart';
import 'package:prova2/database/database.dart'; // Adicione esta linha para acessar o banco
import 'package:prova2/screens/login_page.dart'; // Importe a tela de login

class CalculadoraIMC extends StatefulWidget {
  final String email;
  const CalculadoraIMC({super.key, required this.email});

  @override
  _CalculadoraIMCState createState() => _CalculadoraIMCState();
}

class _CalculadoraIMCState extends State<CalculadoraIMC> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  String _resultText = "Informe seus dados!";
  String _classification = "";
  Color _resultColor = AppStyles.textColor;

  String _welcomeMessage = "";
  String _userName = "";
  String _userSobrenome = "";

  @override
  void initState() {
    super.initState();
    _loadUserNameAndWelcome();
  }

  Future<void> _loadUserNameAndWelcome() async {
    final dbHelper = DatabaseHelper();
    final user = await dbHelper.getUser(widget.email);
    String nome = user != null ? (user['nome'] ?? '') : '';
    String sobrenome = user != null ? (user['sobrenome'] ?? '') : '';
    setState(() {
      _userName = nome;
      _userSobrenome = sobrenome;
      _welcomeMessage = _getWelcomeMessage();
    });
  }

  String _getWelcomeMessage() {
    final hour = DateTime.now().hour;
    if (hour >= 6 && hour < 12) {
      return "Bom dia";
    } else if (hour >= 12 && hour < 18) {
      return "Boa tarde";
    } else {
      return "Boa noite";
    }
  }

  void limpaCampos() {
    _weightController.clear();
    _heightController.clear();
    _resultText = "Informe seus dados!";
    _classification = "";
    _resultColor = AppStyles.textColor;
  }

  void logout(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const TelaLogin()),
      (route) => false,
    );
  }

  void _calculateIMC() {
    final double? weight = double.tryParse(_weightController.text);
    final double? height = double.tryParse(_heightController.text);

    if (weight == null || height == null || height == 0) {
      setState(() {
        _resultText = "Dados inválidos!";
        _classification = "";
        _resultColor = AppStyles.errorColor;
      });
      return;
    }

    final double heightInMeters = height / 100;
    final double imc = weight / (heightInMeters * heightInMeters);

    String classification;
    if (imc < 16) {
      classification = "Magreza grave";
    } else if (imc < 17) {
      classification = "Magreza moderada";
    } else if (imc < 18.6) {
      classification = "Magreza leve";
    } else if (imc < 25) {
      classification = "Peso ideal";
    } else if (imc < 30) {
      classification = "Sobrepeso";
    } else if (imc < 35) {
      classification = "Obesidade grau I";
    } else if (imc < 40) {
      classification = "Obesidade grau II (severa)";
    } else {
      classification = "Obesidade grau III (mórbida)";
    }

    setState(() {
      _resultText = "Seu IMC é: ${imc.toStringAsFixed(2)}";
      _classification = "Classificação: $classification";
      _resultColor = IMCCategoryColors.getColorForIMC(imc);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/academia.png'), // Ícone personalizado
        ),
        title: const Text('Calculadora IMC', style: AppStyles.titleStyle),
        centerTitle: true,
        backgroundColor: AppStyles.primaryColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logout(context),
          ),
        ],
      ),

      backgroundColor: AppStyles.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            if (_userName.isNotEmpty && _userSobrenome.isNotEmpty)
              Text(
                "${_welcomeMessage}, $_userName $_userSobrenome!",
                style: AppStyles.titleStyle.copyWith(fontSize: 22),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 20),
            const Text('Peso (kg)', style: AppStyles.inputLabelStyle),
            const SizedBox(height: 8),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: AppStyles.inputDecoration('Ex: 68.5'),
            ),
            const SizedBox(height: 20),
            const Text('Altura (cm)', style: AppStyles.inputLabelStyle),
            const SizedBox(height: 8),
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: AppStyles.inputDecoration('Ex: 175'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _calculateIMC,
              style: AppStyles.primaryButtonStyle,
              child: const Text('CALCULAR', style: AppStyles.buttonTextStyle),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: limpaCampos,
              style: AppStyles.secondaryButtonStyle,
              child: const Text('LIMPAR', style: AppStyles.buttonTextStyle),
            ),
            const SizedBox(height: 30),
            Container(
              decoration: AppStyles.resultCardDecoration,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      _resultText,
                      style: AppStyles.resultTextStyle.copyWith(
                        color: _resultColor,
                      ),
                    ),
                    if (_classification.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          _classification,
                          style: AppStyles.classificationTextStyle.copyWith(
                            color: _resultColor,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }
}
