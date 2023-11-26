import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'firebase.g.dart';

@riverpod
FirebaseAuth auth(AuthRef ref) => FirebaseAuth.instance;

@riverpod
FirebaseFirestore firestore(FirestoreRef ref) => FirebaseFirestore.instance;

@riverpod
FirebaseFunctions functions(FunctionsRef ref) => FirebaseFunctions.instance;
