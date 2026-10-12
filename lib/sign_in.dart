
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dashboard.dart';
import 'sign_up.dart';

const String loginApiBaseUrl = 'http://localhost:3000';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscure = true;
  bool _remember = false;
  bool _submitted = false;
  bool _isLoading = false;

  String? get _emailError {
    if (!_submitted) return null;
    final email = _emailController.text.trim();
    if (email.isEmpty) return 'Please enter your email address';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? get _passwordError =>
      _submitted && _passwordController.text.isEmpty
          ? 'Please enter your password'
          : null;

  @override
  void initState() {
    super.initState();
    for (final c in [_emailController, _passwordController]) {
      c.addListener(_handleFieldChange);
    }
  }

  void _handleFieldChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: _C.error,
        ),
      );
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    setState(() => _submitted = true);

    if (_emailError != null || _passwordError != null || _isLoading) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http
          .post(
            Uri.parse('$loginApiBaseUrl/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': _emailController.text.trim(),
              'password': _passwordController.text,
            }),
          )
          .timeout(const Duration(seconds: 20));

      dynamic decoded;

      try {
        decoded = jsonDecode(response.body);
      } catch (_) {
        decoded = <String, dynamic>{};
      }

      final data = decoded is Map<String, dynamic>
          ? decoded
          : <String, dynamic>{};

      if (!mounted) return;

      if (response.statusCode < 200 || response.statusCode >= 300) {
        _showError(
          data['message']?.toString() ??
              data['error']?.toString() ??
              'Sign in failed. Please check your email and password.',
        );
        return;
      }

      final token = data['access_token']?.toString() ?? '';
      final user = data['user'];

      String fullName = '';

      if (user is Map<String, dynamic>) {
        fullName = (user['full_name'] ??
                user['fullName'] ??
                user['name'] ??
                '')
            .toString()
            .trim();
      }

      if (fullName.isEmpty && token.isNotEmpty) {
        try {
          final profileResponse = await http
              .get(
                Uri.parse('$loginApiBaseUrl/profile'),
                headers: {
                  'Authorization': 'Bearer $token',
                  'Content-Type': 'application/json',
                },
              )
              .timeout(const Duration(seconds: 15));

          if (profileResponse.statusCode == 200) {
            final profileDecoded = jsonDecode(profileResponse.body);

            if (profileDecoded is Map<String, dynamic>) {
              final profile = profileDecoded['profile'];

              if (profile is Map<String, dynamic>) {
                fullName = (profile['full_name'] ??
                        profile['fullName'] ??
                        profile['name'] ??
                        '')
                    .toString()
                    .trim();
              } else {
                fullName = (profileDecoded['full_name'] ??
                        profileDecoded['fullName'] ??
                        profileDecoded['name'] ??
                        '')
                    .toString()
                    .trim();
              }
            }
          }
        } catch (_) {
          // Continue to the dashboard if profile lookup fails.
        }
      }

      if (fullName.isEmpty) {
        fullName = _emailController.text.trim().split('@').first;
      }

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => DashboardScreen(userName: fullName),
        ),
      );
    } on http.ClientException {
      _showError(
        'Could not connect to the server. Check your backend connection.',
      );
    } catch (_) {
      _showError(
        'Unable to sign in. Please check your connection and try again.',
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _forgotPassword() {
    _showError('Password recovery is not connected yet.');
  }

  @override
  Widget build(BuildContext context) {
    return _AuthPage(
      title: 'Welcome back',
      subtitle: 'Sign in to continue managing your medicines.',
      children: [
        _LabeledField(
          label: 'Email address',
          hint: 'you@example.com',
          height: 57,
          controller: _emailController,
          errorText: _emailError,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 15),
        _LabeledField(
          label: 'Password',
          hint: 'Enter your password',
          height: 57,
          controller: _passwordController,
          errorText: _passwordError,
          obscureText: _obscure,
          textInputAction: TextInputAction.done,
          suffix: _ShowToggle(
            obscured: _obscure,
            onTap: () => setState(() => _obscure = !_obscure),
          ),
        ),
        const SizedBox(height: 13),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _CheckRow(
              value: _remember,
              label: 'Remember me',
              onChanged: (v) => setState(() => _remember = v),
            ),
            GestureDetector(
              onTap: _forgotPassword,
              behavior: HitTestBehavior.opaque,
              child: const Text(
                'Forgot password?',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: _C.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        _SubmitButton(
          label: _isLoading ? 'Signing in...' : 'Sign in',
          enabled: !_isLoading,
          onPressed: _submit,
        ),
        const SizedBox(height: 14),
        _SwitchPrompt(
          question: 'New to MediTech?',
          action: 'Create an account',
          onTap: () {
            if (_isLoading) return;

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const SignUpScreen(),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _C {
  static const Color bg = Color(0xFFFBFAF6);
  static const Color primary = Color(0xFF4A7C59);
  static const Color dark = Color(0xFF355F42);
  static const Color subtitle = Color(0xFF74917C);
  static const Color hint = Color(0xFFB0BFB1);
  static const Color border = Color(0xFFC5D5CA);
  static const Color terms = Color(0xFF789480);
  static const Color footer = Color(0xFF9CB0A0);
  static const Color disabled = Color(0xFFC8D5B9);
  static const Color error = Color(0xFFC0392B);
}

// ignore: unused_element
void _showToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.fromLTRB(32, 0, 32, 32),
        duration: const Duration(seconds: 3),
        content: Container(
          height: 48,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                size: 22,
                color: _C.primary,
              ),
              const SizedBox(width: 12),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: _C.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
            border: Border.all(color: _C.border, width: 1.5),
          ),
          child: const Icon(
            Icons.arrow_back_rounded,
            size: 20,
            color: _C.primary,
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
            color: _C.primary,
          ),
        ),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  const _Title(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.w900,
            letterSpacing: -1.9,
            color: _C.dark,
          ),
        ),
      ),
    );
  }
}

class _LabeledField extends StatefulWidget {
  const _LabeledField({
    required this.label,
    required this.hint,
    required this.controller,
    this.height = 53,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.suffix,
    this.errorText,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final double height;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Widget? suffix;
  final String? errorText;

  @override
  State<_LabeledField> createState() => _LabeledFieldState();
}

class _LabeledFieldState extends State<_LabeledField> {
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _focus.removeListener(_handleFocusChange);
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focused = _focus.hasFocus;
    final hasError = widget.errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: _C.dark,
          ),
        ),
        const SizedBox(height: 10),
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: widget.height,
          padding: const EdgeInsets.symmetric(horizontal: 17),
          decoration: BoxDecoration(
            color: focused ? Colors.white : _C.bg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: hasError
                  ? _C.error
                  : (focused ? _C.border : Colors.transparent),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: _C.primary.withValues(
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
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focus,
                  obscureText: widget.obscureText,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  onSubmitted: (_) {
                    if (widget.textInputAction == TextInputAction.done) {
                      FocusScope.of(context).unfocus();
                    }
                  },
                  cursorColor: _C.primary,
                  style: const TextStyle(
                    fontSize: 14,
                    color: _C.dark,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: _C.hint,
                    ),
                    border: InputBorder.none,
                    isCollapsed: true,
                  ),
                ),
              ),
              if (widget.suffix != null) widget.suffix!,
            ],
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              widget.errorText!,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: _C.error,
              ),
            ),
          ),
      ],
    );
  }
}

class _ShowToggle extends StatelessWidget {
  const _ShowToggle({
    required this.obscured,
    required this.onTap,
  });

  final bool obscured;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Text(
        obscured ? 'Show' : 'Hide',
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: _C.primary,
        ),
      ),
    );
  }
}

class _CheckRow extends StatelessWidget {
  const _CheckRow({
    required this.value,
    required this.label,
    required this.onChanged,
  });

  final bool value;
  final String label;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: value ? _C.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: value ? _C.primary : _C.border,
                width: 1.5,
              ),
            ),
            child: value
                ? const Icon(Icons.check, size: 12, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: _C.terms,
            ),
          ),
        ],
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.label,
    required this.enabled,
    required this.onPressed,
  });

  final String label;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      height: 57,
      width: double.infinity,
      decoration: BoxDecoration(
        color: enabled ? _C.primary : _C.disabled,
        borderRadius: BorderRadius.circular(20),
        boxShadow: enabled
            ? [
                BoxShadow(
                  color: _C.primary.withValues(alpha: 0.30),
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
          onTap: enabled ? onPressed : null,
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SwitchPrompt extends StatelessWidget {
  const _SwitchPrompt({
    required this.question,
    required this.action,
    required this.onTap,
  });

  final String question;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$question  ',
            style: const TextStyle(
              fontSize: 12,
              color: _C.subtitle,
            ),
          ),
          GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: Text(
              action,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: _C.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthPage extends StatelessWidget {
  const _AuthPage({
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.bg,
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
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
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
                        _Title(title),
                        const SizedBox(height: 16),
                        Center(
                          child: Text(
                            subtitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13,
                              height: 1.4,
                              color: _C.subtitle,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...children,
                        const Spacer(),
                        const Padding(
                          padding: EdgeInsets.only(top: 24, bottom: 24),
                          child: Center(
                            child: Text(
                              'Your health information stays private and protected.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10,
                                color: _C.footer,
                              ),
                            ),
                          ),
                        ),
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
