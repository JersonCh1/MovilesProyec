import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class SecurityService {
  static final SecurityService instance = SecurityService._internal();
  SecurityService._internal();

  static const String _keyBiometricEnabled = 'biometric_enabled';
  static const String _keyAppLockEnabled = 'app_lock_enabled';
  static const String _keyCustomPin = 'custom_pin';
  static const String _keyAutoLockTime = 'auto_lock_time';
  static const String _keyLastUnlockTime = 'last_unlock_time';

  /// Verificar si la autenticación biométrica está habilitada
  Future<bool> isBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyBiometricEnabled) ?? false;
  }

  /// Habilitar/deshabilitar autenticación biométrica
  Future<void> setBiometricEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyBiometricEnabled, enabled);
  }

  /// Verificar si el bloqueo de app está habilitado
  Future<bool> isAppLockEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyAppLockEnabled) ?? false;
  }

  /// Habilitar/deshabilitar bloqueo de app
  Future<void> setAppLockEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAppLockEnabled, enabled);
  }

  /// Configurar PIN personalizado
  Future<void> setCustomPin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    final hashedPin = _hashPin(pin);
    await prefs.setString(_keyCustomPin, hashedPin);
  }

  /// Verificar PIN personalizado
  Future<bool> verifyPin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    final storedHash = prefs.getString(_keyCustomPin);
    if (storedHash == null) return false;

    final hashedPin = _hashPin(pin);
    return hashedPin == storedHash;
  }

  /// Verificar si hay PIN configurado
  Future<bool> hasPinConfigured() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyCustomPin) != null;
  }

  /// Configurar tiempo de auto-bloqueo (en minutos)
  Future<void> setAutoLockTime(int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyAutoLockTime, minutes);
  }

  /// Obtener tiempo de auto-bloqueo
  Future<int> getAutoLockTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyAutoLockTime) ?? 5; // 5 minutos por defecto
  }

  /// Registrar último tiempo de desbloqueo
  Future<void> updateLastUnlockTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyLastUnlockTime, DateTime.now().millisecondsSinceEpoch);
  }

  /// Verificar si la app debe estar bloqueada
  Future<bool> shouldLockApp() async {
    final prefs = await SharedPreferences.getInstance();
    final isLockEnabled = await isAppLockEnabled();

    if (!isLockEnabled) return false;

    final lastUnlock = prefs.getInt(_keyLastUnlockTime);
    if (lastUnlock == null) return true;

    final autoLockMinutes = await getAutoLockTime();
    final timeDifference = DateTime.now().millisecondsSinceEpoch - lastUnlock;
    final minutesPassed = timeDifference / (1000 * 60);

    return minutesPassed >= autoLockMinutes;
  }

  /// Hash del PIN para seguridad
  String _hashPin(String pin) {
    final bytes = utf8.encode(pin + 'easynotes_salt');
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Limpiar todas las configuraciones de seguridad
  Future<void> clearSecuritySettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyBiometricEnabled);
    await prefs.remove(_keyAppLockEnabled);
    await prefs.remove(_keyCustomPin);
    await prefs.remove(_keyAutoLockTime);
    await prefs.remove(_keyLastUnlockTime);
  }
}