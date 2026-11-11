import 'package:flutter/material.dart';
import 'package:foodrescue/core/theme/app_theme.dart';

class LoginForm extends StatefulWidget {
  final VoidCallback onSwitchToRegister;

  const LoginForm({
    super.key,
    required this.onSwitchToRegister,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Simulasi: Berhasil masuk sebagai ${_identifierController.text.trim()}!',
            style: const TextStyle(fontFamily: AppTheme.bodyFontFamily),
          ),
          backgroundColor: AppTheme.primaryColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _handleWhatsAppOtp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Simulasi: Mengirimkan kode OTP ke nomor WhatsApp...',
          style: TextStyle(fontFamily: AppTheme.bodyFontFamily),
        ),
        backgroundColor: AppTheme.secondaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleGoogleLogin() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Simulasi: Menghubungkan ke Akun Google...',
          style: TextStyle(fontFamily: AppTheme.bodyFontFamily),
        ),
        backgroundColor: AppTheme.neutralColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Lupa Kata Sandi',
          style: TextStyle(
            fontFamily: AppTheme.headingFontFamily,
            fontWeight: FontWeight.bold,
            color: AppTheme.neutralColor,
          ),
        ),
        content: const Text(
          'Tautan pemulihan kata sandi akan dikirimkan ke nomor WhatsApp atau email terdaftar Anda.',
          style: TextStyle(
            fontFamily: AppTheme.bodyFontFamily,
            color: AppTheme.neutralColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'Tutup',
              style: TextStyle(
                fontFamily: AppTheme.bodyFontFamily,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Simulasi: Tautan reset kata sandi telah dikirim!',
                    style: TextStyle(fontFamily: AppTheme.bodyFontFamily),
                  ),
                  backgroundColor: AppTheme.primaryColor,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Kirim Tautan',
              style: TextStyle(fontFamily: AppTheme.headingFontFamily),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Judul Selamat Datang
            Center(
              child: Text(
                'Selamat Datang',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontFamily: AppTheme.headingFontFamily,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.neutralColor,
                      fontSize: 20,
                    ),
              ),
            ),
            const SizedBox(height: 6),
            Center(
              child: Text(
                'Masuk untuk mengelola dan mengurangi sisa makanan bersama kami.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontFamily: AppTheme.bodyFontFamily,
                      color: const Color(0xFF64748B),
                      fontSize: 12.5,
                      height: 1.4,
                    ),
              ),
            ),
            const SizedBox(height: 20),

            // Input WhatsApp atau Email
            const Text(
              'Nomor WhatsApp atau Email',
              style: TextStyle(
                fontFamily: AppTheme.headingFontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.neutralColor,
              ),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _identifierController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(
                fontFamily: AppTheme.bodyFontFamily,
                color: AppTheme.neutralColor,
                fontSize: 14,
              ),
              decoration: const InputDecoration(
                hintText: '08123456789 atau nama@email.com',
                prefixIcon: Icon(
                  Icons.person_outline_rounded,
                  color: Color(0xFF94A3B8),
                  size: 20,
                ),
              ),
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.isEmpty) {
                  return 'Nomor WhatsApp atau email wajib diisi';
                }
                if (!text.contains('@') && text.length < 9) {
                  return 'Nomor WhatsApp minimal 9 digit angka';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),

            // Input Kata Sandi
            const Text(
              'Kata Sandi',
              style: TextStyle(
                fontFamily: AppTheme.headingFontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.neutralColor,
              ),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              style: const TextStyle(
                fontFamily: AppTheme.bodyFontFamily,
                color: AppTheme.neutralColor,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: 'Masukkan kata sandi Anda',
                prefixIcon: const Icon(
                  Icons.lock_outline_rounded,
                  color: Color(0xFF94A3B8),
                  size: 20,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: const Color(0xFF94A3B8),
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Kata sandi wajib diisi';
                }
                if (value.length < 6) {
                  return 'Kata sandi minimal 6 karakter';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),

            // Ingat Saya & Lupa Kata Sandi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: _rememberMe,
                        activeColor: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        side: const BorderSide(
                          color: Color(0xFFCBD5E1),
                          width: 1.5,
                        ),
                        onChanged: (val) {
                          setState(() {
                            _rememberMe = val ?? false;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _rememberMe = !_rememberMe;
                        });
                      },
                      child: const Text(
                        'Ingat Saya',
                        style: TextStyle(
                          fontFamily: AppTheme.bodyFontFamily,
                          fontSize: 13,
                          color: AppTheme.neutralColor,
                        ),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: _showForgotPasswordDialog,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Lupa Kata Sandi?',
                    style: TextStyle(
                      fontFamily: AppTheme.bodyFontFamily,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Tombol Masuk
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Masuk',
                  style: TextStyle(
                    fontFamily: AppTheme.headingFontFamily,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Divider Pemisah
            Row(
              children: [
                const Expanded(
                  child: Divider(color: Color(0xFFE2E8F0), thickness: 1),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    'atau masuk dengan',
                    style: TextStyle(
                      fontFamily: AppTheme.bodyFontFamily,
                      fontSize: 12,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ),
                const Expanded(
                  child: Divider(color: Color(0xFFE2E8F0), thickness: 1),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Tombol Masuk dengan WhatsApp OTP
            SizedBox(
              height: 48,
              child: OutlinedButton.icon(
                onPressed: _handleWhatsAppOtp,
                icon: const Icon(
                  Icons.phone_android_rounded,
                  color: AppTheme.secondaryColor,
                  size: 20,
                ),
                label: const Text(
                  'Masuk dengan WhatsApp OTP',
                  style: TextStyle(
                    fontFamily: AppTheme.headingFontFamily,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.neutralColor,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Tombol Lanjutkan dengan Google
            SizedBox(
              height: 48,
              child: OutlinedButton(
                onPressed: _handleGoogleLogin,
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEA4335),
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        'G',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          fontFamily: AppTheme.headingFontFamily,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Lanjutkan dengan Google',
                      style: TextStyle(
                        fontFamily: AppTheme.headingFontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.neutralColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Link ke Tab Daftar
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Belum punya akun? ',
                  style: TextStyle(
                    fontFamily: AppTheme.bodyFontFamily,
                    fontSize: 13,
                    color: Color(0xFF64748B),
                  ),
                ),
                GestureDetector(
                  onTap: widget.onSwitchToRegister,
                  child: const Text(
                    'Daftar Sekarang',
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
