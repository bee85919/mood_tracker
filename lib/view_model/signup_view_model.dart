import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mood_tracker/repo/authentication_repository.dart';
import 'package:mood_tracker/view_model/users_view_model.dart';
import 'package:mood_tracker/utils.dart';

class SignUpViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _authenticationRepository;

  @override
  FutureOr<void> build() {
    _authenticationRepository = ref.read(authRepository);
  }

  Future<void> signUp(BuildContext context) async {
    state = const AsyncValue.loading();
    final form = ref.read(signUpForm);
    final users = ref.read(usersProvider.notifier);
    state = await AsyncValue.guard(() async {
      final userCredential = await _authenticationRepository.emailSignUp(
        form["email"],
        form["password"],
      );
      await users.createProfile(userCredential);
    });
    if (state.hasError) {
      showFirebaseErrorSnack(context, state.error);
    } else {
      context.go("/home");
    }
  }
}

final signUpForm = StateProvider((ref) => {});

final signUpProvider = AsyncNotifierProvider<SignUpViewModel, void>(
  () => SignUpViewModel(),
);
