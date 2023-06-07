 import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parrot_project/core/constants/constants.dart';
import 'package:parrot_project/features/auth/controller/auth_controller.dart';
import 'package:parrot_project/theme/pallete.dart';

 class SignInButton extends ConsumerWidget {
   const SignInButton({super.key});
  
   void signInWithGoogle(BuildContext context, WidgetRef ref){
      ref.read(authControllerProvider.notifier).signInWithGoogle(context);
  }
   
   
   
   @override
   Widget build(BuildContext context,WidgetRef ref) {
     return Padding(
       padding: const EdgeInsets.all(8.0),
       child: ElevatedButton.icon(
        onPressed: (){
            //=>signInWithGoogle(context, ref),
        },
        icon: Image.asset(Constants.googlePath,
        width: 35,), 
        label: const Text('Google ile giriş',
        style: TextStyle(fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Pallete.greyColor,
          minimumSize: const Size(
          double.infinity, 
          50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
         )
        ),
       ),
     );
   }
 }