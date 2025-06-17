import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easynotes_pro/services/biometric_service.dart';
import 'package:easynotes_pro/services/security_service.dart';

class LockScreen extends StatefulWidget {
  final VoidCallback onUnlocked;

  const LockScreen({super.key, required this.onUnlocked});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final List<String> _enteredPin = [];
  bool _isAuthenticating = false;
  String _errorMessage = '';
  bool _showBiometric = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
    _tryBiometricAuth();
  }

  Future<void> _checkBiometricAvailability() async {
    final isEnabled = await SecurityService.instance.isBiometricEnabled();
    final isAvailable = await BiometricService.instance.isBiometricAvailable();

    setState(() {
      _showBiometric = isEnabled && isAvailable;
    });
  }

  Future<void> _tryBiometricAuth() async {
    if (!_showBiometric) return;

    setState(() {
      _isAuthenticating = true;
    });

    final success = await BiometricService.instance.authenticateWithBiometrics(
      reason: 'Desbloquea EasyNotes Pro para acceder a tus notas',
    );

    if (success) {
      await SecurityService.instance.updateLastUnlockTime();
      widget.onUnlocked();
    } else {
      setState(() {
        _isAuthenticating = false;
        _errorMessage = 'Autenticación fallida. Usa tu PIN.';
      });
    }
  }

  void _onNumberPressed(String number) {
    if (_enteredPin.length < 4) {
      setState(() {
        _enteredPin.add(number);
        _errorMessage = '';
      });

      if (_enteredPin.length == 4) {
        _verifyPin();
      }
    }
  }

  void _onDeletePressed() {
    if (_enteredPin.isNotEmpty) {
      setState(() {
        _enteredPin.removeLast();
        _errorMessage = '';
      });
    }
  }

  Future<void> _verifyPin() async {
    final pin = _enteredPin.join();
    final isCorrect = await SecurityService.instance.verifyPin(pin);

    if (isCorrect) {
      await SecurityService.instance.updateLastUnlockTime();
      widget.onUnlocked();
    } else {
      HapticFeedback.vibrate();
      setState(() {
        _enteredPin.clear();
        _errorMessage = 'PIN incorrecto. Intenta de nuevo.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock,
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'EasyNotes Pro',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ingresa tu PIN para continuar',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            // PIN Display
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index < _enteredPin.length
                              ? Colors.white
                              : Colors.white.withOpacity(0.3),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  if (_errorMessage.isNotEmpty)
                    Text(
                      _errorMessage,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
            ),

            // Keypad
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Numbers 1-3
                    Expanded(
                      child: Row(
                        children: [
                          _buildNumberKey('1'),
                          _buildNumberKey('2'),
                          _buildNumberKey('3'),
                        ],
                      ),
                    ),
                    // Numbers 4-6
                    Expanded(
                      child: Row(
                        children: [
                          _buildNumberKey('4'),
                          _buildNumberKey('5'),
                          _buildNumberKey('6'),
                        ],
                      ),
                    ),
                    // Numbers 7-9
                    Expanded(
                      child: Row(
                        children: [
                          _buildNumberKey('7'),
                          _buildNumberKey('8'),
                          _buildNumberKey('9'),
                        ],
                      ),
                    ),
                    // 0, biometric, delete
                    Expanded(
                      child: Row(
                        children: [
                          _buildBiometricKey(),
                          _buildNumberKey('0'),
                          _buildDeleteKey(),
                        ],
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

  Widget _buildNumberKey(String number) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8),
        child: Material(
          color: Colors.white.withOpacity(0.1),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => _onNumberPressed(number),
            child: Container(
              height: 70,
              child: Center(
                child: Text(
                  number,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBiometricKey() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8),
        child: _showBiometric
            ? Material(
          color: Colors.white.withOpacity(0.1),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: _isAuthenticating ? null : _tryBiometricAuth,
            child: Container(
              height: 70,
              child: Center(
                child: _isAuthenticating
                    ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : const Icon(
                  Icons.fingerprint,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),
        )
            : const SizedBox(),
      ),
    );
  }

  Widget _buildDeleteKey() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8),
        child: Material(
          color: Colors.white.withOpacity(0.1),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: _onDeletePressed,
            child: Container(
              height: 70,
              child: const Center(
                child: Icon(
                  Icons.backspace,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}