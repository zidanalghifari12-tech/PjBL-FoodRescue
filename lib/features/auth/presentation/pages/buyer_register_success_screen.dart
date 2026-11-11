import 'package:flutter/material.dart';
import 'package:foodrescue/core/theme/app_theme.dart';
import 'package:foodrescue/features/auth/presentation/pages/auth_screen.dart';
import 'package:foodrescue/features/auth/presentation/widgets/app_logo_header.dart';
import 'package:foodrescue/features/home/presentation/pages/buyer_home_screen.dart';

class BuyerRegisterSuccessScreen extends StatelessWidget {
  const BuyerRegisterSuccessScreen({super.key});

  void _navigateToHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const BuyerHomeScreen()),
      (route) => false,
    );
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AuthScreen(initialTabIndex: 0)),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Reusable Logo & Tagline Header
              const AppLogoHeader(
                logoHeight: 60,
                spacingAfterLogo: 8,
                spacingAfterTagline: 24,
              ),

              // Icon Sukses Checkmark
              Center(
                child: Container(
                  width: 84,
                  height: 84,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDCFCE7),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Judul & Pesan Sukses
              Center(
                child: Text(
                  'Akun berhasil dibuat!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontFamily: AppTheme.headingFontFamily,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.neutralColor,
                        fontSize: 22,
                      ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Selamat bergabung di Food Rescue. Akun pembeli Anda sudah siap digunakan.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontFamily: AppTheme.bodyFontFamily,
                          color: const Color(0xFF64748B),
                          height: 1.45,
                          fontSize: 13,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Card Section: Mau lanjut ke mana?
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mau lanjut ke mana?',
                      style: TextStyle(
                        fontFamily: AppTheme.headingFontFamily,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.neutralColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Pilih langkah berikutnya untuk mulai menggunakan akun.',
                      style: TextStyle(
                        fontFamily: AppTheme.bodyFontFamily,
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Opsi 1: Langsung ke Beranda
                    InkWell(
                      onTap: () => _navigateToHome(context),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFDCFCE7)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: Color(0xFFDCFCE7),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.home_outlined,
                                color: AppTheme.primaryColor,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Langsung ke Beranda',
                                    style: TextStyle(
                                      fontFamily: AppTheme.headingFontFamily,
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.neutralColor,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Jelajahi makanan yang tersedia di sekitar',
                                    style: TextStyle(
                                      fontFamily: AppTheme.bodyFontFamily,
                                      fontSize: 11.5,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: AppTheme.primaryColor,
                              size: 22,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Opsi 2: Kembali ke Menu Masuk
                    InkWell(
                      onTap: () => _navigateToLogin(context),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: Color(0xFFEEF2FF),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.login_rounded,
                                color: Color(0xFF4F46E5),
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Kembali ke Menu Masuk',
                                    style: TextStyle(
                                      fontFamily: AppTheme.headingFontFamily,
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.neutralColor,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Masuk untuk mengakses akun Anda',
                                    style: TextStyle(
                                      fontFamily: AppTheme.bodyFontFamily,
                                      fontSize: 11.5,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: Color(0xFF94A3B8),
                              size: 22,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Tombol Utama: Lanjut ke Beranda
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () => _navigateToHome(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Lanjut ke Beranda',
                        style: TextStyle(
                          fontFamily: AppTheme.headingFontFamily,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, size: 18),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Tombol Sekunder: Kembali ke Menu Masuk
              SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: () => _navigateToLogin(context),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Kembali ke Menu Masuk',
                    style: TextStyle(
                      fontFamily: AppTheme.headingFontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.neutralColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

