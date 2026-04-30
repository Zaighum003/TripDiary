// AI Transparency Declaration: AITS Level 1 - No AI Used
// This code is 100% student-authored

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../screens/login_screen.dart';

class AuthGate extends StatelessWidget {
  final Widget child;

  const AuthGate({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, _) {
        if (!authViewModel.isAuthenticated) {
          return const LoginScreen();
        }
        return child;
      },
    );
  }
}
