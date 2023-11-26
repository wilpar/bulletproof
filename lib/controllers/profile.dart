// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/profile.dart';

part 'profile.g.dart';

@riverpod
class UserProfile extends _$UserProfile {
  @override
  Profile? build() => null;

  void update(Profile? profile) {
    state = profile;
  }
}

// final profileProvider = StateProvider<Profile?>(
//   (ref) => null,
//   name: 'profile',
// );
