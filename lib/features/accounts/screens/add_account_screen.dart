// File: lib/features/accounts/screens/add_account_screen.dart
// Purpose: Add new account screen

import 'package:flutter/material.dart';
import '../../../core/constants/strings/app_strings.dart';

class AddAccountScreen extends StatelessWidget {
  const AddAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.addNewAccount),
      ),
      body: const Center(
        child: Text('Add Account Screen - Coming Soon'),
      ),
    );
  }
}
