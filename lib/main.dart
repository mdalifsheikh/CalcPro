import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
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
        scaffoldBackgroundColor: const Color(0xFF09090F),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9B6DFF),
          brightness: Brightness.dark,
        ),
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
  String? _error;

  static const Color _purple = Color(0xFF9B6DFF);
  static const Color _surface = Color(0xFF191923);
  static const Color _operator = Color(0xFF29213B);

  final List<String> _keys = const [
    'AC', 'DEL', '(', ')',
    'sin', 'cos', 'tan', '÷',
    '√', 'x²', 'log', '×',
    '7', '8', '9', '−',
    '4', '5', '6', '+',
    '1', '2', '3', '%',
    '±', '0', '.', '=',
  ];

  void _press(String key) {
    setState(() {
      _error = null;

      if (key == 'AC') {
        _expression = '';
        _result = '0';
        return;
      }
      if (key == 'DEL') {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
        return;
      }
      if (key == '=') {
        _calculate();
        return;
      }
      if (key == '±') {
        if (_expression.isEmpty) {
          _expression = '-';
        } else if (_expression.startsWith('-')) {
          _expression = _expression.substring(1);
        } else {
          _expression = '-$_expression';
        }
        return;
      }

      switch (key) {
        case 'sin':
        case 'cos':
        case 'tan':
        case 'log':
          _expression += '$key(';
          break;
        case '√':
          _expression += 'sqrt(';
          break;
        case 'x²':
          _expression += '^2';
          break;
        default:
          _expression += key;
          break;
      }
    });
  }

  void _calculate() {
    if (_expression.trim().isEmpty) return;

    try {
      final normalized = _expression
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('−', '-')
          .replaceAll('%', '/100');
      final parser = Parser();
      final parsed = parser.parse(normalized);
      final value = parsed.evaluate(EvaluationType.REAL, ContextModel());

      if (!value.isFinite) {
        throw const FormatException('Result is not finite');
      }

      _result = _formatResult(value.toDouble());
      _error = null;
    } catch (_) {
      _error = 'Invalid expression';
    }
  }

  String _formatResult(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsPrecision(10).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
  }

  void _useResult() {
    if (_error == null && _result != '0') {
      setState(() {
        _expression = _result;
      });
    }
  }

  Color _keyColor(String key) {
    if (key == '=') return _purple;
    if (const ['AC', 'DEL', '(', ')', 'sin', 'cos', 'tan', '√', 'x²', 'log'].contains(key)) {
      return _operator;
    }
    if (const ['÷', '×', '−', '+', '%'].contains(key)) {
      return const Color(0xFF211D2D);
    }
    return _surface;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: _purple.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.calculate_rounded, color: _purple),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('CalcPro', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                      Text('ADVANCED CALCULATOR', style: TextStyle(fontSize: 9, letterSpacing: 1.5, color: Colors.white54)),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.more_horiz_rounded, color: Colors.white54, size: 26),
                ],
              ),
              const Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  _expression.isEmpty ? '0' : _expression,
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white60, fontSize: 25, fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: _useResult,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      _error ?? _result,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: _error == null ? Colors.white : Colors.redAccent,
                        fontSize: 48,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Container(height: 1, color: Colors.white.withValues(alpha: 0.08)),
              const SizedBox(height: 18),
              Expanded(
                flex: 5,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _keys.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 11,
                    mainAxisSpacing: 11,
                    childAspectRatio: 1.28,
                  ),
                  itemBuilder: (context, index) {
                    final key = _keys[index];
                    final isEquals = key == '=';
                    return Material(
                      color: _keyColor(key),
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => _press(key),
                        child: Center(
                          child: Text(
                            key,
                            style: TextStyle(
                              color: isEquals ? Colors.white : (key == 'AC' ? const Color(0xFFFF8D9B) : Colors.white),
                              fontSize: key.length > 2 ? 16 : 21,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text('Tap the result to use it in the next calculation', style: TextStyle(color: Colors.white30, fontSize: 11)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
