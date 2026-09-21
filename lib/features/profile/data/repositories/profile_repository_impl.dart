import 'dart:io';
import 'package:p/features/profile/data/datasources/profile_local_datasource.dart';
import 'package:p/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:p/features/profile/domain/entities/profile_entity.dart';
import 'package:p/features/profile/domain/repositories/profile_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;
  final FirebaseFirestore firestore;
  final SupabaseClient supabase;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.firestore,
    required this.supabase,
  });

  @override
  Future<ProfileEntity?> getProfile(String uid) async {
    try {
      final cachedProfile = await localDataSource.getCachedProfile(uid);
      if (cachedProfile != null) {
        return cachedProfile;
      }

      final profile = await remoteDataSource.getProfile(uid);
      if (profile != null) {
        await localDataSource.cacheProfile(profile);
      }
      return profile;
    } catch (e) {
      print('Error getting profile: $e');
      rethrow;
    }
  }

  @override
  Future<void> saveProfile(ProfileEntity profile) async {
    try {
      await remoteDataSource.updateProfile(profile.uid, profile.toMap());
      await localDataSource.cacheProfile(profile);
      print('Profile saved successfully');
    } catch (e) {
      print('Error saving profile: $e');
      rethrow;
    }
  }

  @override
  Future<String?> uploadProfileImage(String uid, String filePath) async {
    try {
      final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = File(filePath);

      await supabase.storage.from('profiles').upload(fileName, file);

      final publicUrl = await supabase.storage
          .from('profiles')
          .getPublicUrl(fileName);

      await remoteDataSource.updateProfileImage(uid, publicUrl);
      print('Profile image uploaded successfully: $publicUrl');
      return publicUrl;
    } catch (e) {
      print('Error uploading profile image: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteProfileImage(String uid) async {
    try {
      final profileDoc = await firestore.collection('users').doc(uid).get();
      if (profileDoc.exists) {
        final profileData = profileDoc.data() as Map<String, dynamic>;
        final imageUrl = profileData['profileImageUrl'] as String?;

        if (imageUrl != null && imageUrl.isNotEmpty) {
          final uri = Uri.parse(imageUrl);
          final segments = uri.pathSegments;
          final fileName = segments.isNotEmpty ? segments.last : '';

          if (fileName.isNotEmpty) {
            await supabase.storage.from('profiles').remove([fileName]);
            print('Profile image deleted from storage: $fileName');
          }

          await remoteDataSource.removeProfileImage(uid);
          print('Profile image removed from profile');
        }
      }
    } catch (e) {
      print('Error deleting profile image: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateProfile(ProfileEntity profile) async {
    try {
      await remoteDataSource.updateProfile(profile.uid, profile.toMap());
      await localDataSource.cacheProfile(profile);
      print('Profile updated successfully');
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }

  @override
  Future<String> generateProfileLink(String uid) async {
    try {
      final profileLink = 'https://yourapp.com/profile/$uid';

      await remoteDataSource.updateProfile(uid, {
        'profileLink': profileLink,
        'updatedAt': DateTime.now().toIso8601String(),
      });

      print('Profile link generated: $profileLink');
      return profileLink;
    } catch (e) {
      print('Error generating profile link: $e');
      rethrow;
    }
  }
}
