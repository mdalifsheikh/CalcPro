import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const CalcProApp());
}

class CalcProApp extends StatelessWidget {
  const CalcProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CalcPro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF0A0E21),
        scaffoldBackgroundColor: const Color(0xFF0A0E21),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = '';
  String _result = '0';
  bool _isResultShown = false;

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _expression = '';
        _result = '0';
        _isResultShown = false;
      } else if (value == '⌫') {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
          if (_expression.isEmpty) {
            _result = '0';
          }
        }
      } else if (value == '=') {
        _calculate();
      } else if (value == '%') {
        if (_expression.isNotEmpty) {
          try {
            final parser = Parser();
            final exp = parser.parse(_expression);
            final cm = ContextModel();
            final eval = exp.evaluate(EvaluationType.REAL, cm);
            _expression = (eval / 100).toString();
            _result = _expression;
            _isResultShown = true;
          } catch (_) {
            _result = 'Error';
          }
        }
      } else {
        if (_isResultShown) {
          if ('+-×÷'.contains(value)) {
            _expression = _result + value;
          } else {
            _expression = value;
          }
          _isResultShown = false;
        } else {
          if ('+-×÷'.contains(value) &&
              _expression.isNotEmpty &&
              '+-×÷'.contains(_expression[_expression.length - 1])) {
            _expression =
                _expression.substring(0, _expression.length - 1) + value;
          } else {
            _expression += value;
          }
        }
      }
    });
  }

  void _calculate() {
    try {
      String exp = _expression
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('−', '-');

      if (exp.isNotEmpty && '+-*/'.contains(exp[exp.length - 1])) {
        exp = exp.substring(0, exp.length - 1);
      }

      if (exp.isEmpty) return;

      final parser = Parser();
      final expression = parser.parse(exp);
      final cm = ContextModel();
      final eval = expression.evaluate(EvaluationType.REAL, cm);

      if (eval == eval.toInt()) {
        _result = eval.toInt().toString();
      } else {
        _result = eval
            .toStringAsFixed(8)
            .replaceAll(RegExp(r'0+$'), '')
            .replaceAll(RegExp(r'\.$'), '');
      }
      _expression = _result;
      _isResultShown = true;
    } catch (e) {
      _result = 'Error';
      _isResultShown = true;
    }
  }

  Widget _buildButton(String text,
      {Color? color, Color? textColor, double flex = 1}) {
    final isOperator = '+-×÷=%'.contains(text);
    final isClear = text == 'C' || text == '⌫';

    return Expanded(
      flex: flex.toInt(),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Material(
          color: color ??
              (isOperator
                  ? const Color(0xFFFF9500)
                  : isClear
                      ? const Color(0xFF2C2C2E)
                      : const Color(0xFF1C1C1E)),
          borderRadius: BorderRadius.circular(18),
          elevation: 4,
          shadowColor: Colors.black45,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => _onButtonPressed(text),
            child: Container(
              height: 72,
              alignment: Alignment.center,
              child: Text(
                text,
                style: TextStyle(
                  fontSize: text == '⌫' ? 26 : 28,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _expression.isEmpty ? ' ' : _expression,
                      style: const TextStyle(
                        fontSize: 28,
                        color: Colors.white70,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _result,
                      style: const TextStyle(
                        fontSize: 56,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _buildButton('C', color: const Color(0xFF2C2C2E)),
                        _buildButton('⌫', color: const Color(0xFF2C2C2E)),
                        _buildButton('%', color: const Color(0xFF2C2C2E)),
                        _buildButton('÷'),
                      ],
                    ),
                    Row(
                      children: [
                        _buildButton('7'),
                        _buildButton('8'),
                        _buildButton('9'),
                        _buildButton('×'),
                      ],
                    ),
                    Row(
                      children: [
                        _buildButton('4'),
                        _buildButton('5'),
                        _buildButton('6'),
                        _buildButton('−'),
                      ],
                    ),
                    Row(
                      children: [
                        _buildButton('1'),
                        _buildButton('2'),
                        _buildButton('3'),
                        _buildButton('+'),
                      ],
                    ),
                    Row(
                      children: [
                        _buildButton('0', flex: 2),
                        _buildButton('.'),
                        _buildButton('='),
                      ],
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
}
