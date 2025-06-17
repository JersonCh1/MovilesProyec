import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easynotes_pro/services/security_service.dart';

class PinSetupDialog extends StatefulWidget {
  const PinSetupDialog({super.key});

  @override
  State<PinSetupDialog> createState() => _PinSetupDialogState();
}

class _PinSetupDialogState extends State<PinSetupDialog> {
  final List<String> _firstPin = [];
  final List<String> _confirmPin = [];
  bool _isConfirming = false;
  String _errorMessage = '';

  void _onNumberPressed(String number) {
    if (!_isConfirming) {
      if (_firstPin.length < 4) {
        setState(() {
          _firstPin.add(number);
          _errorMessage = '';
        });

        if (_firstPin.length == 4) {
          setState(() {
            _isConfirming = true;
          });
        }
      }
    } else {
      if (_confirmPin.length < 4) {
        setState(() {
          _confirmPin.add(number);
          _errorMessage = '';
        });

        if (_confirmPin.length == 4) {
          _verifyPins();
        }
      }
    }
  }

  void _onDeletePressed() {
    if (!_isConfirming) {
      if (_firstPin.isNotEmpty) {
        setState(() {
          _firstPin.removeLast();
          _errorMessage = '';
        });
      }
    } else {
      if (_confirmPin.isNotEmpty) {
        setState(() {
          _confirmPin.removeLast();
          _errorMessage = '';
        });
      }
    }
  }

  void _verifyPins() {
    final firstPinString = _firstPin.join();
    final confirmPinString = _confirmPin.join();

    if (firstPinString == confirmPinString) {
      _savePin(firstPinString);
    } else {
      HapticFeedback.vibrate();
      setState(() {
        _firstPin.clear();
        _confirmPin.clear();
        _isConfirming = false;
        _errorMessage = 'Los PINs no coinciden. Intenta de nuevo.';
      });
    }
  }

  Future<void> _savePin(String pin) async {
    try {
      await SecurityService.instance.setCustomPin(pin);
      Navigator.of(context).pop(true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PIN configurado correctamente'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al guardar PIN. Intenta de nuevo.';
        _firstPin.clear();
        _confirmPin.clear();
        _isConfirming = false;
      });
    }
  }

  void _resetPin() {
    setState(() {
      _firstPin.clear();
      _confirmPin.clear();
      _isConfirming = false;
      _errorMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isConfirming ? 'Confirmar PIN' : 'Crear PIN',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              _isConfirming
                  ? 'Confirma tu PIN de 4 dígitos'
                  : 'Crea un PIN de 4 dígitos',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),

            const SizedBox(height: 24),

            // PIN Display
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                final currentPin = _isConfirming ? _confirmPin : _firstPin;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index < currentPin.length
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey[300],
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
                textAlign: TextAlign.center,
              ),

            const SizedBox(height: 24),

            // Keypad
            SizedBox(
              width: 240,
              height: 320,
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
                  // Reset, 0, delete
                  Expanded(
                    child: Row(
                      children: [
                        _buildResetKey(),
                        _buildNumberKey('0'),
                        _buildDeleteKey(),
                      ],
                    ),
                  ),
                ],
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
        margin: const EdgeInsets.all(4),
        child: Material(
          color: Colors.grey[100],
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => _onNumberPressed(number),
            child: Container(
              height: 60,
              child: Center(
                child: Text(
                  number,
                  style: const TextStyle(
                    fontSize: 18,
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

  Widget _buildDeleteKey() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        child: Material(
          color: Colors.grey[100],
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: _onDeletePressed,
            child: Container(
              height: 60,
              child: const Center(
                child: Icon(
                  Icons.backspace,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResetKey() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        child: _isConfirming
            ? Material(
          color: Colors.orange[100],
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: _resetPin,
            child: Container(
              height: 60,
              child: const Center(
                child: Icon(
                  Icons.refresh,
                  size: 20,
                  color: Colors.orange,
                ),
              ),
            ),
          ),
        )
            : const SizedBox(),
      ),
    );
  }
}