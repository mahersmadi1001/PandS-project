class SettingsEntity {
  final String userId;
  final bool darkMode;
  final String language;
  final bool notificationsEnabled;

  const SettingsEntity({
    required this.userId,
    this.darkMode = false,
    this.language = 'en',
    this.notificationsEnabled = true,
  });

  SettingsEntity copyWith({
    String? userId,
    bool? darkMode,
    String? language,
    bool? notificationsEnabled,
  }) {
    return SettingsEntity(
      userId: userId ?? this.userId,
      darkMode: darkMode ?? this.darkMode,
      language: language ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}
