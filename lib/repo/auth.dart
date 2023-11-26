import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../models/failure.dart';
import '../models/profile.dart';
import '../type_defs.dart';

import 'firebase.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
      auth: ref.read(authProvider),
      firestore: ref.read(firestoreProvider),
      functions: ref.read(functionsProvider)),
);

class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseFunctions _functions;

  AuthRepository({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required FirebaseFunctions functions,
  })  : _auth = auth,
        _firestore = firestore,
        _functions = functions;

  CollectionReference get _profiles => _firestore.collection('profiles');

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  FutureEither<Profile> signIn(String email, String password) async {
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Profile profile = await getProfileData(cred.user!.uid).first;

      return right(profile);
    } on FirebaseException catch (e) {
      return left(Failure(e.message!));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<Profile> signUp(String email, String password) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = cred.user!.uid;

      await _profiles.doc(uid).set({
        'firstName': 'Tester',
        'email': email,
      });

      Profile profile = await getProfileData(uid).first;

      return right(profile);
    } on FirebaseException catch (e) {
      return left(Failure(e.message!));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<Profile> getProfileData(String uid) {
    return _profiles
        .doc(uid)
        .snapshots()
        .map((doc) => Profile.fromFirestore(doc));
  }

  Future<Map> deleteUser(String email) async {
    final deleteFunction = _functions.httpsCallable('deleteUser');
    try {
      final result = await deleteFunction.call(
        {
          "email": email,
        },
      );
      Map<String, dynamic> response = result.data;
      return response;
    } on FirebaseFunctionsException catch (error) {
      debugPrint("\nFirebase Exception!");
      debugPrint("Code: ${error.code}");
      debugPrint("Details: ${error.details}");
      debugPrint("Message: ${error.message}");
      return {'result': false};
    } catch (e) {
      debugPrint("\nNon-Firebase Exception!");
      debugPrint(e.toString());
      return {'result': false};
    }
  }

  void logOut() async {
    await _auth.signOut();
  }
}
