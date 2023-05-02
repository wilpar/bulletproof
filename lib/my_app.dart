import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import 'routes.dart';
import 'controllers/auth.dart';
import 'models/profile.dart';
import 'widgets/error_text.dart';
import 'widgets/loader.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BaseAppState();
}

class _BaseAppState extends ConsumerState<MyApp> {
  Profile? profile;

  void setProfile(WidgetRef ref, User user) async {
    if (kDebugMode) {
      print("getData");
    }
    profile = await ref
        .watch(authControllerProvider.notifier)
        .getProfileData(user.uid)
        .first;
    ref.read(profileProvider.notifier).update((state) => profile);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangesProvider).when(
          data: (user) => MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(primarySwatch: Colors.blueGrey),
            routerDelegate: RoutemasterDelegate(
              routesBuilder: (context) {
                if (user != null) {
                  setProfile(ref, user);
                  return loggedInRoute;
                }
                return loggedOutRoute;
              },
            ),
            routeInformationParser: const RoutemasterParser(),
          ),
          error: (error, stackTrace) => Material(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: ErrorText(
                error: error.toString(),
              ),
            ),
          ),
          loading: () => const Material(child: Loader()),
        );
  }
}
