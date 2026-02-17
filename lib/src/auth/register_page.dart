/// SPDX-License-Identifier: Apache-2.0
/// Copyright (c) 2026 The Khatu Family Trust
/// ---------------------------------------------------------------------------
/// lib/src/auth/register_page.dart
/// ---------------------------------------------------------------------------
///
/// Purpose:
/// - Provides account registration with password policy enforcement.
/// Architecture:
/// - Authentication abstraction layer with pluggable providers.
/// File Version: 1.0.0
/// Framework : Core App Tech Utilities (Catu) Framework
/// Author: Neil Khatu
///

library;

import 'package:flutter/material.dart';

import '../app_state/app_state.dart';
import '../routing/app_routes.dart';
import 'password_policy.dart';
import 'password_rules_text.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.appState});

  final AppState appState;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  bool _busy = false;
  bool _acceptedTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Accept terms and privacy policy first.')),
      );
      return;
    }

    setState(() => _busy = true);

    final displayName = '${_firstName.text.trim()} ${_lastName.text.trim()}'
        .trim();
    final ok = await widget.appState.register(
      email: _email.text,
      password: _password.text,
      displayName: displayName,
    );

    if (!mounted) return;
    setState(() => _busy = false);

    if (ok) {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (_) => false);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.appState.signInError ?? 'Registration failed'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _firstName,
                    decoration: const InputDecoration(labelText: 'First Name'),
                    textInputAction: TextInputAction.next,
                    validator: (v) => (v ?? '').trim().isEmpty
                        ? 'First name is required'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _lastName,
                    decoration: const InputDecoration(labelText: 'Last Name'),
                    textInputAction: TextInputAction.next,
                    validator: (v) => (v ?? '').trim().isEmpty
                        ? 'Last name is required'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _email,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (v) {
                      final value = (v ?? '').trim();
                      if (value.isEmpty) return 'Email is required';
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _password,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        tooltip: _obscurePassword
                            ? 'Show password'
                            : 'Hide password',
                      ),
                    ),
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.next,
                    validator: PasswordPolicy.validate,
                  ),
                  const PasswordRulesText(),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _confirmPassword,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      suffixIcon: IconButton(
                        onPressed: () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                        icon: Icon(
                          _obscureConfirm
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        tooltip: _obscureConfirm
                            ? 'Show password'
                            : 'Hide password',
                      ),
                    ),
                    obscureText: _obscureConfirm,
                    textInputAction: TextInputAction.done,
                    validator: (v) => PasswordPolicy.validateConfirmation(
                      password: _password.text,
                      confirm: v ?? '',
                    ),
                    onFieldSubmitted: (_) => _busy ? null : _register(),
                  ),
                  const SizedBox(height: 12),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _acceptedTerms,
                    onChanged: _busy
                        ? null
                        : (v) => setState(() => _acceptedTerms = v ?? false),
                    title: const Text(
                      'I accept Terms of Use and Privacy Policy.',
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: _busy ? null : _register,
                    child: Text(
                      _busy ? 'Creating account...' : 'Create account',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _busy
                        ? null
                        : () {
                            Navigator.pop(context);
                          },
                    child: const Text('Already have an account? Sign in'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
