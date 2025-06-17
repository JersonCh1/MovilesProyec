import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  static final BiometricService instance = BiometricService._internal();
  BiometricService._internal();

  final LocalAuthentication _localAuth = LocalAuthentication();

  /// Verificar si la biometría está disponible
  Future<bool> isBiometricAvailable() async {
    try {
      final bool isAvailable = await _localAuth.canCheckBiometrics;
      final bool isDeviceSupported = await _localAuth.isDeviceSupported();
      return isAvailable && isDeviceSupported;
    } catch (e) {
      print('Error verificando biometría: $e');
      return false;
    }
  }

  /// Obtener tipos de biometría disponibles
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      print('Error obteniendo biométricos: $e');
      return [];
    }
  }

  /// Verificar si hay biometría configurada
  Future<bool> hasBiometricConfigured() async {
    final availableBiometrics = await getAvailableBiometrics();
    return availableBiometrics.isNotEmpty;
  }

  /// Obtener descripción de biometría disponible
  Future<String> getBiometricTypeDescription() async {
    final biometrics = await getAvailableBiometrics();

    if (biometrics.contains(BiometricType.face)) {
      return 'Reconocimiento facial';
    } else if (biometrics.contains(BiometricType.fingerprint)) {
      return 'Huella dactilar';
    } else if (biometrics.contains(BiometricType.iris)) {
      return 'Reconocimiento de iris';
    } else if (biometrics.contains(BiometricType.strong)) {
      return 'Biometría fuerte';
    } else if (biometrics.contains(BiometricType.weak)) {
      return 'Biometría básica';
    }

    return 'Autenticación del dispositivo';
  }

  /// VERSIÓN 1: Autenticación básica (más compatible)
  Future<bool> authenticateBasic() async {
    try {
      final bool isAvailable = await isBiometricAvailable();
      if (!isAvailable) {
        print('Biometría no disponible');
        return false;
      }

      print('Iniciando autenticación básica...');

      final bool result = await _localAuth.authenticate(
        localizedReason: 'Verifica tu identidad para continuar',
      );

      print('Resultado autenticación básica: $result');
      return result;

    } catch (e) {
      print('Error en autenticación básica: $e');
      return false;
    }
  }

  /// VERSIÓN 2: Autenticación con opciones mínimas
  Future<bool> authenticateMinimal() async {
    try {
      final bool isAvailable = await isBiometricAvailable();
      if (!isAvailable) {
        print('Biometría no disponible');
        return false;
      }

      print('Iniciando autenticación mínima...');

      final bool result = await _localAuth.authenticate(
        localizedReason: 'Autenticación requerida',
        options: const AuthenticationOptions(
          biometricOnly: true,  // Solo biometría, sin PIN
          stickyAuth: false,
        ),
      );

      print('Resultado autenticación mínima: $result');
      return result;

    } catch (e) {
      print('Error en autenticación mínima: $e');
      return false;
    }
  }

  /// VERSIÓN 3: Autenticación Samsung-friendly
  Future<bool> authenticateSamsung() async {
    try {
      final bool isAvailable = await isBiometricAvailable();
      if (!isAvailable) {
        print('Biometría no disponible');
        return false;
      }

      print('Iniciando autenticación Samsung...');

      final bool result = await _localAuth.authenticate(
        localizedReason: 'Usa tu huella dactilar para acceder',
        options: const AuthenticationOptions(
          biometricOnly: false,  // Permite fallback a PIN del dispositivo
          stickyAuth: true,      // Mantiene el diálogo hasta completar
        ),
      );

      print('Resultado autenticación Samsung: $result');
      return result;

    } catch (e) {
      print('Error en autenticación Samsung: $e');
      return false;
    }
  }

  /// Método principal que prueba diferentes versiones
  Future<bool> authenticateWithBiometrics({required String reason}) async {
    print('=== Iniciando proceso de autenticación ===');

    // Intentar versión básica primero
    try {
      final result1 = await authenticateBasic();
      if (result1) {
        print('✅ Autenticación básica exitosa');
        return true;
      }
    } catch (e) {
      print('❌ Falló autenticación básica: $e');
    }

    // Si falla, intentar versión mínima
    try {
      final result2 = await authenticateMinimal();
      if (result2) {
        print('✅ Autenticación mínima exitosa');
        return true;
      }
    } catch (e) {
      print('❌ Falló autenticación mínima: $e');
    }

    // Como último recurso, intentar versión Samsung
    try {
      final result3 = await authenticateSamsung();
      if (result3) {
        print('✅ Autenticación Samsung exitosa');
        return true;
      }
    } catch (e) {
      print('❌ Falló autenticación Samsung: $e');
    }

    print('❌ Todas las versiones de autenticación fallaron');
    return false;
  }

  /// Método para testing con logs detallados
  Future<Map<String, dynamic>> testAllMethods() async {
    final results = <String, dynamic>{};

    results['available'] = await isBiometricAvailable();
    results['configured'] = await hasBiometricConfigured();
    results['types'] = await getAvailableBiometrics();

    try {
      results['basic'] = await authenticateBasic();
    } catch (e) {
      results['basic'] = 'Error: $e';
    }

    try {
      results['minimal'] = await authenticateMinimal();
    } catch (e) {
      results['minimal'] = 'Error: $e';
    }

    try {
      results['samsung'] = await authenticateSamsung();
    } catch (e) {
      results['samsung'] = 'Error: $e';
    }

    return results;
  }
}