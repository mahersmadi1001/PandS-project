import 'package:p/features/profile/domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel({
    required String uid,
    required String name,
    required String email,
    String bio = '',
    String profession = '',
    List<String> skills = const [],
    String profileImageUrl = '',
    String profileLink = '',
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
          uid: uid,
          name: name,
          email: email,
          bio: bio,
          profession: profession,
          skills: skills,
          profileImageUrl: profileImageUrl,
          profileLink: profileLink,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory ProfileModel.fromEntity(ProfileEntity entity) {
    return ProfileModel(
      uid: entity.uid,
      name: entity.name,
      email: entity.email,
      bio: entity.bio,
      profession: entity.profession,
      skills: entity.skills,
      profileImageUrl: entity.profileImageUrl,
      profileLink: entity.profileLink,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      uid: map['uid'] ?? '',
      name: map['full_name'] ?? '',
      email: map['email'] ?? '',
      bio: map['bio'] ?? '',
      profession: map['profession'] ?? '',
      skills: List<String>.from(map['skills'] ?? []),
      profileImageUrl: map['profileImageUrl'] ?? '',
      profileLink: map['profileLink'] ?? '',
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        map['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  ProfileEntity toEntity() {
    return ProfileEntity(
      uid: uid,
      name: name,
      email: email,
      bio: bio,
      profession: profession,
      skills: skills,
      profileImageUrl: profileImageUrl,
      profileLink: profileLink,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
