import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:trip_diary/viewmodels/auth_viewmodel.dart';
import 'package:trip_diary/core/constants/app_constants.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel secureStorageChannel = MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
  const MethodChannel localAuthChannel = MethodChannel('plugins.flutter.io/local_auth');

  final Map<String, String> mockStorage = {};

  setUp(() {
    mockStorage.clear();

    TestWidgetsFlutterBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(secureStorageChannel, (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'read':
          return mockStorage[methodCall.arguments['key']];
        case 'write':
          mockStorage[methodCall.arguments['key']] = methodCall.arguments['value'];
          return null;
        case 'delete':
          mockStorage.remove(methodCall.arguments['key']);
          return null;
        case 'containsKey':
          return mockStorage.containsKey(methodCall.arguments['key']);
        default:
          return null;
      }
    });

    TestWidgetsFlutterBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(localAuthChannel, (MethodCall methodCall) async {
      print('Mock LocalAuth call: ${methodCall.method}');
      switch (methodCall.method) {
        case 'canCheckBiometrics':
          return true;
        case 'isDeviceSupported':
          return true;
        case 'authenticate':
          return true;
        case 'getAvailableBiometrics':
          return <String>['fingerprint', 'face', 'iris'];
        default:
          return null;
      }
    });
  });

  group('AuthViewModel Unit Tests', () {
    test('Initial state: isAuthenticated should be false', () {
      final authViewModel = AuthViewModel();
      expect(authViewModel.isAuthenticated, isFalse);
    });

    test('setPin should save PIN and update isPinSet', () async {
      final authViewModel = AuthViewModel();
      final success = await authViewModel.setPin('1234');
      
      expect(success, isTrue);
      expect(authViewModel.isPinSet, isTrue);
      expect(mockStorage['user_pin'], '1234');
    });

    test('verifyPin should return true for correct PIN and update isAuthenticated', () async {
      final authViewModel = AuthViewModel();
      await authViewModel.setPin('1234');
      
      final result = await authViewModel.verifyPin('1234');
      
      expect(result, isTrue);
      expect(authViewModel.isAuthenticated, isTrue);
      expect(authViewModel.failedAttempts, 0);
    });

    test('verifyPin should return false for incorrect PIN and increment failedAttempts', () async {
      final authViewModel = AuthViewModel();
      await authViewModel.setPin('1234');
      
      final result = await authViewModel.verifyPin('0000');
      
      expect(result, isFalse);
      expect(authViewModel.isAuthenticated, isFalse);
      expect(authViewModel.failedAttempts, 1);
    });

    test('App should lock after max failed attempts', () async {
      final authViewModel = AuthViewModel();
      await authViewModel.setPin('1234');
      
      // Simulate multiple failed attempts
      for (int i = 0; i < AppConstants.maxFailedAttempts; i++) {
        await authViewModel.verifyPin('0000');
      }
      
      expect(authViewModel.failedAttempts, AppConstants.maxFailedAttempts);
      expect(authViewModel.isLocked, isTrue);
      
      // Try correct PIN while locked
      final result = await authViewModel.verifyPin('1234');
      expect(result, isFalse);
      expect(authViewModel.isAuthenticated, isFalse);
    });

    test('logout should reset isAuthenticated', () async {
      final authViewModel = AuthViewModel();
      await authViewModel.setPin('1234');
      await authViewModel.verifyPin('1234');
      expect(authViewModel.isAuthenticated, isTrue);
      
      authViewModel.logout();
      expect(authViewModel.isAuthenticated, isFalse);
    });

    test('tryBiometricAuth should authenticate on success', () async {
      final authViewModel = AuthViewModel();
      final success = await authViewModel.tryBiometricAuth();
      
      expect(success, isTrue);
      expect(authViewModel.isAuthenticated, isTrue);
    });
  });
}
