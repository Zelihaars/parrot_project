import 'package:flutter/material.dart';
import 'package:parrot_project/features/auth/repository/home/screens/home_screen.dart';
import 'package:parrot_project/features/auth/screen/login_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
});