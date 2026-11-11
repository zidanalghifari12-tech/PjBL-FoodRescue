import 'package:flutter/material.dart';
import 'package:foodrescue/features/profile/models/user_profile_model.dart';

class UserProfileManager extends ChangeNotifier {
  static final UserProfileManager _instance = UserProfileManager._internal();
  factory UserProfileManager() => _instance;

  UserProfileManager._internal();

  static const UserProfileModel _initialProfile = UserProfileModel(
    id: 'user_001',
    name: 'Parman Pratama',
    email: 'parmanpratama01@gmail.com',
    phone: '812 3456 7890',
    memberSince: 'Pembeli sejak Maret 2024',
    location: 'Bandar Lampung',
    isPushNotificationEnabled: true,
  );

  UserProfileModel _profile = _initialProfile;

  UserProfileModel get profile => _profile;

  void setPushNotification(bool enabled) {
    _profile = _profile.copyWith(isPushNotificationEnabled: enabled);
    notifyListeners();
  }

  void updateProfile({
    String? name,
    String? email,
    String? phone,
    String? memberSince,
    String? location,
    String? avatarUrl,
    String? avatarImagePath,
    bool clearAvatarImage = false,
  }) {
    _profile = _profile.copyWith(
      name: name,
      email: email,
      phone: phone,
      memberSince: memberSince,
      location: location,
      avatarUrl: avatarUrl,
      avatarImagePath: avatarImagePath,
      clearAvatarImage: clearAvatarImage,
    );
    notifyListeners();
  }

  /// Mengembalikan data profil ke kondisi awal (default)
  /// dan membersihkan avatar kustom jika ada.
  void resetToDefault() {
    _profile = _initialProfile;
    notifyListeners();
  }
}
