import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/auth.dart';
import '../models/profile.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void signOut(WidgetRef ref) {
    if (kDebugMode) {
      print("Log Out");
    }
    ref.read(authControllerProvider.notifier).logout();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Profile? profile = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bulletproof Auth (HOME)"),
        actions: [
          IconButton(
            onPressed: () => signOut(ref),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(child: Text(profile.toString())),
    );
  }
}
