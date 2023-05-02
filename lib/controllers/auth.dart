import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/profile.dart';
import '../repo/auth.dart';
import '../widgets/snackbar.dart';

final profileProvider = StateProvider<Profile?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  ),
);

final authStateChangesProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChanges;
});

final getProfileDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getProfileData(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({
    required AuthRepository authRepository,
    required Ref ref,
  })  : _authRepository = authRepository,
        _ref = ref,
        super(false);

  Stream<User?> get authStateChanges => _authRepository.authStateChanges;

  Stream<Profile> getProfileData(String uid) {
    return _authRepository.getProfileData(uid);
  }

  void signIn(String email, String password, BuildContext context) async {
    state = true;
    final user = await _authRepository.signIn(email, password);
    state = false;
    user.fold(
      (l) => showSnackBar(context, l.message),
      (profile) =>
          _ref.read(profileProvider.notifier).update((state) => profile),
    );
  }

  void logout() async {
    _authRepository.logOut();
  }
}
