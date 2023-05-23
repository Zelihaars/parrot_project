import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parrot_project/core/providers/firebase_providers.dart';
import 'package:parrot_project/core/utils.dart';
import 'package:parrot_project/features/auth/repository/auth_repository.dart';



final authControllerProvider=Provider((ref)=> AuthController(authRepository: ref.read(authRepositoryProvider),
),
);
class AuthController{
  final AuthRepository _authRepository;
  AuthController({
    required AuthRepository authRepository
  }):_authRepository=authRepository;

 
  Future<void> signInWithGoogle(BuildContext context) async {
    
    final user =await _authRepository.signInWithGoogle();
    user.fold((l) => showSnackBar(context, l.message), (r) => null);
    
  }
}