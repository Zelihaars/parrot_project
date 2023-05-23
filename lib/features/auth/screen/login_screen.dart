import 'package:flutter/material.dart';
import 'package:parrot_project/core/common/sign_in_button.dart';
import 'package:parrot_project/core/constants/constants.dart';

class LoginScreen  extends StatelessWidget {
  const LoginScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          Constants.logoPath,
          height: 80,
          
        ),
        actions: [
          TextButton(
            onPressed: (){

            }, 
            child: const Text('Atla',style: TextStyle(
              fontWeight: FontWeight.bold,
            ),))
        ],

      ),
      body: Column(
        children: [
          const SizedBox(height: 30,),
          const Text(
            'Parrot Topluluk',
            style: TextStyle(
              fontSize:24,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(Constants.loginEmotePath,
            height: 400,),
          ),
          const SizedBox(height: 20,),
          const SignInButton()
        ],
      ),
    );
  }
}