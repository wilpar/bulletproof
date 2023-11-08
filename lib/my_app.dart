import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import 'routes.dart';
import 'controllers/auth.dart';
import 'models/profile.dart';
import 'widgets/error_text.dart';
import 'widgets/loader.dart';
import 'widgets/snackbar.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BaseAppState();
}

class _BaseAppState extends ConsumerState<MyApp> {
  Profile? profile;

  void setProfile(BuildContext context, WidgetRef ref, User user) async {
    debugPrint("setProfile Triggered");
    profile = await ref
        .watch(authControllerProvider.notifier)
        .getProfileData(user.uid)
        .first;
    ref.read(profileProvider.notifier).update((state) => profile);
    if (!mounted) return;
    showSnackBar(context, "Welcome, ${profile?.firstName}");
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangesProvider).when(
          data: (User? user) => MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(primarySwatch: Colors.blueGrey),
            routerDelegate: RoutemasterDelegate(
              routesBuilder: (context) {
                if (user is User) {
                  setProfile(context, ref, user);
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
