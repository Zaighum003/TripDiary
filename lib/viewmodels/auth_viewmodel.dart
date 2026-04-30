

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import '../core/constants/app_constants.dart';

class AuthViewModel extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isPinSet = false;
  int _failedAttempts = 0;
  DateTime? _lockedUntil;

  final _secureStorage = const FlutterSecureStorage();
  final _localAuth = LocalAuthentication();
  ThemeMode _themeMode = ThemeMode.system;

  bool get isAuthenticated => _isAuthenticated;
  bool get isPinSet => _isPinSet;
  int get failedAttempts => _failedAttempts;
  ThemeMode get themeMode => _themeMode;
  bool get isLocked => _lockedUntil != null && DateTime.now().isBefore(_lockedUntil!);

  AuthViewModel() {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final storedPin = await _secureStorage.read(key: 'user_pin');
      _isPinSet = storedPin != null;

      final storedTheme = await _secureStorage.read(key: 'theme_mode');
      if (storedTheme != null) {
        _themeMode = ThemeMode.values.firstWhere(
          (m) => m.toString() == storedTheme,
          orElse: () => ThemeMode.system,
        );
      }

      notifyListeners();
    } catch (e) {
      print('Error initializing auth: $e');
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    try {
      _themeMode = mode;
      await _secureStorage.write(key: 'theme_mode', value: mode.toString());
      notifyListeners();
    } catch (e) {
      print('Error saving theme mode: $e');
    }
  }

  Future<bool> setPin(String pin) async {
    try {
      if (pin.length != AppConstants.pinLength) {
        return false;
      }
      await _secureStorage.write(key: 'user_pin', value: pin);
      _isPinSet = true;
      notifyListeners();
      return true;
    } catch (e) {
      print('Error setting pin: $e');
      return false;
    }
  }

  Future<bool> verifyPin(String pin) async {
    try {
      if (isLocked) {
        print('App is locked due to too many failed attempts');
        return false;
      }

      final storedPin = await _secureStorage.read(key: 'user_pin');
      if (storedPin == null) {
        return false;
      }

      if (pin == storedPin) {
        _isAuthenticated = true;
        _failedAttempts = 0;
        _lockedUntil = null;
        notifyListeners();
        return true;
      } else {
        _failedAttempts++;
        if (_failedAttempts >= AppConstants.maxFailedAttempts) {
          _lockedUntil = DateTime.now().add(
            Duration(seconds: AppConstants.lockoutDurationSeconds),
          );
        }
        notifyListeners();
        return false;
      }
    } catch (e) {
      print('Error verifying pin: $e');
      return false;
    }
  }

  Future<bool> tryBiometricAuth() async {
    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();

      if (!isAvailable || !isDeviceSupported) {
        return false;
      }

      final isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to access your diary',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (isAuthenticated) {
        _isAuthenticated = true;
        _failedAttempts = 0;
        _lockedUntil = null;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Error with biometric auth: $e');
      return false;
    }
  }

  void logout() {
    _isAuthenticated = false;
    _failedAttempts = 0;
    _lockedUntil = null;
    notifyListeners();
  }

  void lockApp() {
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<bool> isBiometricAvailable() async {
    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      return isAvailable && isDeviceSupported;
    } catch (e) {
      return false;
    }
  }

  void resetFailedAttempts() {
    _failedAttempts = 0;
    _lockedUntil = null;
    notifyListeners();
  }
}
