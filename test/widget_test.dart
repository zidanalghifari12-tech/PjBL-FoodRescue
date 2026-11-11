import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodrescue/app.dart';
import 'package:foodrescue/features/auth/presentation/pages/auth_screen.dart';
import 'package:foodrescue/features/auth/presentation/pages/buyer_register_screen.dart';
import 'package:foodrescue/features/auth/presentation/pages/buyer_register_success_screen.dart';
import 'package:foodrescue/features/auth/presentation/widgets/login_form.dart';
import 'package:foodrescue/features/auth/presentation/widgets/role_selection.dart';
import 'package:foodrescue/features/buyer/data/cart_manager.dart';
import 'package:foodrescue/features/buyer/models/order_model.dart';
import 'package:foodrescue/features/buyer/presentation/pages/cart_page.dart';
import 'package:foodrescue/features/buyer/presentation/pages/checkout_page.dart';
import 'package:foodrescue/features/buyer/presentation/pages/order_confirmation_page.dart';
import 'package:foodrescue/features/buyer/presentation/pages/product_detail_page.dart';
import 'package:foodrescue/features/chat/presentation/pages/chat_list_page.dart';
import 'package:foodrescue/features/chat/presentation/pages/store_chat_page.dart';
import 'package:foodrescue/features/history/data/order_manager.dart';
import 'package:foodrescue/features/history/presentation/pages/order_qr_page.dart';
import 'package:foodrescue/features/history/presentation/pages/transaction_history_page.dart';
import 'package:foodrescue/features/home/models/feed_product_model.dart';
import 'package:foodrescue/features/home/presentation/pages/buyer_home_screen.dart';
import 'package:foodrescue/features/home/presentation/widgets/buyer_bottom_navigation_bar.dart';
import 'package:foodrescue/features/home/presentation/widgets/filter/feed_filter_bottom_sheet.dart';
import 'package:foodrescue/features/profile/data/user_profile_manager.dart';
import 'package:foodrescue/features/profile/presentation/pages/buyer_profile_page.dart';
import 'package:foodrescue/features/profile/presentation/pages/edit_profile_page.dart';

void main() {
  testWidgets('Splash screen navigates to AuthScreen after animation',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      UserProfileManager().resetToDefault();
    });

    await tester.pumpWidget(const FoodRescueApp());

    // Initially on Splash Screen
    expect(find.text('FooD RescuE'), findsOneWidget);
    expect(find.text('Version 1.0'), findsOneWidget);

    // Progress animation past completion and trigger delay
    await tester.pump(const Duration(milliseconds: 1300));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // Now on AuthScreen
    expect(find.byType(AuthScreen), findsOneWidget);
    expect(find.text('Masuk'), findsWidgets);
    expect(find.text('Daftar'), findsOneWidget);
  });

  testWidgets('AuthScreen segmented tabs switch between Login and Register',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      UserProfileManager().resetToDefault();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: AuthScreen(),
      ),
    );

    // Initial tab is Masuk
    expect(find.byType(LoginForm), findsOneWidget);
    expect(find.text('Misi Pangan Berkelanjutan'), findsOneWidget);
    expect(find.text('Masuk dengan WhatsApp OTP'), findsOneWidget);

    // Tap Daftar tab
    await tester.tap(find.text('Daftar'));
    await tester.pumpAndSettle();

    // Now in Register / Role Selection
    expect(find.byType(RoleSelection), findsOneWidget);
    expect(find.text('Daftar Sebagai Apa di FoodRescue?'), findsOneWidget);
    expect(find.text('Daftar Sebagai Pembeli'), findsOneWidget);

    // Tap Penjual card
    await tester.tap(find.text('Penjual'));
    await tester.pumpAndSettle();

    // Button updates to Penjual
    expect(find.text('Daftar Sebagai Penjual'), findsOneWidget);

    // Tap Masuk Sekarang link to return to Login tab
    await tester.ensureVisible(find.text('Masuk Sekarang'));
    await tester.tap(find.text('Masuk Sekarang'));
    await tester.pumpAndSettle();

    // Back to Login tab
    expect(find.byType(LoginForm), findsOneWidget);
  });

  testWidgets('LoginForm validates empty fields and inputs',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      UserProfileManager().resetToDefault();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AuthScreen(),
        ),
      ),
    );

    // Tap Masuk button without inputs
    final loginButton = find.widgetWithText(ElevatedButton, 'Masuk');
    await tester.ensureVisible(loginButton);
    await tester.tap(loginButton);
    await tester.pump();

    // Expect validation errors
    expect(find.text('Nomor WhatsApp atau email wajib diisi'), findsOneWidget);
    expect(find.text('Kata sandi wajib diisi'), findsOneWidget);
  });

  testWidgets(
      'BuyerRegisterScreen validates inputs and navigates to Success Screen',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      UserProfileManager().resetToDefault();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: BuyerRegisterScreen(),
      ),
    );

    expect(find.text('Pendaftaran Akun Pembeli'), findsOneWidget);
    expect(find.text('Google'), findsOneWidget);
    expect(find.text('WhatsApp'), findsOneWidget);

    // Tap submit button while empty
    final submitButton = find.widgetWithText(ElevatedButton, 'Daftar Sekarang');
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pump();

    // Should show validation errors
    expect(find.text('Nama lengkap wajib diisi'), findsOneWidget);
    expect(find.text('Email wajib diisi'), findsOneWidget);
    expect(find.text('Kata sandi wajib diisi'), findsOneWidget);
    expect(find.text('Anda harus menyetujui syarat & ketentuan'), findsOneWidget);

    // Fill valid form
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nama Lengkap Anda'),
      'Budi Santoso',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Contoh@gmail.com'),
      'budi@gmail.com',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Minimal 8 karakter'),
      'password123',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Ulangi Kata Sandi'),
      'password123',
    );

    // Check terms
    final checkbox = find.byType(Checkbox);
    await tester.ensureVisible(checkbox);
    await tester.tap(checkbox);
    await tester.pump();

    // Submit valid form
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    // Should navigate to BuyerRegisterSuccessScreen
    expect(find.byType(BuyerRegisterSuccessScreen), findsOneWidget);
    expect(find.text('Akun berhasil dibuat!'), findsOneWidget);
    expect(find.text('Langsung ke Beranda'), findsOneWidget);

    // Tap Lanjut ke Beranda
    final homeButton = find.widgetWithText(ElevatedButton, 'Lanjut ke Beranda');
    await tester.ensureVisible(homeButton);
    await tester.tap(homeButton);
    await tester.pumpAndSettle();

    // Arrives at BuyerHomeScreen
    expect(find.byType(BuyerHomeScreen), findsOneWidget);
  });

  testWidgets('BuyerHomeScreen renders dashboard components and handles search/filter',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      UserProfileManager().resetToDefault();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: BuyerHomeScreen(),
      ),
    );

    // Header components
    expect(find.text('AREA PAKAN'), findsOneWidget);
    expect(find.text('Bandar Lampung'), findsOneWidget);

    // Banner components
    expect(find.text('Halo, Peternakan Berkah 🌾'), findsOneWidget);
    expect(find.text('Cek Surplus Hari Ini'), findsOneWidget);
    expect(find.text('Hemat s.d 70%'), findsOneWidget);

    // Categories
    expect(find.text('Kategori Pakan'), findsOneWidget);
    expect(find.text('Ampas Tahu'), findsWidgets);
    expect(find.text('Sayur & Buah'), findsWidgets);

    // Recommendations & Products
    expect(find.text('Rekomendasi Terdekat'), findsOneWidget);
    expect(find.text('Ampas Tahu Basah Segar (Pabrik...'), findsOneWidget);
    expect(find.text('Sisa Sayuran Hijau & Kol Supermarket'), findsOneWidget);

    // Test Search Functionality
    final searchInput = find.byType(TextField);
    await tester.enterText(searchInput, 'Roti');
    await tester.pump();

    // Now only Roti product appears
    expect(find.text('Roti Gandum & Kulit Bakery Afkir'), findsOneWidget);
    expect(find.text('Ampas Tahu Basah Segar (Pabrik...'), findsNothing);

    // Test Clear Search
    final clearBtn = find.byIcon(Icons.close_rounded);
    await tester.tap(clearBtn);
    await tester.pump();
    expect(find.text('Ampas Tahu Basah Segar (Pabrik...'), findsOneWidget);

    // Open Filter Bottom Sheet
    final filterBtn = find.byIcon(Icons.tune_rounded);
    await tester.tap(filterBtn);
    await tester.pumpAndSettle();

    // Bottom sheet is displayed
    expect(find.byType(FeedFilterBottomSheet), findsOneWidget);
    expect(find.text('Filter Pakan & Radius'), findsOneWidget);
    expect(find.text('Radius Jarak Maksimal'), findsOneWidget);
    expect(find.text('Tipe Biaya / Status Pakan'), findsOneWidget);

    // Tap Terapkan Filter
    final applyBtn = find.textContaining('Terapkan Filter');
    expect(applyBtn, findsOneWidget);
    await tester.tap(applyBtn);
    await tester.pumpAndSettle();

    // Test Bottom Navigation Tab Switching across all 5 menus
    await tester.tap(find.text('Pesanan Saya'));
    await tester.pumpAndSettle();
    expect(find.byType(CartPage), findsOneWidget);

    await tester.tap(find.text('Chat'));
    await tester.pumpAndSettle();
    expect(find.byType(ChatListPage), findsOneWidget);

    await tester.tap(find.text('Riwayat'));
    await tester.pumpAndSettle();
    expect(find.byType(TransactionHistoryPage), findsOneWidget);
    expect(find.text('Riwayat Transaksi'), findsOneWidget);

    await tester.tap(find.text('Akun Saya'));
    await tester.pumpAndSettle();
    expect(find.byType(BuyerProfilePage), findsOneWidget);
    expect(find.text('Parman Pratama'), findsOneWidget);

    await tester.tap(find.text('Beranda'));
    await tester.pumpAndSettle();
    expect(find.text('Halo, Peternakan Berkah 🌾'), findsOneWidget);
  });

  testWidgets(
      'ProductDetailPage displays details, handles quantity changes and ordering',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      UserProfileManager().resetToDefault();
    });

    const testProduct = FeedProduct(
      id: 'test_1',
      sellerName: 'Toko Sayur Ibu Ida',
      name: 'Sisa Sayuran & Kol',
      category: 'Sayur & Buah',
      stock: '3 kg',
      price: 500,
      priceUnit: '/kg',
      distanceKm: 2.8,
      status: 'Segera',
      isFavorite: false,
      isFree: false,
      readyTime: 'Segar (<12 Jam)',
      placeholderIcon: Icons.eco_rounded,
      placeholderColor: Color(0xFFDCFCE7),
      remainingTime: '1 Jam lagi',
      condition: 'Sortiran Bersih Tanpa Plastik',
      locationAddress: 'Caringin, Lampung',
      operatingHours: '06:00 - 11:00 WIB',
      pickupShift: 'Jam Angkut Pagi-Siang',
      isOpen: true,
      maxStockKg: 3,
      badgeText: 'Harga Murah',
      photos: ['Foto Batch 1', 'Foto Batch 2', 'Foto Batch 3'],
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: ProductDetailPage(product: testProduct),
      ),
    );

    // App Bar
    expect(find.text('Detail Pesanan'), findsOneWidget);
    expect(find.byIcon(Icons.share_outlined), findsOneWidget);

    // Gallery and Badges
    expect(find.text('Segera'), findsOneWidget);
    expect(find.text('1 Jam lagi'), findsOneWidget);
    expect(find.text('1/3 Foto Batch'), findsOneWidget);

    // Product Info
    expect(find.text('Sayur & Buah'), findsOneWidget);
    expect(find.text('Sisa Sayuran & Kol'), findsOneWidget);
    expect(find.text('Harga Murah'), findsOneWidget);
    expect(find.text('3 kg (Tersedia)'), findsOneWidget);
    expect(find.text('Sortiran Bersih Tanpa Plastik'), findsOneWidget);

    // Seller Info
    expect(find.text('Toko Sayur Ibu Ida'), findsOneWidget);
    expect(find.text('Buka'), findsOneWidget);
    expect(find.text('Caringin, Lampung'), findsOneWidget);
    expect(find.text('2.8 km dari lokasi Anda'), findsOneWidget);
    expect(find.text('Jam Angkut Pagi-Siang'), findsOneWidget);
    expect(find.text('06:00 - 11:00 WIB'), findsOneWidget);
    expect(find.text('Lokasi Pengambilan'), findsOneWidget);

    // Pickup Guide
    expect(find.text('Akses Kendaraan Terbuka'), findsOneWidget);
    expect(find.text('Bawa Wadah / Karung Sendiri'), findsOneWidget);

    // Bottom Action Bar - Initial quantity is 1
    expect(find.text('1Kg'), findsOneWidget);
    expect(find.text('1 Kg dipilih'), findsOneWidget);

    // Increment Quantity to 2 Kg
    final addIcon = find.byIcon(Icons.add_rounded);
    await tester.tap(addIcon);
    await tester.pump();

    expect(find.text('2Kg'), findsOneWidget);
    expect(find.text('2 Kg dipilih'), findsOneWidget);
    expect(find.text('1.000'), findsOneWidget);

    // Test Pesan / Ambil Confirmation Dialog
    final orderBtn = find.text('Pesan / Ambil');
    await tester.tap(orderBtn);
    await tester.pumpAndSettle();

    expect(find.text('Konfirmasi Pengambilan'), findsOneWidget);
    expect(find.text('Konfirmasi'), findsOneWidget);

    // Tap Konfirmasi
    await tester.tap(find.text('Konfirmasi'));
    await tester.pumpAndSettle();

    expect(find.text('Konfirmasi Pengambilan'), findsNothing);
    expect(find.byType(CartPage), findsOneWidget);
  });

  testWidgets('CartPage displays items, updates total, and navigates to checkout',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      UserProfileManager().resetToDefault();
    });

    // Reset cart to default
    final cart = CartManager();
    cart.clearCart();
    cart.addItem(
      const FeedProduct(
        id: 'prod_2',
        sellerName: 'Toko Sayur Ibu Ida',
        name: 'Sisa Sayuran & Kol',
        category: 'Sayur & Buah',
        stock: '3 Kg',
        price: 500,
        priceUnit: '/Kg',
        distanceKm: 2.8,
        status: 'Segera',
        placeholderIcon: Icons.eco_rounded,
        placeholderColor: Color(0xFFDCFCE7),
        maxStockKg: 3,
      ),
      2,
    );
    // Unselect the second item as shown in the screenshot
    cart.addItem(
      const FeedProduct(
        id: 'prod_banana',
        sellerName: 'Warung Bu Rini',
        name: 'Pisang Kepok Matang',
        category: 'Sayur & Buah',
        stock: '5 tersedia',
        price: 2000,
        priceUnit: '/Sisir',
        distanceKm: 1.5,
        status: 'Tersedia',
        placeholderIcon: Icons.apple_rounded,
        placeholderColor: Color(0xFFFEF3C7),
        maxStockKg: 5,
      ),
      1,
    );
    cart.toggleItemSelection('prod_banana', false);

    await tester.pumpWidget(
      const MaterialApp(
        home: CartPage(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Header and Banner
    expect(find.text('AREA PAKAN'), findsOneWidget);
    expect(
      find.text('Pilih pesanan untuk melihat detail dan lanjut ke checkout.'),
      findsOneWidget,
    );

    // Verify Both stores and products are rendered
    expect(find.text('Toko Sayur Ibu Ida'), findsOneWidget);
    expect(find.text('Sisa Sayuran & Kol'), findsOneWidget);
    expect(find.text('Warung Bu Rini'), findsOneWidget);
    expect(find.text('Pisang Kepok Matang'), findsOneWidget);

    // Initial total is 2 * 500 = Rp1.000 (only prod_2 selected)
    expect(find.text('Rp1.000'), findsWidgets);
    expect(find.text('Checkout Pesanan'), findsOneWidget);

    // Tap "Pilih semua" to select all items
    await tester.tap(find.text('Pilih semua'));
    await tester.pumpAndSettle();

    // Now total is 1000 + 2000 = Rp3.000
    expect(find.text('Rp3.000'), findsWidgets);

    // Tap Checkout Pesanan
    await tester.tap(find.text('Checkout Pesanan'));
    await tester.pumpAndSettle();

    // Navigated to CheckoutPage
    expect(find.byType(CheckoutPage), findsOneWidget);
    expect(find.text('Checkout Pesanan'), findsOneWidget);
    expect(find.text('Buat Pesanan'), findsOneWidget);

    // Drag to reveal pickup info and payment summary
    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();

    expect(find.text('Informasi pengambilan'), findsOneWidget);
    expect(find.text('Ringkasan Pembayaran'), findsOneWidget);
    expect(find.text('Biaya Layanan FoodRescue'), findsOneWidget);
    expect(find.text('Gratis'), findsOneWidget);

    // Enter notes
    await tester.enterText(
      find.byType(TextField),
      'Bawa karung 50kg, sampai jam 10 pagi',
    );
    await tester.pump();

    // Tap Buat Pesanan
    await tester.tap(find.text('Buat Pesanan'));
    await tester.pumpAndSettle();

    // Navigated to OrderConfirmationPage (Checkout Pesanan screen)
    expect(find.byType(OrderConfirmationPage), findsOneWidget);
    expect(find.text('Checkout Pesanan'), findsOneWidget);
    expect(find.text('Menunggu Konfirmasi'), findsOneWidget);
    expect(find.text('MENUNGGU KONFIRMASI'), findsOneWidget);
    expect(find.text('Pesanan Anda sedang menunggu konfirmasi dari toko.'),
        findsOneWidget);
    expect(find.text('Nomor pesanan'), findsOneWidget);
    expect(find.text('Chat Toko'), findsOneWidget);
    expect(find.text('Lihat QR Pesanan'), findsOneWidget);

    // Tap back to return to BuyerHomeScreen
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // Navigated back to BuyerHomeScreen
    expect(find.byType(BuyerHomeScreen), findsOneWidget);
  });

  testWidgets('BuyerBottomNavBar displays all 5 menus and responds to taps',
      (WidgetTester tester) async {
    int selectedIndex = 1;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: StatefulBuilder(
            builder: (context, setState) {
              return BuyerBottomNavBar(
                currentIndex: selectedIndex,
                onTap: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              );
            },
          ),
        ),
      ),
    );

    // Verify all 5 menu labels exist
    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Pesanan Saya'), findsOneWidget);
    expect(find.text('Chat'), findsOneWidget);
    expect(find.text('Riwayat'), findsOneWidget);
    expect(find.text('Akun Saya'), findsOneWidget);

    // Tap Riwayat menu
    await tester.tap(find.text('Riwayat'));
    await tester.pumpAndSettle();
    expect(selectedIndex, equals(3));

    // Tap Akun Saya menu
    await tester.tap(find.text('Akun Saya'));
    await tester.pumpAndSettle();
    expect(selectedIndex, equals(4));

    // Tap Beranda menu
    await tester.tap(find.text('Beranda'));
    await tester.pumpAndSettle();
    expect(selectedIndex, equals(0));
  });

  testWidgets(
      'Transaction History flows into Order Detail, QR Pesanan, Chat Toko, and Cancel Order',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      UserProfileManager().resetToDefault();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: TransactionHistoryPage(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verify Transaction History UI components (Matching Screenshot 1)
    expect(find.text('Riwayat Transaksi'), findsOneWidget);
    expect(find.text('Total transaksi selesai'), findsOneWidget);
    expect(find.textContaining('transaksi'), findsWidgets);
    expect(find.text('Semua'), findsOneWidget);
    expect(find.text('Menunggu Konfirmasi'), findsOneWidget);
    expect(find.text('Diproses'), findsOneWidget);
    expect(find.text('Selesai'), findsOneWidget);
    expect(find.text('Dibatalkan'), findsOneWidget);

    // Verify list items exist
    expect(find.text('Sayuran Hijau & Kol'), findsWidgets);
    expect(find.textContaining('Toko Sayur Ibu Ida'), findsWidgets);

    // 2. Tap on the first transaction card (Sayuran Hijau & Kol)
    await tester.tap(find.text('Sayuran Hijau & Kol').first);
    await tester.pumpAndSettle();

    // 3. Verify Order Detail / Checkout Pesanan screen (Matching Screenshot 2)
    expect(find.byType(OrderConfirmationPage), findsOneWidget);
    expect(find.text('Checkout Pesanan'), findsOneWidget);
    expect(find.text('#PK-240318'), findsOneWidget);
    expect(find.text('Chat Toko'), findsOneWidget);
    expect(find.text('Lihat QR Pesanan'), findsOneWidget);
    expect(find.text('Batalkan Pesanan'), findsOneWidget);

    // 4. Tap "Lihat QR Pesanan" -> Navigates to QR Pesanan (Matching Screenshot 3)
    await tester.tap(find.text('Lihat QR Pesanan'));
    await tester.pumpAndSettle();

    expect(find.byType(OrderQrPage), findsOneWidget);
    expect(find.text('QR Pesanan'), findsOneWidget);
    expect(find.text('Jangan lupa ambil pesananmu'), findsOneWidget);
    expect(find.text('Kode pengambilan'), findsOneWidget);
    expect(find.text('PK-240318'), findsOneWidget);
    expect(find.text('Petunjuk Arah'), findsOneWidget);

    // Tap back to return to Order Detail
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.byType(OrderConfirmationPage), findsOneWidget);

    // 5. Tap "Chat Toko" -> Navigates to Store Chat Page (Matching Screenshot 4)
    await tester.tap(find.text('Chat Toko'));
    await tester.pumpAndSettle();

    expect(find.byType(StoreChatPage), findsOneWidget);
    expect(find.text('Toko Sayur Ibu Ida'), findsWidgets);
    expect(find.text('TENTANG PRODUK'), findsOneWidget);
    expect(find.text('Sisa Sayuran & Kol'), findsWidgets);
    expect(find.text('Balasan Cepat (Ketuk untuk kirim):'), findsOneWidget);
    expect(find.text('Baik, Terimakasih!'), findsOneWidget);

    // Test quick reply chip
    await tester.tap(find.text('Baik, Terimakasih!'));
    await tester.pumpAndSettle();
    expect(find.text('Baik, Terimakasih!'), findsWidgets);

    // Tap back to return to Order Detail
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.byType(OrderConfirmationPage), findsOneWidget);

    // 6. Test Cancel Order flow (Matching Section F)
    await tester.tap(find.text('Batalkan Pesanan'));
    await tester.pumpAndSettle();

    // Confirmation dialog appears
    expect(find.text('Batalkan Pesanan?'), findsOneWidget);
    expect(find.text('Kembali'), findsOneWidget);
    expect(find.text('Ya, Batalkan Pesanan'), findsOneWidget);

    // Confirm cancel
    await tester.tap(find.text('Ya, Batalkan Pesanan'));
    await tester.pumpAndSettle();

    // Order status updated
    expect(find.text('Pesanan Dibatalkan'), findsOneWidget);
    expect(find.text('DIBATALKAN'), findsWidgets);

    // Tap back to return to Transaction History
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.byType(TransactionHistoryPage), findsOneWidget);

    // Tap filter "Dibatalkan" (scroll horizontally into view if needed)
    await tester.ensureVisible(find.text('Dibatalkan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dibatalkan'));
    await tester.pumpAndSettle();
    expect(find.text('Sayuran Hijau & Kol'), findsWidgets);
  });

  testWidgets(
      'Order status lifecycle: checkout -> pending -> confirmed/processing -> ready -> completed / cancelled',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      UserProfileManager().resetToDefault();
    });

    final orderManager = OrderManager();
    const testOrderNumber = '#PK-TEST-STATUS';

    // 1. Create order with initial status pendingConfirmation
    final newOrder = OrderModel(
      orderNumber: testOrderNumber,
      items: const [],
      storeName: 'Toko Uji Coba',
      storeAddress: 'Jl. Uji Coba, Bandar Lampung',
      distanceKm: 1.5,
      pickupSchedule: 'Hari ini',
      pickupTime: 'Hari ini, 14:00 WIB',
      notes: 'Uji status pesanan',
      subtotal: 5000,
      fee: 0,
      total: 5000,
      createdAt: DateTime.now(),
      orderStatus: OrderStatus.pendingConfirmation,
      displayProductName: 'Pakan Organik Test',
      displayQuantity: '5 Kg',
    );
    orderManager.addOrder(newOrder);

    // 2. Open Riwayat Transaksi and check filter 'Menunggu Konfirmasi'
    await tester.pumpWidget(
      const MaterialApp(
        home: TransactionHistoryPage(),
      ),
    );
    await tester.pumpAndSettle();

    // Tap filter "Menunggu Konfirmasi"
    await tester.tap(find.text('Menunggu Konfirmasi'));
    await tester.pumpAndSettle();

    // Verify order appears in filter Menunggu Konfirmasi
    expect(find.text('Pakan Organik Test'), findsOneWidget);
    expect(find.text('MENUNGGU KONFIRMASI'), findsWidgets);

    // Tap the order card to open OrderConfirmationPage
    await tester.tap(find.text('Pakan Organik Test'));
    await tester.pumpAndSettle();

    expect(find.byType(OrderConfirmationPage), findsOneWidget);
    expect(find.text('Menunggu Konfirmasi'), findsOneWidget);
    expect(find.text('MENUNGGU KONFIRMASI'), findsWidgets);
    expect(find.text('Pesanan Anda sedang menunggu konfirmasi dari toko.'),
        findsOneWidget);

    // 3. Simulate seller confirming order via repository: confirmOrderBySeller
    orderManager.confirmOrderBySeller(testOrderNumber);
    await tester.pumpAndSettle();

    // Verify order status reactively updated to Diproses
    expect(find.text('Pesanan Diproses'), findsOneWidget);
    expect(find.text('DIPROSES'), findsWidgets);
    expect(find.text('Pesanan Anda sedang disiapkan oleh toko.'),
        findsOneWidget);

    // 4. Return to Riwayat Transaksi and check filter 'Diproses'
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // Tap filter "Diproses"
    await tester.tap(find.text('Diproses'));
    await tester.pumpAndSettle();
    expect(find.text('Pakan Organik Test'), findsOneWidget);

    // 5. Simulate seller marking ready for pickup: markOrderReadyForPickup
    orderManager.markOrderReadyForPickup(testOrderNumber);
    await tester.pumpAndSettle();

    // Open detail again
    await tester.tap(find.text('Pakan Organik Test'));
    await tester.pumpAndSettle();

    expect(find.text('Siap Diambil'), findsOneWidget);
    expect(find.text('SIAP DIAMBIL'), findsWidgets);

    // Check QR Page reflects active state
    await tester.tap(find.text('Lihat QR Pesanan'));
    await tester.pumpAndSettle();
    expect(find.byType(OrderQrPage), findsOneWidget);
    expect(find.text('Jangan lupa ambil pesananmu'), findsOneWidget);
    expect(find.text('SIAP DIAMBIL'), findsWidgets);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // 6. Simulate completing order: completeOrder
    orderManager.completeOrder(testOrderNumber);
    await tester.pumpAndSettle();

    expect(find.text('Pesanan Selesai'), findsOneWidget);
    expect(find.text('SELESAI'), findsWidgets);
    // Batalkan Pesanan should be hidden for completed orders
    expect(find.text('Batalkan Pesanan'), findsNothing);

    // 7. Verify in Riwayat Transaksi filter 'Selesai'
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Selesai'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Selesai'));
    await tester.pumpAndSettle();
    expect(find.text('Pakan Organik Test'), findsOneWidget);
  });

  testWidgets(
      'ChatListPage renders Pesan header, filters, search, and navigates to StoreChatPage',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      UserProfileManager().resetToDefault();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: ChatListPage(showBottomNav: true),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verify Header and Subtitle
    expect(find.text('Pesan'), findsOneWidget);
    expect(find.text('Chat dengan toko langgananmu'), findsOneWidget);

    // 2. Verify Search placeholder
    expect(find.text('Cari nama toko atau pesan'), findsOneWidget);

    // 3. Verify 3 Pill Filters
    expect(find.text('Semua'), findsOneWidget);
    expect(find.text('Belum dibaca'), findsOneWidget);
    expect(find.text('Pernah membeli'), findsWidgets);

    // 4. Verify conversation items
    expect(find.text('Toko Sayur Ibu Ida'), findsOneWidget);
    expect(find.text('Toko Buah Ibu Rina'), findsOneWidget);
    expect(find.text('Toko Sayur Mas Kipli'), findsOneWidget);
    expect(find.text('Toko Buah Makmur'), findsOneWidget);

    // 5. Test Filter "Belum dibaca"
    await tester.tap(find.text('Belum dibaca'));
    await tester.pumpAndSettle();

    expect(find.text('Toko Sayur Ibu Ida'), findsOneWidget);
    expect(find.text('Toko Buah Ibu Rina'), findsOneWidget);
    expect(find.text('Toko Sayur Mas Kipli'), findsNothing);
    expect(find.text('Toko Buah Makmur'), findsNothing);

    // 6. Test Filter "Pernah membeli"
    await tester.tap(find.text('Pernah membeli').first);
    await tester.pumpAndSettle();

    expect(find.text('Toko Sayur Ibu Ida'), findsOneWidget);
    expect(find.text('Toko Buah Ibu Rina'), findsOneWidget);
    expect(find.text('Toko Buah Makmur'), findsOneWidget);
    expect(find.text('Toko Sayur Mas Kipli'), findsNothing);

    // Return to "Semua"
    await tester.tap(find.text('Semua'));
    await tester.pumpAndSettle();

    // 7. Test Search Functionality
    await tester.enterText(
        find.widgetWithText(TextField, 'Cari nama toko atau pesan'), 'Kipli');
    await tester.pumpAndSettle();

    expect(find.text('Toko Sayur Mas Kipli'), findsOneWidget);
    expect(find.text('Toko Sayur Ibu Ida'), findsNothing);

    // Search by message content
    await tester.enterText(
        find.widgetWithText(TextField, 'Cari nama toko atau pesan'),
        'ampas tahu');
    await tester.pumpAndSettle();
    expect(find.text('Toko Sayur Mas Kipli'), findsOneWidget);

    // Search nonexistent
    await tester.enterText(
        find.widgetWithText(TextField, 'Cari nama toko atau pesan'),
        'xyz123random');
    await tester.pumpAndSettle();
    expect(find.text('Tidak ada pesan ditemukan'), findsOneWidget);

    // Clear search
    await tester.enterText(
        find.widgetWithText(TextField, 'Cari nama toko atau pesan'), '');
    await tester.pumpAndSettle();

    // 8. Test Tap Conversation -> Navigates to StoreChatPage
    await tester.tap(find.text('Toko Sayur Ibu Ida'));
    await tester.pumpAndSettle();

    expect(find.byType(StoreChatPage), findsOneWidget);
    expect(find.text('Toko Sayur Ibu Ida'), findsWidgets);

    // Pop back to ChatListPage
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.byType(ChatListPage), findsOneWidget);
  });

  testWidgets(
      'BuyerProfilePage renders header, profile card, preferences, security, and handles logout',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      UserProfileManager().resetToDefault();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: BuyerProfilePage(showBottomNav: true),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verify Header
    expect(find.text('Akun Saya'), findsWidgets);

    // 2. Verify Profile Card (Matching Screenshot media_1794370199378_944bf4ed.jpg)
    expect(find.text('Parman Pratama'), findsOneWidget);
    expect(find.text('Pembeli sejak Maret 2024'), findsOneWidget);
    expect(find.text('Edit Data Diri'), findsOneWidget);

    // Test tap Edit Data Diri -> opens EditProfilePage
    await tester.tap(find.text('Edit Data Diri'));
    await tester.pumpAndSettle();
    expect(find.byType(EditProfilePage), findsOneWidget);
    // Tap Batal to return to BuyerProfilePage
    await tester.tap(find.text('Batal'));
    await tester.pumpAndSettle();
    expect(find.byType(BuyerProfilePage), findsOneWidget);

    // 3. Verify Section Notifikasi & Preferensi
    expect(find.text('Notifikasi & Preferensi'), findsOneWidget);
    expect(find.text('Notifikasi & Push Notifikasi'), findsOneWidget);
    expect(find.text('Pemberitahuan instan saat ada pemberitahuan terbaru'),
        findsOneWidget);
    expect(find.text('Bantuan & Pusat Edukasi Pangan'), findsOneWidget);
    expect(find.text('Panduan pembelian stok pangan dan SOP surplus'),
        findsOneWidget);
    expect(find.text('Kebijakan & Ketentuan Pembeli FoodRescue'),
        findsOneWidget);
    expect(find.text('Aturan pembelian produk untuk pakan ternak dan lain lain'),
        findsOneWidget);

    // Test toggle Switch
    final switchFinder = find.byType(Switch);
    expect(switchFinder, findsOneWidget);
    await tester.tap(switchFinder);
    await tester.pumpAndSettle();

    // Test open Bantuan & Pusat Edukasi Pangan
    await tester.tap(find.text('Bantuan & Pusat Edukasi Pangan'));
    await tester.pumpAndSettle();
    expect(find.text('Panduan Pembelian & SOP Surplus Pakan:'), findsOneWidget);
    await tester.tap(find.text('Tutup Panduan'));
    await tester.pumpAndSettle();

    // Test open Kebijakan & Ketentuan
    await tester.tap(find.text('Kebijakan & Ketentuan Pembeli FoodRescue'));
    await tester.pumpAndSettle();
    expect(find.text('Aturan Pembelian Surplus Pakan:'), findsOneWidget);
    await tester.tap(find.text('Saya Mengerti'));
    await tester.pumpAndSettle();

    // 4. Verify Section Akun & Keamanan
    expect(find.text('Akun & Keamanan'), findsOneWidget);
    expect(find.text('Ganti Kata Sandi & PIN Keamanan'), findsOneWidget);
    expect(find.text('PIN 6-digit untuk verifikasi pencairan dana'),
        findsOneWidget);

    // Test open Ganti Kata Sandi & PIN Keamanan
    await tester.tap(find.text('Ganti Kata Sandi & PIN Keamanan'));
    await tester.pumpAndSettle();
    expect(find.text('Keamanan Akun Pembeli:'), findsOneWidget);
    expect(find.text('Ubah Kata Sandi'), findsOneWidget);
    expect(find.text('PIN Transaksi 6-Digit'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();

    // 5. Test Tombol Keluar dari akun & Confirmation Dialog
    expect(find.text('Keluar dari akun'), findsOneWidget);
    await tester.tap(find.text('Keluar dari akun'));
    await tester.pumpAndSettle();

    // Dialog appears
    expect(find.text('Keluar dari Akun?'), findsOneWidget);
    expect(find.text('Apakah Anda yakin ingin keluar dari akun?'),
        findsOneWidget);
    expect(find.text('Batal'), findsOneWidget);
    expect(find.text('Keluar'), findsOneWidget);

    // Test cancel
    await tester.tap(find.text('Batal'));
    await tester.pumpAndSettle();
    expect(find.text('Keluar dari Akun?'), findsNothing);

    // Test confirm logout
    await tester.tap(find.text('Keluar dari akun'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Keluar'));
    await tester.pumpAndSettle();

    // Navigates to AuthScreen
    expect(find.byType(AuthScreen), findsOneWidget);
  });

  testWidgets(
      'EditProfilePage renders form, validates fields, updates profile and synchronizes with BuyerProfilePage',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      UserProfileManager().resetToDefault();
    });

    UserProfileManager().resetToDefault();

    await tester.pumpWidget(
      const MaterialApp(
        home: BuyerProfilePage(showBottomNav: true),
      ),
    );
    await tester.pumpAndSettle();

    // Verify initial profile card
    expect(find.text('Parman Pratama'), findsOneWidget);
    expect(find.text('Pembeli sejak Maret 2024'), findsOneWidget);

    // Tap Edit Data Diri to navigate to EditProfilePage
    await tester.tap(find.text('Edit Data Diri'));
    await tester.pumpAndSettle();
    expect(find.byType(EditProfilePage), findsOneWidget);

    // 1. Verify AppBar and Title
    expect(find.text('Edit Profil'), findsOneWidget);

    // 2. Verify Avatar & Ubah foto profil
    expect(find.text('Ubah foto profil'), findsOneWidget);
    await tester.tap(find.text('Ubah foto profil'));
    await tester.pumpAndSettle();
    expect(find.text('Pilih dari Galeri'), findsOneWidget);
    expect(find.text('Ambil dari Kamera'), findsOneWidget);
    // Pick photo
    await tester.tap(find.text('Pilih dari Galeri'));
    await tester.pumpAndSettle();
    expect(
        find.text('Foto profil berhasil dipilih dari galeri.'), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // 3. Verify Form Fields matching screenshot
    expect(find.text('Nama lengkap'), findsOneWidget);
    expect(find.text('Nomor telepon'), findsOneWidget);
    expect(find.text('+62'), findsOneWidget);
    expect(find.text('Nomor ini digunakan untuk info pesanan.'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Lokasi utama'), findsOneWidget);
    expect(find.text('Bandar Lampung'), findsOneWidget);

    // 4. Verify Security Card
    expect(
        find.text(
            'Data diri Anda tersimpan dengan aman dan hanya digunakan untuk kebutuhan transaksi.'),
        findsOneWidget);

    // 5. Test validation: Empty name
    final nameField = find.byKey(const Key('edit_name_field'));
    await tester.ensureVisible(nameField);
    await tester.enterText(nameField, '');
    await tester.ensureVisible(find.byKey(const Key('edit_save_button')));
    await tester.tap(find.byKey(const Key('edit_save_button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Nama lengkap tidak boleh kosong.'), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    // Restore and test invalid email
    await tester.ensureVisible(nameField);
    await tester.enterText(nameField, 'Parman Alghifari');
    final emailField = find.byKey(const Key('edit_email_field'));
    await tester.ensureVisible(emailField);
    await tester.enterText(emailField, 'invalid-email');
    await tester.ensureVisible(find.byKey(const Key('edit_save_button')));
    await tester.tap(find.byKey(const Key('edit_save_button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Format email tidak valid.'), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    // Valid email
    await tester.ensureVisible(emailField);
    await tester.enterText(emailField, 'parman.new@gmail.com');

    // Test changing location
    await tester.ensureVisible(find.text('Bandar Lampung'));
    await tester.tap(find.text('Bandar Lampung'));
    await tester.pumpAndSettle();
    expect(find.text('Pilih Lokasi Utama'), findsOneWidget);
    expect(find.text('Lampung Selatan'), findsOneWidget);
    await tester.tap(find.text('Lampung Selatan'));
    await tester.pumpAndSettle();
    expect(find.text('Lampung Selatan'), findsOneWidget);

    // 6. Save changes
    await tester.ensureVisible(find.byKey(const Key('edit_save_button')));
    await tester.tap(find.byKey(const Key('edit_save_button')));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // Verify back on BuyerProfilePage with updated data
    expect(find.byType(BuyerProfilePage), findsOneWidget);
    expect(find.text('Parman Alghifari'), findsOneWidget);
  });
}
