// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:p/features/auth/data/models/user_model.dart';

import 'package:p/features/auth/domain/entities/user.dart';

class RemoteDataSources {
  final FirebaseFirestore firestore;
  RemoteDataSources({required this.firestore});

  Future<UserEntity> getSavedSession() {
    throw UnimplementedError();
  }

  Future<UserEntity> login(String email, String password) {
    throw UnimplementedError();
  }

  Future<void> logout() {
    throw UnimplementedError();
  }

  Future<void> register({required UserModel user}) async {
    final check = await firestore
        .collection("users")
        .where("email", isEqualTo: user.email)
        .get();
    if (check.docs.isNotEmpty) {
      throw Exception("email is found alrady");
    }
    await firestore.collection("users").doc(user.uId).set(user.toMap());
  }
}
