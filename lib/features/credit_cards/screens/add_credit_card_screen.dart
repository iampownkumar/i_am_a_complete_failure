// File: lib/features/credit_cards/screens/add_credit_card_screen.dart
// Purpose: Add new credit card screen

import 'package:flutter/material.dart';
import '../../../core/constants/strings/app_strings.dart';

class AddCreditCardScreen extends StatelessWidget {
  const AddCreditCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.addNewCreditCard),
      ),
      body: const Center(
        child: Text('Add Credit Card Screen - Coming Soon'),
      ),
    );
  }
}
