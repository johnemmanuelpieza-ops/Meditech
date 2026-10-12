
import 'package:flutter/material.dart';

/// MediTech dashboard screen.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    super.key,
    this.userName = '',
  });

  final String userName;

  static const Color _background = Color(0xFFF8F8F3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeader(userName: userName),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Nearby pharmacies',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F1F1F),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Find available medicines at pharmacies near you.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: Color(0xFF5E5E5E),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Green header with greeting, notification bell and search field.
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    this.userName = '',
    this.onBellTap,
    this.onSearchChanged,
    this.onSearchTap,
  });

  final String userName;
  final VoidCallback? onBellTap;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onSearchTap;

  static const Color _green = Color(0xFF2F6B3F);
  static const Color _bellBg = Color(0xFF45784F);

  @override
  Widget build(BuildContext context) {
    final name = userName.trim();

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: _green,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(48),
          bottomRight: Radius.circular(48),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name.isEmpty ? 'Good day' : 'Good day, $name',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Find medicine near you',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Material(
                    color: _bellBg,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: onBellTap,
                      child: const SizedBox(
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.notifications_none_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 17),
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search_rounded,
                      size: 20,
                      color: Color(0xFF1F1F1F),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        onChanged: onSearchChanged,
                        onTap: onSearchTap,
                        textAlignVertical: TextAlignVertical.center,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: Color(0xFF1F1F1F),
                        ),
                        decoration: const InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          hintText: 'Search medicine...',
                          hintStyle: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: Color(0xFF5E5E5E),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
