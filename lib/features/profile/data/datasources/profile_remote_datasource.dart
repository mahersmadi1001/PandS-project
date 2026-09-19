import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:p/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileEntity?> getProfile(String uid);
  Future<void> updateProfile(String uid, Map<String, dynamic> data);
  Future<void> updateProfileImage(String uid, String imageUrl);
  Future<void> removeProfileImage(String uid);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseFirestore _firestore;

  ProfileRemoteDataSourceImpl({required FirebaseFirestore firestore})
      : _firestore = firestore;

  @override
  Future<ProfileEntity?> getProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return ProfileEntity.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting profile from remote: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateProfile(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(uid).update(data);
    } catch (e) {
      print('Error updating profile in remote: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateProfileImage(String uid, String imageUrl) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'profileImageUrl': imageUrl,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error updating profile image in remote: $e');
      rethrow;
    }
  }

  @override
  Future<void> removeProfileImage(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'profileImageUrl': '',
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error removing profile image from remote: $e');
      rethrow;
    }
  }
}
