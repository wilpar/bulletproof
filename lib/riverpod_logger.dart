import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RiverpodLogger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    switch (provider.name) {
      default:
        debugPrint(
          '''
{
  "provider": "${provider.name ?? provider.runtimeType}",
  "argument": "${provider.argument}",
  "previousValue": "$previousValue",
  "newValue": "$newValue"
}''',
        );
    }
  }
}
