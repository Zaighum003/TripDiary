

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_colors.dart';
import '../widgets/pin_entry_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _pin = '';
  bool _showPinSetup = false;
  String _tempPin = '';
  final TextEditingController _pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _checkBiometricAvailability() async {
    final authViewModel = context.read<AuthViewModel>();
    if (authViewModel.isPinSet) {
      final isBiometricAvailable = await authViewModel.isBiometricAvailable();
      if (isBiometricAvailable && mounted) {
        // Auto-trigger biometric
        await _tryBiometricAuth();
      }
    }
  }

  Future<void> _tryBiometricAuth() async {
    final authViewModel = context.read<AuthViewModel>();
    final success = await authViewModel.tryBiometricAuth();
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Biometric authentication failed')),
      );
    }
  }

  Future<void> _verifyPin() async {
    if (_pin.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.enterPin)),
      );
      return;
    }

    final authViewModel = context.read<AuthViewModel>();
    final success = await authViewModel.verifyPin(_pin);

    if (!success) {
      if (authViewModel.isLocked) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.pinLocked)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppStrings.pinError} (${3 - authViewModel.failedAttempts} attempts left)',
            ),
          ),
        );
      }
      setState(() {
        _pin = '';
        _pinController.clear();
      });
    }
  }

  void _setupPin() {
    if (!_showPinSetup) {
      setState(() {
        _showPinSetup = true;
        _pinController.clear();
      });
      return;
    }

    if (_tempPin == _pin) {
      context.read<AuthViewModel>().setPin(_pin);
      setState(() {
        _pin = '';
        _tempPin = '';
        _showPinSetup = false;
        _pinController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.pinSet)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.pinMismatch)),
      );
      setState(() {
        _pin = '';
        _tempPin = '';
        _pinController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, 
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.appTitle),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                Icon(
                  Icons.travel_explore,
                  size: 80,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 24),

                Text(
                  AppStrings.appName,
                  style: Theme.of(context).textTheme.displayMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                Text(
                  'Your Travel Journal',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                Consumer<AuthViewModel>(
                  builder: (context, authViewModel, _) {
                    if (!authViewModel.isPinSet) {
                      return Column(
                        children: [
                          Text(
                            _showPinSetup
                                ? AppStrings.confirmPin
                                : AppStrings.newPin,
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          PinEntryField(
                            controller: _pinController,
                            pinLength: 4,
                            onPinChanged: (pin) {

                              setState(() {
                                if (!_showPinSetup) {
                                  _pin = pin;
                                } else {
                                  _tempPin = pin;
                                }
                              });
                            },
                            onSubmit: _setupPin,
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _setupPin,
                              child: Text(
                                _showPinSetup ? AppStrings.save : AppStrings.save,
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    return Column(
                      children: [
                        Text(
                          AppStrings.enterPin,
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        PinEntryField(
                          controller: _pinController,
                          pinLength: 4,
                          onPinChanged: (pin) {
                            setState(() => _pin = pin);
                          },
                          onSubmit: _verifyPin,
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: authViewModel.isLocked
                                ? null
                                : _verifyPin,
                            child: const Text(AppStrings.login),
                          ),
                        ),
                        const SizedBox(height: 16),

                        if (authViewModel.isPinSet)
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: _tryBiometricAuth,
                              icon: const Icon(Icons.fingerprint),
                              label: const Text(AppStrings.biometricAuth),
                            ),
                          ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 24),

                Consumer<AuthViewModel>(
                  builder: (context, authViewModel, _) {
                    if (authViewModel.failedAttempts > 0 &&
                        !authViewModel.isLocked) {
                      return Text(
                        '${3 - authViewModel.failedAttempts} attempts remaining',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.error,
                            ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
