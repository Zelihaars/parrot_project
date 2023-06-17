// ignore_for_file: unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parrot_project/core/common/error_text.dart';
import 'package:parrot_project/core/common/loader.dart';
import 'package:parrot_project/features/auth/controller/auth_controller.dart';
import 'package:parrot_project/features/auth/screen/login_screen.dart';
import 'package:parrot_project/models/user_model.dart';
import 'package:parrot_project/router.dart';
import 'package:parrot_project/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

import 'firebase_options.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(ProviderScope(
    child:MyApp(),
    ));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}
class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;

  void getData(WidgetRef ref, User data) async {
    userModel = await ref
        .watch(authControllerProvider.notifier)
        .getUserData(data.uid)
        .first;
    ref.read(userProvider.notifier).update((state) => userModel);
    setState(() {
      
    });


  }
  
  @override
  Widget build(BuildContext context){
  return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Parrot Topluluğu',
      theme: Pallete.darkModeAppTheme,
      home: const SizedBox(),

    );
  
  }
}

