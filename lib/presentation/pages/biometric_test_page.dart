import 'package:flutter/material.dart';
import 'package:easynotes_pro/services/biometric_service.dart';

class BiometricTestPage extends StatefulWidget {
  const BiometricTestPage({super.key});

  @override
  State<BiometricTestPage> createState() => _BiometricTestPageState();
}

class _BiometricTestPageState extends State<BiometricTestPage> {
  String _status = 'Verificando...';
  bool _isAvailable = false;
  List<String> _availableTypes = [];

  @override
  void initState() {
    super.initState();
    _checkBiometricStatus();
  }

  Future<void> _checkBiometricStatus() async {
    try {
      final isAvailable = await BiometricService.instance.isBiometricAvailable();
      final biometrics = await BiometricService.instance.getAvailableBiometrics();
      final description = await BiometricService.instance.getBiometricTypeDescription();
      final hasConfigured = await BiometricService.instance.hasBiometricConfigured();

      setState(() {
        _isAvailable = isAvailable;
        _availableTypes = biometrics.map((e) => e.toString()).toList();
        _status = '''
Disponible: $isAvailable
Configurado: $hasConfigured
Tipo: $description
Tipos disponibles: ${_availableTypes.join(', ')}
        ''';
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    }
  }

  Future<void> _testAuthentication() async {
    try {
      setState(() {
        _status = 'Intentando autenticación...';
      });

      final success = await BiometricService.instance.authenticateWithBiometrics(
        reason: 'Prueba de autenticación biométrica',
      );

      setState(() {
        _status = success ? 'Autenticación EXITOSA ✅' : 'Autenticación FALLÓ ❌';
      });
    } catch (e) {
      setState(() {
        _status = 'Error en autenticación: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Biométrico'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estado del Sistema',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Text(_status),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: _checkBiometricStatus,
              child: const Text('Verificar Estado'),
            ),

            const SizedBox(height: 8),

            ElevatedButton(
              onPressed: _isAvailable ? _testAuthentication : null,
              child: const Text('Probar Autenticación'),
            ),

            const SizedBox(height: 24),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Instrucciones de Solución',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text('1. Verifica que tengas huella configurada en tu S25 Ultra'),
                    const Text('2. Ve a Configuración → Biometría → Huella dactilar'),
                    const Text('3. Asegúrate de tener al menos una huella registrada'),
                    const Text('4. Permite permisos biométricos a EasyNotes Pro'),
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