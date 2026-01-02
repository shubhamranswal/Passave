class AvatarRegistry {
  static const avatars = {
    'avatar_def': 'assets/images/avatars/avatar_def.png',
    'avatar_1': 'assets/images/avatars/avatar_1.png',
    'avatar_2': 'assets/images/avatars/avatar_2.png',
    'avatar_3': 'assets/images/avatars/avatar_3.png',
    'avatar_4': 'assets/images/avatars/avatar_4.png',
    'avatar_5': 'assets/images/avatars/avatar_5.png',
    'avatar_6': 'assets/images/avatars/avatar_6.png',
    'avatar_7': 'assets/images/avatars/avatar_7.png',
  };

  static String defaultAvatar() => 'avatar_def';

  static String path(String avatarId) {
    return avatars[avatarId] ?? avatars.values.first;
  }
}
