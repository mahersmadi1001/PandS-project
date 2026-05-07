import 'dart:io';
import 'package:p/features/profile/domain/entities/profile_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ProfileRepository {
  Future<ProfileEntity?> getProfile(String uid);
  Future<void> saveProfile(ProfileEntity profile);
  Future<String?> uploadProfileImage(String uid, String filePath);
  Future<void> deleteProfileImage(String uid);
  Future<void> updateProfile(ProfileEntity profile);
  Future<String> generateProfileLink(String uid);
}

class ProfileRepositoryImpl implements ProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Future<ProfileEntity?> getProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return ProfileEntity.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting profile: $e');
      return null;
    }
  }

  @override
  Future<void> saveProfile(ProfileEntity profile) async {
    try {
      await _firestore
          .collection('users')
          .doc(profile.uid)
          .set(profile.toMap());
      print('Profile saved successfully');
    } catch (e) {
      print('Error saving profile: $e');
      throw Exception('Failed to save profile: $e');
    }
  }

  @override
  Future<String?> uploadProfileImage(String uid, String filePath) async {
    try {
      final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = File(filePath);

      final response = await _supabase.storage
          .from('profiles')
          .upload(fileName, file);

      if (response != null) {
        final publicUrl = await _supabase.storage
            .from('profiles')
            .getPublicUrl(fileName);

        // Update profile with new image URL
        await _firestore.collection('users').doc(uid).update({
          'profileImageUrl': publicUrl,
          'updatedAt': DateTime.now().toIso8601String(),
        });

        print('Profile image uploaded successfully: $publicUrl');
        return publicUrl;
      }
      return null;
    } catch (e) {
      print('Error uploading profile image: $e');
      return null;
    }
  }

  @override
  Future<void> deleteProfileImage(String uid) async {
    try {
      // Get current profile to find image URL
      final profileDoc = await _firestore.collection('users').doc(uid).get();
      if (profileDoc.exists) {
        final profileData = profileDoc.data() as Map<String, dynamic>;
        final imageUrl = profileData['profileImageUrl'] as String?;

        if (imageUrl != null && imageUrl.isNotEmpty) {
          // Extract file name from URL
          final uri = Uri.parse(imageUrl);
          final segments = uri.pathSegments;
          final fileName = segments.isNotEmpty ? segments.last : '';

          if (fileName.isNotEmpty) {
            // Delete from Supabase storage
            await _supabase.storage.from('profiles').remove([fileName]);
            print('Profile image deleted from storage: $fileName');
          }

          // Update profile to remove image URL
          await _firestore.collection('users').doc(uid).update({
            'profileImageUrl': '',
            'updatedAt': DateTime.now().toIso8601String(),
          });

          print('Profile image removed from profile');
        }
      }
    } catch (e) {
      print('Error deleting profile image: $e');
      throw Exception('Failed to delete profile image: $e');
    }
  }

  @override
  Future<void> updateProfile(ProfileEntity profile) async {
    try {
      await _firestore
          .collection('users')
          .doc(profile.uid)
          .update(profile.toMap());
      print('Profile updated successfully');
    } catch (e) {
      print('Error updating profile: $e');
      throw Exception('Failed to update profile: $e');
    }
  }

  @override
  Future<String> generateProfileLink(String uid) async {
    try {
      final profileLink = 'https://yourapp.com/profile/$uid';

      // Save profile link to Firestore
      await _firestore.collection('users').doc(uid).update({
        'profileLink': profileLink,
        'updatedAt': DateTime.now().toIso8601String(),
      });

      print('Profile link generated: $profileLink');
      return profileLink;
    } catch (e) {
      print('Error generating profile link: $e');
      throw Exception('Failed to generate profile link: $e');
    }
  }
}
