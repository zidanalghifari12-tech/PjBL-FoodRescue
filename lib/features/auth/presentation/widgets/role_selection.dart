import 'package:flutter/material.dart';
import 'package:foodrescue/core/theme/app_theme.dart';
import 'package:foodrescue/features/auth/presentation/pages/buyer_register_screen.dart';

enum UserRole { buyer, seller }

class RoleSelection extends StatefulWidget {
  final VoidCallback onSwitchToLogin;

  const RoleSelection({
    super.key,
    required this.onSwitchToLogin,
  });

  @override
  State<RoleSelection> createState() => _RoleSelectionState();
}

class _RoleSelectionState extends State<RoleSelection> {
  UserRole _selectedRole = UserRole.buyer;

  void _handleRegister() {
    if (_selectedRole == UserRole.buyer) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const BuyerRegisterScreen(),
        ),
      );
      return;
    }

    final roleName =
        _selectedRole == UserRole.buyer ? 'Pembeli' : 'Penjual';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Simulasi: Melanjutkan formulir pendaftaran sebagai $roleName!',
          style: const TextStyle(fontFamily: AppTheme.bodyFontFamily),
        ),
        backgroundColor: AppTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildRoleCard({
    required UserRole role,
    required String title,
    required String description,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
  }) {
    final isSelected = _selectedRole == role;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedRole = role;
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0FDF4) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryColor
                : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: AppTheme.headingFontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.neutralColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontFamily: AppTheme.bodyFontFamily,
                      fontSize: 12.5,
                      color: Color(0xFF64748B),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Radio<UserRole>(
              value: role,
              activeColor: AppTheme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isBuyer = _selectedRole == UserRole.buyer;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: RadioGroup<UserRole>(
        groupValue: _selectedRole,
        onChanged: (UserRole? value) {
          if (value != null) {
            setState(() {
              _selectedRole = value;
            });
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Judul & Deskripsi
            Center(
              child: Text(
                'Daftar Sebagai Apa di FoodRescue?',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontFamily: AppTheme.headingFontFamily,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.neutralColor,
                      fontSize: 20,
                    ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Pilih peran Anda untuk mulai menyelamatkan pangan dan berpartisipasi dalam gerakan pangan berkelanjutan.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontFamily: AppTheme.bodyFontFamily,
                      color: const Color(0xFF64748B),
                      height: 1.4,
                    ),
              ),
            ),
            const SizedBox(height: 24),

            // Pilihan Pembeli
            _buildRoleCard(
              role: UserRole.buyer,
              title: 'Pembeli',
              description:
                  'Selamatkan makanan lezat berlebih dari merchant terdekat dengan potongan harga hingga 70%.',
              icon: Icons.shopping_bag_outlined,
              iconColor: AppTheme.primaryColor,
              iconBgColor: const Color(0xFFD1FAE5),
            ),
            const SizedBox(height: 14),

            // Pilihan Penjual
            _buildRoleCard(
              role: UserRole.seller,
              title: 'Penjual',
              description:
                  'Jual surplus produk berkualitas Anda, tekan potensi food waste, dan tingkatkan pendapatan usaha.',
              icon: Icons.storefront_outlined,
              iconColor: AppTheme.tertiaryColor,
              iconBgColor: const Color(0xFFFEF3C7),
            ),
            const SizedBox(height: 24),

            // Tombol Pendaftaran Dinamis
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isBuyer ? 'Daftar Sebagai Pembeli' : 'Daftar Sebagai Penjual',
                  style: const TextStyle(
                    fontFamily: AppTheme.headingFontFamily,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Informasi Perlindungan & Bebas Biaya
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.verified_user_outlined,
                    color: AppTheme.primaryColor,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Data Terproteksi & Bebas Biaya Pendaftaran',
                          style: TextStyle(
                            fontFamily: AppTheme.headingFontFamily,
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.neutralColor,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Keamanan data Anda terjamin dan pendaftaran 100% gratis tanpa biaya tersembunyi.',
                          style: TextStyle(
                            fontFamily: AppTheme.bodyFontFamily,
                            fontSize: 11.5,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Link ke Tab Masuk
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Sudah punya akun? ',
                  style: TextStyle(
                    fontFamily: AppTheme.bodyFontFamily,
                    fontSize: 13,
                    color: Color(0xFF64748B),
                  ),
                ),
                GestureDetector(
                  onTap: widget.onSwitchToLogin,
                  child: const Text(
                    'Masuk Sekarang',
                    style: TextStyle(
                      fontFamily: AppTheme.headingFontFamily,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
