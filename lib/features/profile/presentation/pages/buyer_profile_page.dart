import 'package:flutter/material.dart';
import 'package:foodrescue/core/theme/app_theme.dart';
import 'package:foodrescue/features/auth/presentation/pages/auth_screen.dart';
import 'package:foodrescue/features/home/presentation/pages/buyer_home_screen.dart';
import 'package:foodrescue/features/home/presentation/widgets/buyer_bottom_navigation_bar.dart';
import 'package:foodrescue/features/profile/data/user_profile_manager.dart';
import 'package:foodrescue/features/profile/presentation/pages/edit_profile_page.dart';

class BuyerProfilePage extends StatefulWidget {
  final bool showBottomNav;

  const BuyerProfilePage({
    super.key,
    this.showBottomNav = false,
  });

  @override
  State<BuyerProfilePage> createState() => _BuyerProfilePageState();
}

class _BuyerProfilePageState extends State<BuyerProfilePage> {
  final UserProfileManager _profileManager = UserProfileManager();

  void _handleBack(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const BuyerHomeScreen(initialTabIndex: 0),
        ),
        (route) => false,
      );
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Keluar dari Akun?',
          style: TextStyle(
            fontFamily: AppTheme.headingFontFamily,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari akun?',
          style: TextStyle(
            fontFamily: AppTheme.bodyFontFamily,
            fontSize: 13,
            color: Color(0xFF64748B),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Batal',
              style: TextStyle(
                fontFamily: AppTheme.headingFontFamily,
                color: Color(0xFF64748B),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const AuthScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC51B1B),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Keluar',
              style: TextStyle(fontFamily: AppTheme.headingFontFamily),
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpCenterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Bantuan & Pusat Edukasi Pangan',
                    style: TextStyle(
                      fontFamily: AppTheme.headingFontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.neutralColor,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Panduan Pembelian & SOP Surplus Pakan:',
              style: TextStyle(
                fontFamily: AppTheme.headingFontFamily,
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: AppTheme.neutralColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '1. Pilih surplus pakan berkualitas dari mitra terverifikasi.\n'
              '2. Periksa jadwal dan lokasi pengambilan sebelum checkout.\n'
              '3. Tunjukkan QR Pesanan saat mengambil pakan di toko.\n'
              '4. Pastikan membawa wadah sendiri sesuai instruksi toko.',
              style: TextStyle(
                fontFamily: AppTheme.bodyFontFamily,
                fontSize: 12.5,
                color: Color(0xFF475569),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Tutup Panduan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPolicyDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Kebijakan & Ketentuan',
                    style: TextStyle(
                      fontFamily: AppTheme.headingFontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.neutralColor,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Aturan Pembelian Surplus Pakan:',
              style: TextStyle(
                fontFamily: AppTheme.headingFontFamily,
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: AppTheme.neutralColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Produk yang dibeli ditujukan khusus untuk pemanfaatan pakan ternak.\n'
              '• Pembatalan hanya dapat dilakukan sebelum status pesanan Siap Diambil.\n'
              '• Pembeli wajib mengambil pesanan sesuai tenggat waktu operasional toko.',
              style: TextStyle(
                fontFamily: AppTheme.bodyFontFamily,
                fontSize: 12.5,
                color: Color(0xFF475569),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Saya Mengerti'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSecuritySettingsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Ganti Kata Sandi & PIN',
                    style: TextStyle(
                      fontFamily: AppTheme.headingFontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.neutralColor,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Keamanan Akun Pembeli:',
              style: TextStyle(
                fontFamily: AppTheme.headingFontFamily,
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: AppTheme.neutralColor,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'PIN 6-digit digunakan untuk verifikasi pencairan dana dan otentikasi transaksi penting.',
              style: TextStyle(
                fontFamily: AppTheme.bodyFontFamily,
                fontSize: 12.5,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.password_rounded,
                    color: Color(0xFF0284C7)),
              ),
              title: const Text(
                'Ubah Kata Sandi',
                style: TextStyle(
                  fontFamily: AppTheme.headingFontFamily,
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                'Terakhir diubah 3 bulan lalu',
                style: TextStyle(fontSize: 11.5),
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fitur ubah kata sandi akan segera hadir.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.pin_rounded,
                    color: AppTheme.primaryColor),
              ),
              title: const Text(
                'PIN Transaksi 6-Digit',
                style: TextStyle(
                  fontFamily: AppTheme.headingFontFamily,
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                'PIN aktif & terlindungi',
                style: TextStyle(fontSize: 11.5),
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fitur ubah PIN akan segera hadir.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _onEditProfileTap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const EditProfilePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _profileManager,
      builder: (context, _) {
        final profile = _profileManager.profile;

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            backgroundColor: const Color(0xFFF8FAFC),
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: AppTheme.neutralColor,
              ),
              onPressed: () => _handleBack(context),
            ),
            title: const Text(
              'Akun Saya',
              style: TextStyle(
                fontFamily: AppTheme.headingFontFamily,
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppTheme.neutralColor,
              ),
            ),
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                color: const Color(0xFFE2E8F0),
                height: 1,
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            physics: const BouncingScrollPhysics(),
            children: [
              // 1. Kartu Profil Pembeli (Matching Screenshot media_1794370199378_944bf4ed.jpg)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Avatar Icon Container
                    Container(
                      width: 76,
                      height: 76,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEFF6FF),
                        shape: BoxShape.circle,
                      ),
                      child: profile.avatarImagePath != null
                          ? ClipOval(
                              child: Image.asset(
                                profile.avatarImagePath!,
                                width: 76,
                                height: 76,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(
                              Icons.person_outline_rounded,
                              color: Color(0xFF047857),
                              size: 38,
                            ),
                    ),
                    const SizedBox(height: 12),

                    // Nama Pembeli
                    Text(
                      profile.name,
                      style: const TextStyle(
                        fontFamily: AppTheme.headingFontFamily,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.neutralColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),

                    // Informasi Bergabung
                    Text(
                      profile.memberSince,
                      style: const TextStyle(
                        fontFamily: AppTheme.bodyFontFamily,
                        fontSize: 12.5,
                        color: Color(0xFF64748B),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // Tombol Outline Hijau "Edit Data Diri"
                    SizedBox(
                      width: double.infinity,
                      height: 42,
                      child: OutlinedButton.icon(
                        onPressed: () => _onEditProfileTap(context),
                        icon: const Icon(
                          Icons.edit_outlined,
                          size: 16,
                          color: Color(0xFF047857),
                        ),
                        label: const Text(
                          'Edit Data Diri',
                          style: TextStyle(
                            fontFamily: AppTheme.headingFontFamily,
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF047857),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFF047857),
                            width: 1.2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 2. Section: Notifikasi & Preferensi
              const Text(
                'Notifikasi & Preferensi',
                style: TextStyle(
                  fontFamily: AppTheme.headingFontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.neutralColor,
                ),
              ),
              const SizedBox(height: 12),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Item A: Notifikasi & Push Notifikasi
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.notifications_none_rounded,
                              color: Color(0xFF334155),
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Notifikasi & Push Notifikasi',
                                  style: TextStyle(
                                    fontFamily: AppTheme.headingFontFamily,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.neutralColor,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Pemberitahuan instan saat ada pemberitahuan terbaru',
                                  style: TextStyle(
                                    fontFamily: AppTheme.bodyFontFamily,
                                    fontSize: 11.5,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Switch.adaptive(
                            value: profile.isPushNotificationEnabled,
                            activeThumbColor: Colors.white,
                            activeTrackColor: const Color(0xFF047857),
                            inactiveTrackColor: const Color(0xFFCBD5E1),
                            onChanged: (val) {
                              _profileManager.setPushNotification(val);
                            },
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 1,
                      indent: 68,
                      endIndent: 16,
                      color: Color(0xFFF1F5F9),
                    ),

                    // Item B: Bantuan & Pusat Edukasi Pangan
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _showHelpCenterDialog(context),
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.menu_book_outlined,
                                  color: Color(0xFF334155),
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Bantuan & Pusat Edukasi Pangan',
                                      style: TextStyle(
                                        fontFamily: AppTheme.headingFontFamily,
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.neutralColor,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Panduan pembelian stok pangan dan SOP surplus',
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
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Divider(
                      height: 1,
                      indent: 68,
                      endIndent: 16,
                      color: Color(0xFFF1F5F9),
                    ),

                    // Item C: Kebijakan & Ketentuan Pembeli FoodRescue
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _showPolicyDialog(context),
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.security_outlined,
                                  color: Color(0xFF334155),
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Kebijakan & Ketentuan Pembeli FoodRescue',
                                      style: TextStyle(
                                        fontFamily: AppTheme.headingFontFamily,
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.neutralColor,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Aturan pembelian produk untuk pakan ternak dan lain lain',
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
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 3. Section: Akun & Keamanan
              const Text(
                'Akun & Keamanan',
                style: TextStyle(
                  fontFamily: AppTheme.headingFontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.neutralColor,
                ),
              ),
              const SizedBox(height: 12),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _showSecuritySettingsDialog(context),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.history_rounded,
                              color: Color(0xFF334155),
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Ganti Kata Sandi & PIN Keamanan',
                                  style: TextStyle(
                                    fontFamily: AppTheme.headingFontFamily,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.neutralColor,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'PIN 6-digit untuk verifikasi pencairan dana',
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
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 4. Tombol: Keluar dari akun (Merah #C51B1B)
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () => _showLogoutDialog(context),
                  icon: const Icon(
                    Icons.exit_to_app_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: const Text(
                    'Keluar dari akun',
                    style: TextStyle(
                      fontFamily: AppTheme.headingFontFamily,
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC51B1B),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
          bottomNavigationBar: widget.showBottomNav
              ? BuyerBottomNavBar(
                  currentIndex: 4,
                  onTap: (index) {
                    if (index == 4) return;
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) => BuyerHomeScreen(initialTabIndex: index),
                      ),
                      (route) => false,
                    );
                  },
                )
              : null,
        );
      },
    );
  }
}
