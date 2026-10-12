import 'package:flutter/material.dart';

import 'sign_up.dart';
import 'sign_in.dart';

void main() {
  runApp(const MyApp());
}

class AppColors {
  static const Color primary = Color(0xFF4A7C59);
  static const Color dark = Color(0xFF355F42);
  static const Color subtitle = Color(0xFF6E8C77);
  static const Color muted = Color(0xFF76927E);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MediTech',
      theme: ThemeData(
        fontFamily: 'Inter',
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
        ),
      ),
      home: const LandingScreen(),
    );
  }
}

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isSmall = constraints.maxWidth < 360;
            final horizontalPadding =
                constraints.maxWidth < 400 ? 20.0 : 32.0;

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        SizedBox(height: isSmall ? 28 : 56),
                        const _BrandHeader(),
                        SizedBox(height: isSmall ? 36 : 48),
                        const _HeroTitle(),
                        SizedBox(height: isSmall ? 28 : 44),
                        const Text(
                          'Search, compare, and manage your prescriptions\nwith confidence.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.25,
                            fontWeight: FontWeight.w400,
                            color: AppColors.subtitle,
                          ),
                        ),
                        const Spacer(),
                        const SizedBox(height: 40),
                        _PrimaryButton(
                          label: 'Get started',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SignUpScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        _SignInPrompt(
                          onSignIn: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 28),
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

class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            'assets/images/logo.png',
            width: 41,
            height: 41,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 10),
        const Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'MediTech',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.dark,
                letterSpacing: -0.3,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroTitle extends StatelessWidget {
  const _HeroTitle();

  @override
  Widget build(BuildContext context) {
    return const FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        "Let's make\nfinding medicine\neasier",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 46,
          height: 1.24,
          fontWeight: FontWeight.w900,
          letterSpacing: -2.8,
          color: AppColors.dark,
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.30),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onPressed,
          child: SizedBox(
            height: 57,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const Positioned(
                  right: 24,
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SignInPrompt extends StatelessWidget {
  const _SignInPrompt({
    required this.onSignIn,
  });

  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 4,
      children: [
        const Text(
          'Already have an account?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: AppColors.muted,
          ),
        ),
        GestureDetector(
          onTap: onSignIn,
          behavior: HitTestBehavior.opaque,
          child: const Text(
            'Sign in',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
