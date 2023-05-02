import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import 'screens/home.dart';
import 'screens/sign_in.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
});
