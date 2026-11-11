import 'package:flutter/material.dart';
import 'package:foodrescue/core/theme/app_theme.dart';
import 'package:foodrescue/features/profile/data/user_profile_manager.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final UserProfileManager _profileManager = UserProfileManager();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;

  String _selectedLocation = 'Bandar Lampung';
  String? _selectedImagePath;
  bool _isLoading = false;

  final List<String> _locationOptions = const [
    'Bandar Lampung',
    'Metro',
    'Lampung Selatan',
    'Lampung Tengah',
    'Pesawaran',
  ];

  @override
  void initState() {
    super.initState();
    final profile = _profileManager.profile;
    _nameController = TextEditingController(text: profile.name);
    _phoneController = TextEditingController(text: profile.phone);
    _emailController = TextEditingController(text: profile.email);
    _selectedLocation = profile.location;
    _selectedImagePath = profile.avatarImagePath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _showImagePickerModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Ubah Foto Profil',
                  style: TextStyle(
                    fontFamily: AppTheme.headingFontFamily,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.neutralColor,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.photo_library_outlined,
                  color: Color(0xFF047857),
                ),
              ),
              title: const Text(
                'Pilih dari Galeri',
                style: TextStyle(
                  fontFamily: AppTheme.headingFontFamily,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: const Text(
                'Pilih foto terbaik dari penyimpanan Anda',
                style: TextStyle(fontSize: 11.5),
              ),
              onTap: () {
                Navigator.pop(ctx);
                setState(() {
                  _selectedImagePath = 'assets/images/food_rescue.png';
                });
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Foto profil berhasil dipilih dari galeri.'),
                    duration: Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.camera_alt_outlined,
                  color: Color(0xFF0284C7),
                ),
              ),
              title: const Text(
                'Ambil dari Kamera',
                style: TextStyle(
                  fontFamily: AppTheme.headingFontFamily,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: const Text(
                'Gunakan kamera perangkat untuk memotret',
                style: TextStyle(fontSize: 11.5),
              ),
              onTap: () {
                Navigator.pop(ctx);
                setState(() {
                  _selectedImagePath = 'assets/images/food_rescue.png';
                });
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Foto profil berhasil diambil dari kamera.'),
                    duration: Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            if (_selectedImagePath != null)
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: Color(0xFFDC2626),
                  ),
                ),
                title: const Text(
                  'Gunakan Avatar Default',
                  style: TextStyle(
                    fontFamily: AppTheme.headingFontFamily,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFDC2626),
                  ),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() {
                    _selectedImagePath = null;
                  });
                },
              ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _showLocationPickerModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pilih Lokasi Utama',
                  style: TextStyle(
                    fontFamily: AppTheme.headingFontFamily,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.neutralColor,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ..._locationOptions.map((loc) {
              final isSelected = _selectedLocation == loc;
              return ListTile(
                leading: Icon(
                  Icons.location_on_rounded,
                  color: isSelected
                      ? const Color(0xFF047857)
                      : const Color(0xFF94A3B8),
                ),
                title: Text(
                  loc,
                  style: TextStyle(
                    fontFamily: AppTheme.headingFontFamily,
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected
                        ? const Color(0xFF047857)
                        : AppTheme.neutralColor,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check_circle_rounded,
                        color: Color(0xFF047857))
                    : null,
                onTap: () {
                  setState(() {
                    _selectedLocation = loc;
                  });
                  Navigator.pop(ctx);
                },
              );
            }),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _handleSave() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();

    // 1. Validations
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama lengkap tidak boleh kosong.'),
          backgroundColor: Color(0xFFDC2626),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (phone.isEmpty || phone.replaceAll(RegExp(r'\D'), '').length < 8) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nomor telepon tidak valid (minimal 8 digit).'),
          backgroundColor: Color(0xFFDC2626),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (email.isEmpty || !_isValidEmail(email)) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Format email tidak valid.'),
          backgroundColor: Color(0xFFDC2626),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // 2. Perform Save
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 400));

    _profileManager.updateProfile(
      name: name,
      phone: phone,
      email: email,
      location: _selectedLocation,
      avatarImagePath: _selectedImagePath,
      clearAvatarImage: _selectedImagePath == null,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profil berhasil diperbarui.'),
        backgroundColor: Color(0xFF047857),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Profil',
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
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          physics: const BouncingScrollPhysics(),
          children: [
            // B. Foto Profil Section (Matching Screenshot)
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEFF6FF),
                      shape: BoxShape.circle,
                    ),
                    child: _selectedImagePath != null
                        ? ClipOval(
                            child: Image.asset(
                              _selectedImagePath!,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(
                            Icons.person_outline_rounded,
                            color: Color(0xFF047857),
                            size: 42,
                          ),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: _showImagePickerModal,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.camera_alt_outlined,
                            size: 16,
                            color: Color(0xFF047857),
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Ubah foto profil',
                            style: TextStyle(
                              fontFamily: AppTheme.headingFontFamily,
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF047857),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // C. Form Edit Data Diri (White Card with Rounded Corners)
            Container(
              padding: const EdgeInsets.all(18),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Nama lengkap
                  const Text(
                    'Nama lengkap',
                    style: TextStyle(
                      fontFamily: AppTheme.headingFontFamily,
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.neutralColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    key: const Key('edit_name_field'),
                    controller: _nameController,
                    style: const TextStyle(
                      fontFamily: AppTheme.bodyFontFamily,
                      fontSize: 13.5,
                      color: AppTheme.neutralColor,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF047857)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2. Nomor telepon
                  const Text(
                    'Nomor telepon',
                    style: TextStyle(
                      fontFamily: AppTheme.headingFontFamily,
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.neutralColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                          ),
                          child: const Text(
                            '+62',
                            style: TextStyle(
                              fontFamily: AppTheme.bodyFontFamily,
                              fontSize: 13.5,
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            key: const Key('edit_phone_field'),
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            style: const TextStyle(
                              fontFamily: AppTheme.bodyFontFamily,
                              fontSize: 13.5,
                              color: AppTheme.neutralColor,
                            ),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              border: InputBorder.none,
                              hintText: '812 3456 7890',
                              hintStyle: TextStyle(
                                fontFamily: AppTheme.bodyFontFamily,
                                color: Color(0xFF94A3B8),
                                fontSize: 13.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Nomor ini digunakan untuk info pesanan.',
                    style: TextStyle(
                      fontFamily: AppTheme.bodyFontFamily,
                      fontSize: 11.5,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 3. Email
                  const Text(
                    'Email',
                    style: TextStyle(
                      fontFamily: AppTheme.headingFontFamily,
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.neutralColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    key: const Key('edit_email_field'),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(
                      fontFamily: AppTheme.bodyFontFamily,
                      fontSize: 13.5,
                      color: AppTheme.neutralColor,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF047857)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 4. Lokasi utama
                  const Text(
                    'Lokasi utama',
                    style: TextStyle(
                      fontFamily: AppTheme.headingFontFamily,
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.neutralColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _showLocationPickerModal,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Color(0xFF047857),
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _selectedLocation,
                              style: const TextStyle(
                                fontFamily: AppTheme.bodyFontFamily,
                                fontSize: 13.5,
                                color: AppTheme.neutralColor,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Color(0xFF64748B),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // D. Informasi Keamanan Card (Soft Green)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFDCFCE7)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(
                    Icons.verified_user_outlined,
                    color: Color(0xFF047857),
                    size: 18,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Data diri Anda tersimpan dengan aman dan hanya digunakan untuk kebutuhan transaksi.',
                      style: TextStyle(
                        fontFamily: AppTheme.bodyFontFamily,
                        fontSize: 12,
                        color: Color(0xFF334155),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // E. Tombol Aksi (Simpan Perubahan & Batal)
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                key: const Key('edit_save_button'),
                onPressed: _isLoading ? null : _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF047857),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Simpan Perubahan',
                        style: TextStyle(
                          fontFamily: AppTheme.headingFontFamily,
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 14),

            Center(
              child: InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(8),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Batal',
                    style: TextStyle(
                      fontFamily: AppTheme.headingFontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF475569),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

