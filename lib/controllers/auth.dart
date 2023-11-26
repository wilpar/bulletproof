import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/profile.dart';
import '../repo/auth.dart';
import '../widgets/snackbar.dart';

import 'profile.dart';

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
    user.fold(
      (l) => showSnackBar(context, l.message),
      (profile) {
        // _ref.read(profileProvider.notifier).update((state) => profile);
        _ref.read(userProfileProvider.notifier).update(profile);
      },
    );
    state = false;
  }

  void signUp(BuildContext context, String email, String password) async {
    state = true;
    final user = await _authRepository.signUp(email, password);
    user.fold(
      (l) => showSnackBar(context, l.message),
      (profile) {
        // _ref.read(profileProvider.notifier).update((state) => profile);
        _ref.read(userProfileProvider.notifier).update(profile);
      },
    );
    state = false;
  }

  void delete(
    BuildContext context,
    String email,
    String? currentUserEmail,
  ) async {
    state = true;
    Map returned = await _authRepository.deleteUser(email);
    state = false;
    if (!mounted) return;

    debugPrint(returned.toString());
    bool success = returned['result'];
    success
        ? email == currentUserEmail
            ? deleteYourself(context)
            : showSnackBar(context, "Deleted Test User")
        : showSnackBar(context, "Unable to Delete Test User");
  }

  deleteYourself(BuildContext context) {
    showSnackBar(context, "You Deleted Yourself!");
    _authRepository.logOut();
    // _ref.invalidate(profileProvider);
    _ref.invalidate(userProfileProvider);
  }

  void logout() {
    state = true;
    _authRepository.logOut();
    state = false;
    // _ref.invalidate(profileProvider);
    _ref.invalidate(userProfileProvider);
  }
}
