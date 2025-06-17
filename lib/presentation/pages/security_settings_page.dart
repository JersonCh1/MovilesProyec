import 'package:flutter/material.dart';
import 'package:easynotes_pro/services/biometric_service.dart';
import 'package:easynotes_pro/services/security_service.dart';
import 'package:easynotes_pro/presentation/widgets/pin_setup_dialog.dart';

class SecuritySettingsPage extends StatefulWidget {
  const SecuritySettingsPage({super.key});

  @override
  State<SecuritySettingsPage> createState() => _SecuritySettingsPageState();
}

class _SecuritySettingsPageState extends State<SecuritySettingsPage> {
  bool _isBiometricEnabled = false;
  bool _isAppLockEnabled = false;
  bool _isBiometricAvailable = false;
  bool _hasPinConfigured = false;
  String _biometricType = '';
  int _autoLockTime = 5;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final biometricEnabled = await SecurityService.instance.isBiometricEnabled();
    final appLockEnabled = await SecurityService.instance.isAppLockEnabled();
    final biometricAvailable = await BiometricService.instance.isBiometricAvailable();
    final pinConfigured = await SecurityService.instance.hasPinConfigured();
    final biometricType = await BiometricService.instance.getBiometricTypeDescription();
    final autoLockTime = await SecurityService.instance.getAutoLockTime();

    setState(() {
      _isBiometricEnabled = biometricEnabled;
      _isAppLockEnabled = appLockEnabled;
      _isBiometricAvailable = biometricAvailable;
      _hasPinConfigured = pinConfigured;
      _biometricType = biometricType;
      _autoLockTime = autoLockTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración de Seguridad'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Sección de Bloqueo de App
          _buildSectionHeader('Bloqueo de Aplicación'),
          _buildAppLockTile(),
          const SizedBox(height: 8),

          if (_isAppLockEnabled) ...[
            _buildPinConfigTile(),
            const SizedBox(height: 8),
            if (_isBiometricAvailable)
              _buildBiometricTile(),
            const SizedBox(height: 8),
            _buildAutoLockTimeTile(),
            const SizedBox(height: 24),
          ],

          // Sección de Notas Privadas
          _buildSectionHeader('Notas Privadas'),
          _buildPrivateNotesInfo(),
          const SizedBox(height: 24),

          // Sección de Información
          _buildSectionHeader('Información'),
          _buildSecurityInfo(),
          const SizedBox(height: 24),

          // Sección de Debug/Test
          _buildSectionHeader('Diagnóstico'),
          _buildBiometricTestTile(),

        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAppLockTile() {
    return Card(
      child: SwitchListTile(
        title: const Text('Bloquear aplicación'),
        subtitle: const Text('Requiere autenticación para abrir la app'),
        value: _isAppLockEnabled,
        onChanged: (value) async {
          if (value && !_hasPinConfigured) {
            // Primero configurar PIN
            final success = await _showPinSetupDialog();
            if (success) {
              await SecurityService.instance.setAppLockEnabled(true);
              setState(() {
                _isAppLockEnabled = true;
                _hasPinConfigured = true;
              });
            }
          } else {
            await SecurityService.instance.setAppLockEnabled(value);
            setState(() {
              _isAppLockEnabled = value;
            });
          }
        },
        secondary: const Icon(Icons.lock),
      ),
    );
  }

  Widget _buildPinConfigTile() {
    return Card(
      child: ListTile(
        title: const Text('Cambiar PIN'),
        subtitle: Text(_hasPinConfigured ? 'PIN configurado' : 'Configurar PIN'),
        leading: const Icon(Icons.pin),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: _showPinSetupDialog,
      ),
    );
  }

  Widget _buildBiometricTile() {
    return Card(
      child: SwitchListTile(
        title: Text(_biometricType),
        subtitle: const Text('Usar biometría para desbloquear'),
        value: _isBiometricEnabled,
        onChanged: _isAppLockEnabled ? (value) async {
          if (value) {
            final success = await BiometricService.instance.authenticateWithBiometrics(
              reason: 'Habilitar $_biometricType para EasyNotes Pro',
            );
            if (success) {
              await SecurityService.instance.setBiometricEnabled(true);
              setState(() {
                _isBiometricEnabled = true;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Biometría habilitada correctamente'),
                  backgroundColor: Colors.green,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No se pudo habilitar la biometría'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          } else {
            await SecurityService.instance.setBiometricEnabled(false);
            setState(() {
              _isBiometricEnabled = false;
            });
          }
        } : null,
        secondary: const Icon(Icons.fingerprint),
      ),
    );
  }

  Widget _buildAutoLockTimeTile() {
    return Card(
      child: ListTile(
        title: const Text('Auto-bloqueo'),
        subtitle: Text('Bloquear después de $_autoLockTime minutos'),
        leading: const Icon(Icons.timer),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: _showAutoLockDialog,
      ),
    );
  }

  Widget _buildPrivateNotesInfo() {
    return Card(
      child: ListTile(
        title: const Text('Notas privadas'),
        subtitle: const Text('Las notas marcadas como privadas requieren autenticación'),
        leading: const Icon(Icons.security),
      ),
    );
  }

  Widget _buildSecurityInfo() {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: const Text('Estado de seguridad'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Biometría disponible: ${_isBiometricAvailable ? "Sí" : "No"}'),
                Text('PIN configurado: ${_hasPinConfigured ? "Sí" : "No"}'),
                Text('Bloqueo activo: ${_isAppLockEnabled ? "Sí" : "No"}'),
              ],
            ),
            leading: const Icon(Icons.info),
          ),
        ],
      ),
    );
  }

  Widget _buildBiometricTestTile() {
    return Card(
      child: ListTile(
        title: const Text('🔍 Test Biométrico'),
        subtitle: const Text('Diagnosticar problemas de biometría'),
        leading: const Icon(Icons.bug_report),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () async {
          // Test rápido integrado
          final result = await BiometricService.instance.isBiometricAvailable();
          final types = await BiometricService.instance.getAvailableBiometrics();

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Resultado del Test'),
              content: Text(
                  'Disponible: $result\n'
                      'Tipos: $types\n'
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
                if (result) TextButton(
                  onPressed: () async {
                    Navigator.pop(context);

                    // Test completo con logs
                    final results = await BiometricService.instance.testAllMethods();

                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Resultados Detallados'),
                        content: SingleChildScrollView(
                          child: Text(
                              'Disponible: ${results['available']}\n'
                                  'Configurado: ${results['configured']}\n'
                                  'Tipos: ${results['types']}\n\n'
                                  'Test Básico: ${results['basic']}\n'
                                  'Test Mínimo: ${results['minimal']}\n'
                                  'Test Samsung: ${results['samsung']}\n'
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('Test Completo'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<bool> _showPinSetupDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const PinSetupDialog(),
    );

    if (result == true) {
      _loadSettings();
    }

    return result ?? false;
  }

  Future<void> _showAutoLockDialog() async {
    final selected = await showDialog<int>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Tiempo de auto-bloqueo'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 1),
            child: const Text('1 minuto'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 2),
            child: const Text('2 minutos'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 5),
            child: const Text('5 minutos'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 10),
            child: const Text('10 minutos'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 30),
            child: const Text('30 minutos'),
          ),
        ],
      ),
    );

    if (selected != null) {
      await SecurityService.instance.setAutoLockTime(selected);
      setState(() {
        _autoLockTime = selected;
      });
    }
  }
}