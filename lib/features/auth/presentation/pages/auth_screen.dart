import 'package:flutter/material.dart';
import 'package:foodrescue/core/theme/app_theme.dart';
import 'package:foodrescue/features/auth/presentation/widgets/app_logo_header.dart';
import 'package:foodrescue/features/auth/presentation/widgets/login_form.dart';
import 'package:foodrescue/features/auth/presentation/widgets/role_selection.dart';

class AuthScreen extends StatefulWidget {
  final int initialTabIndex;

  const AuthScreen({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _switchToTab(int index) {
    _tabController.animateTo(index);
  }

  Widget _buildSegmentedTabItem({
    required String label,
    required int index,
  }) {
    final isSelected = _tabController.index == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => _switchToTab(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: AppTheme.headingFontFamily,
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected
                  ? AppTheme.primaryColor
                  : const Color(0xFF64748B),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            // Reusable Logo & Tagline Header
            const AppLogoHeader(
              logoHeight: 60,
              spacingAfterLogo: 8,
              spacingAfterTagline: 16,
            ),

            // Segmented Tab Masuk / Daftar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    _buildSegmentedTabItem(label: 'Masuk', index: 0),
                    _buildSegmentedTabItem(label: 'Daftar', index: 1),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Tab View Contents
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  LoginForm(
                    onSwitchToRegister: () => _switchToTab(1),
                  ),
                  RoleSelection(
                    onSwitchToLogin: () => _switchToTab(0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
