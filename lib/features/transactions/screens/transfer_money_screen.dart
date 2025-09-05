// File: lib/features/transactions/screens/transfer_money_screen.dart
// Purpose: Transfer money between accounts screen

import 'package:flutter/material.dart';
import '../../../core/constants/strings/app_strings.dart';

class TransferMoneyScreen extends StatelessWidget {
  const TransferMoneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.transferMoney),
      ),
      body: const Center(
        child: Text('Transfer Money Screen - Coming Soon'),
      ),
    );
  }
}
