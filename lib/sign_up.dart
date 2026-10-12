
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'sign_in.dart';

const String apiBaseUrl = 'http://localhost:3000';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscure = true;
  bool _agreed = false;
  bool _isLoading = false;

  static const Color bg = Color(0xFFFBFAF6);
  static const Color primary = Color(0xFF4A7C59);
  static const Color dark = Color(0xFF355F42);
  static const Color subtitle = Color(0xFF74917C);
  static const Color border = Color(0xFFC5D5CA);
  static const Color disabled = Color(0xFFC8D5B9);
  static const Color error = Color(0xFFC0392B);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? error : primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    if (!_agreed) {
      _showMessage('Please agree to the terms first.', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http
          .post(
            Uri.parse('$apiBaseUrl/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'fullName': _nameController.text.trim(),
              'email': _emailController.text.trim(),
              'password': _passwordController.text,
            }),
          )
          .timeout(const Duration(seconds: 20));

      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        if (!mounted) return;

        _showMessage(
          data['message']?.toString() ??
              'Registration successful. Check your email if confirmation is required.',
        );

        await Future.delayed(const Duration(milliseconds: 800));

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
        );
      } else {
        _showMessage(
          data['message']?.toString() ??
              'Registration failed. Please try again.',
          isError: true,
        );
      }
    } catch (e) {
      _showMessage(
        'Could not connect to the server. Make sure the backend is running.',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),

                        _BackButton(
                          onTap: () => Navigator.maybePop(context),
                        ),

                        const SizedBox(height: 46),

                        const Center(child: _Brand()),

                        const SizedBox(height: 28),

                        const Center(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Create your account',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1.9,
                                color: dark,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        const Center(
                          child: Text(
                            'Keep your prescriptions and medicine searches in one\nsecure place.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.4,
                              color: subtitle,
                            ),
                          ),
                        ),

                        const SizedBox(height: 34),

                        _LabeledField(
                          label: 'Full name',
                          hint: 'Your full name',
                          controller: _nameController,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        _LabeledField(
                          label: 'Email address',
                          hint: 'you@example.com',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            final email = value?.trim() ?? '';

                            if (email.isEmpty) {
                              return 'Please enter your email address';
                            }

                            if (!RegExp(
                              r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                            ).hasMatch(email)) {
                              return 'Please enter a valid email address';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        _LabeledField(
                          label: 'Password',
                          hint: 'At least 8 characters',
                          controller: _passwordController,
                          obscureText: _obscure,
                          textInputAction: TextInputAction.done,
                          suffix: GestureDetector(
                            onTap: () {
                              setState(() => _obscure = !_obscure);
                            },
                            child: Text(
                              _obscure ? 'Show' : 'Hide',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: primary,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }

                            if (value.length < 8) {
                              return 'Password must be at least 8 characters';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        GestureDetector(
                          onTap: () {
                            setState(() => _agreed = !_agreed);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedContainer(
                                duration:
                                    const Duration(milliseconds: 120),
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: _agreed
                                      ? primary
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: _agreed ? primary : border,
                                    width: 1.5,
                                  ),
                                ),
                                child: _agreed
                                    ? const Icon(
                                        Icons.check,
                                        size: 12,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'I agree to the terms',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF789480),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          height: 57,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: _agreed && !_isLoading
                                ? primary
                                : disabled,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: _agreed && !_isLoading
                                ? [
                                    BoxShadow(
                                      color: primary.withValues(alpha: 0.30),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: _isLoading ? null : _submit,
                              child: Center(
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 23,
                                        height: 23,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text(
                                        'Create account',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Already have an account?  ',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: subtitle,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const LoginScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Sign in',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          width: 41,
          height: 41,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFC5D5CA),
              width: 1.5,
            ),
          ),
          child: const Icon(
            Icons.arrow_back_rounded,
            size: 20,
            color: Color(0xFF4A7C59),
          ),
        ),
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            'assets/images/logo.png',
            width: 38,
            height: 38,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'MediTech',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: Color(0xFF4A7C59),
          ),
        ),
      ],
    );
  }
}

class _LabeledField extends StatefulWidget {
  const _LabeledField({
    required this.label,
    required this.hint,
    required this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.suffix,
    this.validator,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Widget? suffix;
  final String? Function(String?)? validator;

  @override
  State<_LabeledField> createState() => _LabeledFieldState();
}

class _LabeledFieldState extends State<_LabeledField> {
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focused = _focus.hasFocus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color(0xFF355F42),
          ),
        ),
        const SizedBox(height: 10),
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 53,
          padding: const EdgeInsets.symmetric(horizontal: 17),
          decoration: BoxDecoration(
            color: focused ? Colors.white : const Color(0xFFFBFAF6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: focused
                  ? const Color(0xFFC5D5CA)
                  : Colors.transparent,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4A7C59).withValues(
                  alpha: focused ? 0.14 : 0.10,
                ),
                blurRadius: 16,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: widget.controller,
                  focusNode: _focus,
                  obscureText: widget.obscureText,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  cursorColor: const Color(0xFF4A7C59),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF355F42),
                  ),
                  validator: widget.validator,
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFB0BFB1),
                    ),
                    border: InputBorder.none,
                    isCollapsed: true,
                    errorStyle: const TextStyle(
                      fontSize: 10,
                      height: 0.1,
                    ),
                  ),
                ),
              ),
              if (widget.suffix != null) widget.suffix!,
            ],
          ),
        ),
      ],
    );
  }
}
