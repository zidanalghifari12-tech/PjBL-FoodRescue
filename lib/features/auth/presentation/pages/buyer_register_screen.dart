import 'package:flutter/material.dart';
import 'package:foodrescue/core/theme/app_theme.dart';
import 'package:foodrescue/features/auth/presentation/pages/auth_screen.dart';
import 'package:foodrescue/features/auth/presentation/pages/buyer_register_success_screen.dart';
import 'package:foodrescue/features/auth/presentation/widgets/app_logo_header.dart';

class BuyerRegisterScreen extends StatefulWidget {
  const BuyerRegisterScreen({super.key});

  @override
  State<BuyerRegisterScreen> createState() => _BuyerRegisterScreenState();
}

class _BuyerRegisterScreenState extends State<BuyerRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreedToTerms = false;
  bool _showTermsError = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _navigateToLogin() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const AuthScreen(initialTabIndex: 0),
      ),
      (route) => false,
    );
  }

  void _handleRegister() {
    setState(() {
      _showTermsError = !_agreedToTerms;
    });

    final isFormValid = _formKey.currentState?.validate() ?? false;

    if (isFormValid && _agreedToTerms) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const BuyerRegisterSuccessScreen(),
        ),
      );
    }
  }

  void _handleSocialRegister(String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Simulasi: Mendaftar dengan $provider...',
          style: const TextStyle(fontFamily: AppTheme.bodyFontFamily),
        ),
        backgroundColor: AppTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: RichText(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            fontFamily: AppTheme.headingFontFamily,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.neutralColor,
          ),
          children: const [
            TextSpan(
              text: ' *',
              style: TextStyle(
                color: Color(0xFFEF4444),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    required Widget prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        fontFamily: AppTheme.bodyFontFamily,
        color: Color(0xFF94A3B8),
        fontSize: 13.5,
      ),
      filled: true,
      fillColor: const Color(0xFFF1F5F9),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppTheme.primaryColor,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFEF4444),
          width: 1.2,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFEF4444),
          width: 1.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Reusable Logo & Tagline Header
              const AppLogoHeader(
                logoHeight: 60,
                spacingAfterLogo: 8,
                spacingAfterTagline: 18,
              ),

              // Segmented Tab Masuk / Daftar
              Container(
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
                    // Tab Masuk (unselected)
                    Expanded(
                      child: GestureDetector(
                        onTap: _navigateToLogin,
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          alignment: Alignment.center,
                          child: const Text(
                            'Masuk',
                            style: TextStyle(
                              fontFamily: AppTheme.headingFontFamily,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Tab Daftar (selected)
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: const Text(
                          'Daftar',
                          style: TextStyle(
                            fontFamily: AppTheme.headingFontFamily,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Judul & Subjudul
              Center(
                child: Text(
                  'Pendaftaran Akun Pembeli',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontFamily: AppTheme.headingFontFamily,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.neutralColor,
                        fontSize: 18,
                      ),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  'Lengkapi data diri Anda untuk mulai menyelamatkan makanan.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontFamily: AppTheme.bodyFontFamily,
                        color: const Color(0xFF64748B),
                        fontSize: 12,
                      ),
                ),
              ),
              const SizedBox(height: 18),

              // Form Card Putih
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Field: Nama Lengkap
                      _buildFieldLabel('Nama Lengkap'),
                      TextFormField(
                        controller: _nameController,
                        style: const TextStyle(
                          fontFamily: AppTheme.bodyFontFamily,
                          fontSize: 14,
                          color: AppTheme.neutralColor,
                        ),
                        decoration: _buildInputDecoration(
                          hintText: 'Nama Lengkap Anda',
                          prefixIcon: const Icon(
                            Icons.person_outline_rounded,
                            color: Color(0xFF94A3B8),
                            size: 20,
                          ),
                        ),
                        validator: (value) {
                          final text = value?.trim() ?? '';
                          if (text.isEmpty) {
                            return 'Nama lengkap wajib diisi';
                          }
                          if (text.length < 3) {
                            return 'Nama lengkap minimal 3 karakter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Field: Email
                      _buildFieldLabel('Email'),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(
                          fontFamily: AppTheme.bodyFontFamily,
                          fontSize: 14,
                          color: AppTheme.neutralColor,
                        ),
                        decoration: _buildInputDecoration(
                          hintText: 'Contoh@gmail.com',
                          prefixIcon: const Icon(
                            Icons.mail_outline_rounded,
                            color: Color(0xFF94A3B8),
                            size: 20,
                          ),
                        ),
                        validator: (value) {
                          final text = value?.trim() ?? '';
                          if (text.isEmpty) {
                            return 'Email wajib diisi';
                          }
                          final emailRegex = RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                          );
                          if (!emailRegex.hasMatch(text)) {
                            return 'Format email tidak valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Field: Kata Sandi
                      _buildFieldLabel('Kata Sandi'),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: const TextStyle(
                          fontFamily: AppTheme.bodyFontFamily,
                          fontSize: 14,
                          color: AppTheme.neutralColor,
                        ),
                        decoration: _buildInputDecoration(
                          hintText: 'Minimal 8 karakter',
                          prefixIcon: const Icon(
                            Icons.lock_outline_rounded,
                            color: Color(0xFF94A3B8),
                            size: 20,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
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
                          if (value.length < 8) {
                            return 'Kata sandi minimal 8 karakter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Field: Konfirmasi Kata Sandi
                      _buildFieldLabel('Konfirmasi Kata Sandi'),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        style: const TextStyle(
                          fontFamily: AppTheme.bodyFontFamily,
                          fontSize: 14,
                          color: AppTheme.neutralColor,
                        ),
                        decoration: _buildInputDecoration(
                          hintText: 'Ulangi Kata Sandi',
                          prefixIcon: const Icon(
                            Icons.verified_user_outlined,
                            color: Color(0xFF94A3B8),
                            size: 20,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: const Color(0xFF94A3B8),
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Konfirmasi kata sandi wajib diisi';
                          }
                          if (value != _passwordController.text) {
                            return 'Kata sandi tidak cocok';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Checkbox Persetujuan Syarat & Privasi
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 22,
                            height: 22,
                            child: Checkbox(
                              value: _agreedToTerms,
                              activeColor: AppTheme.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              side: BorderSide(
                                color: _showTermsError
                                    ? const Color(0xFFEF4444)
                                    : const Color(0xFFCBD5E1),
                                width: 1.5,
                              ),
                              onChanged: (val) {
                                setState(() {
                                  _agreedToTerms = val ?? false;
                                  if (_agreedToTerms) {
                                    _showTermsError = false;
                                  }
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _agreedToTerms = !_agreedToTerms;
                                  if (_agreedToTerms) {
                                    _showTermsError = false;
                                  }
                                });
                              },
                              child: RichText(
                                text: TextSpan(
                                  text: 'Saya menyetujui ',
                                  style: const TextStyle(
                                    fontFamily: AppTheme.bodyFontFamily,
                                    fontSize: 11.5,
                                    color: Color(0xFF64748B),
                                    height: 1.4,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Syarat & Ketentuan',
                                      style: const TextStyle(
                                        color: AppTheme.primaryColor,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    const TextSpan(text: ' serta '),
                                    TextSpan(
                                      text: 'Kebijakan Privasi',
                                      style: const TextStyle(
                                        color: AppTheme.primaryColor,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    const TextSpan(text: ' Food Waste.'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_showTermsError) ...[
                        const SizedBox(height: 6),
                        const Padding(
                          padding: EdgeInsets.only(left: 30.0),
                          child: Text(
                            'Anda harus menyetujui syarat & ketentuan',
                            style: TextStyle(
                              fontFamily: AppTheme.bodyFontFamily,
                              fontSize: 11.5,
                              color: Color(0xFFEF4444),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),

                      // Tombol: Daftar Sekarang ->
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _handleRegister,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Daftar Sekarang',
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
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Divider atau daftar dengan
              Row(
                children: [
                  const Expanded(
                    child: Divider(color: Color(0xFFE2E8F0), thickness: 1),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      'atau daftar dengan',
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

              // Tombol Sosial: Google & WhatsApp Side by Side
              Row(
                children: [
                  // Google Button
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: OutlinedButton(
                        onPressed: () => _handleSocialRegister('Google'),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: Color(0xFFEA4335),
                                shape: BoxShape.circle,
                              ),
                              child: const Text(
                                'G',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: AppTheme.headingFontFamily,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Google',
                              style: TextStyle(
                                fontFamily: AppTheme.headingFontFamily,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.neutralColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // WhatsApp Button
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: OutlinedButton(
                        onPressed: () => _handleSocialRegister('WhatsApp'),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.chat_bubble_outline_rounded,
                              color: Color(0xFF475569),
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'WhatsApp',
                              style: TextStyle(
                                fontFamily: AppTheme.headingFontFamily,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.neutralColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Link Masuk di sini
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
                    onTap: _navigateToLogin,
                    child: const Text(
                      'Masuk di sini',
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
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

