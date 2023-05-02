import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../models/failure.dart';
import '../models/profile.dart';
import '../type_defs.dart';

import 'base_providers.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
  ),
);

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _auth = auth,
        _firestore = firestore;

  CollectionReference get _users => _firestore.collection('users');

  Stream<User?> get authStateChange => _auth.authStateChanges();

  FutureEither<Profile> signIn() async {
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: 'c@c.com',
        password: 'asdfasdf',
      );
      Profile userModel = await getProfileData(cred.user!.uid).first;
      return right(userModel);
    } on FirebaseException catch (e) {
      return left(Failure(e.message!));
      // throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<Profile> getProfileData(String uid) {
    return _users
        .doc(uid)
        .snapshots()
        .map((event) => Profile.fromMap(event.data() as Map<String, dynamic>));
  }

  void logOut() async {
    await _auth.signOut();
  }
}
