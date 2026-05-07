class ProfileEntity {
  final String uid;
  final String name;
  final String email;
  final String bio;
  final String profession;
  final List<String> skills;
  final String profileImageUrl;
  final String profileLink;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProfileEntity({
    required this.uid,
    required this.name,
    required this.email,
    this.bio = '',
    this.profession = '',
    this.skills = const [],
    this.profileImageUrl = '',
    this.profileLink = '',
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'bio': bio,
      'profession': profession,
      'skills': skills,
      'profileImageUrl': profileImageUrl,
      'profileLink': profileLink,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory ProfileEntity.fromMap(Map<String, dynamic> map) {
    return ProfileEntity(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      bio: map['bio'] ?? '',
      profession: map['profession'] ?? '',
      skills: List<String>.from(map['skills'] ?? []),
      profileImageUrl: map['profileImageUrl'] ?? '',
      profileLink: map['profileLink'] ?? '',
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(map['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  ProfileEntity copyWith({
    String? name,
    String? email,
    String? bio,
    String? profession,
    List<String>? skills,
    String? profileImageUrl,
    String? profileLink,
    DateTime? updatedAt,
  }) {
    return ProfileEntity(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      profession: profession ?? this.profession,
      skills: skills ?? this.skills,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      profileLink: profileLink ?? this.profileLink,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProfileEntity &&
        other.uid == uid &&
        other.name == name &&
        other.email == email &&
        other.bio == bio &&
        other.profession == profession &&
        other.profileImageUrl == profileImageUrl &&
        other.profileLink == profileLink;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        email.hashCode ^
        bio.hashCode ^
        profession.hashCode ^
        profileImageUrl.hashCode ^
        profileLink.hashCode;
  }
}
