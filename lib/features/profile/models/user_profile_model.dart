class UserProfileModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String memberSince;
  final String location;
  final String? avatarUrl;
  final String? avatarImagePath;
  final bool isPushNotificationEnabled;

  const UserProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.memberSince,
    this.location = 'Bandar Lampung',
    this.avatarUrl,
    this.avatarImagePath,
    this.isPushNotificationEnabled = true,
  });

  UserProfileModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? memberSince,
    String? location,
    String? avatarUrl,
    String? avatarImagePath,
    bool clearAvatarImage = false,
    bool? isPushNotificationEnabled,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      memberSince: memberSince ?? this.memberSince,
      location: location ?? this.location,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      avatarImagePath:
          clearAvatarImage ? null : (avatarImagePath ?? this.avatarImagePath),
      isPushNotificationEnabled:
          isPushNotificationEnabled ?? this.isPushNotificationEnabled,
    );
  }
}
