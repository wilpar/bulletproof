import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/auth.dart';
import '../models/profile.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Profile? profile = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Signed In: ${profile?.firstName}"),
        actions: [
          IconButton(
            onPressed: () {
              debugPrint("Log Out");
              ref.read(authControllerProvider.notifier).logout();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          const Spacer(),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                profile.toString(),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const Spacer(),
          Center(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CupertinoButton.filled(
                  onPressed: () =>
                      ref.read(authControllerProvider.notifier).delete(
                            context,
                            'test@test.com',
                            profile?.email,
                          ),
                  child: const Text("Delete Tester"),
                )),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
