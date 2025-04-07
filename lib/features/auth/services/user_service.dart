import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/user_role.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'users';

  Future<UserModel> createUser({
    required String id,
    required String email,
    required String name,
    required UserRole role,
  }) async {
    final now = DateTime.now();
    final user = UserModel(
      id: id,
      email: email,
      name: name,
      role: role,
      createdAt: now,
      updatedAt: now,
    );

    await _firestore.collection(_collection).doc(id).set(user.toFirestore());
    return user;
  }

  Future<UserModel?> getUser(String id) async {
    final doc = await _firestore.collection(_collection).doc(id).get();
    if (!doc.exists) return null;
    return UserModel.fromFirestore(doc);
  }

  Future<void> updateUser(UserModel user) async {
    final updatedUser = user.copyWith(updatedAt: DateTime.now());
    await _firestore
        .collection(_collection)
        .doc(user.id)
        .update(updatedUser.toFirestore());
  }

  Future<void> deleteUser(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }

  Stream<UserModel?> userStream(String id) {
    return _firestore
        .collection(_collection)
        .doc(id)
        .snapshots()
        .map((doc) => doc.exists ? UserModel.fromFirestore(doc) : null);
  }
}
