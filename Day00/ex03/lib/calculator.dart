
// lib/calculator.dart

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'calculator_buttons.dart';
import 'math_parser.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  CalculatorState createState() => CalculatorState();
}

class CalculatorState extends State<Calculator> {
  String _expression = '';
  String _result = '0';

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'AC') {
        _expression = '';
        _result = '0';
      } else if (buttonText == 'C') {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
      } else if (buttonText == '=') {
        try {
          _result = evaluateExpression(_expression).toString();
        } catch (e) {
          _result = 'Error';
        }
      } else {
        // Vérifier si le dernier caractère de l'expression est un opérateur
        if (isOperator(buttonText)) {
          if (_expression.isNotEmpty && isOperator(_expression[_expression.length - 1])) {
            // Remplacer l'opérateur précédent par le nouveau
            _expression = _expression.substring(0, _expression.length - 1) + buttonText;
          } else {
            _expression += buttonText;
          }
        } else {
          _expression += buttonText;
        }
      }
    });
  }

  // Fonction pour vérifier si le texte est un opérateur
  bool isOperator(String value) {
    return value == '+' || value == '-' || value == '*' || value == '/';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Column(
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.bottomRight,
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            _expression,
                            style: TextStyle(
                              fontSize: orientation == Orientation.portrait ? 28 : 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        AutoSizeText(
                          _result,
                          style: TextStyle(
                            fontSize: orientation == Orientation.portrait ? 48 : 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          maxLines: 1,
                          minFontSize: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(height: 1, color: Colors.grey),
              Flexible(
                flex: 3,
                child: buildButtons(orientation, _onButtonPressed),
              ),
            ],
          );
        },
      ),
    );
  }
}

