

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../core/constants/app_strings.dart';
import '../widgets/pin_entry_field.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _newPin = '';
  bool _showPinChange = false;

  void _showChangePinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.changePin),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PinEntryField(
                pinLength: 4,
                onPinChanged: (pin) {
                  _newPin = pin;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              if (_newPin.isEmpty || _newPin.length != 4) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a 4-digit PIN')),
                );
                return;
              }

              context.read<AuthViewModel>().setPin(_newPin);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text(AppStrings.pinSet)),
              );
            },
            child: const Text(AppStrings.save),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settings),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text(AppStrings.changePin),
            subtitle: const Text('Update your PIN'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: _showChangePinDialog,
          ),
          const Divider(),

          Consumer<AuthViewModel>(
            builder: (context, authViewModel, _) {
              String themeName = '';
              switch (authViewModel.themeMode) {
                case ThemeMode.system:
                  themeName = 'System Default';
                  break;
                case ThemeMode.light:
                  themeName = 'Light';
                  break;
                case ThemeMode.dark:
                  themeName = 'Dark';
                  break;
              }

              return ListTile(
                title: const Text(AppStrings.theme),
                subtitle: Text('Current: $themeName'),
                trailing: const Icon(Icons.palette_outlined),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Select Theme'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RadioListTile<ThemeMode>(
                            title: const Text('System Default'),
                            value: ThemeMode.system,
                            groupValue: authViewModel.themeMode,
                            onChanged: (mode) {
                              authViewModel.setThemeMode(mode!);
                              Navigator.pop(context);
                            },
                          ),
                          RadioListTile<ThemeMode>(
                            title: const Text('Light'),
                            value: ThemeMode.light,
                            groupValue: authViewModel.themeMode,
                            onChanged: (mode) {
                              authViewModel.setThemeMode(mode!);
                              Navigator.pop(context);
                            },
                          ),
                          RadioListTile<ThemeMode>(
                            title: const Text('Dark'),
                            value: ThemeMode.dark,
                            groupValue: authViewModel.themeMode,
                            onChanged: (mode) {
                              authViewModel.setThemeMode(mode!);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          const Divider(),

          ListTile(
            title: const Text('Logout'),
            subtitle: const Text('Sign out from the app'),
            trailing: const Icon(Icons.logout),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text(
                      'Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(AppStrings.cancel),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<AuthViewModel>().logout();
                        Navigator.pop(context);
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.about,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  AppStrings.appTitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  AppStrings.appVersion,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
