import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mood_tracker/repo/authentication_repository.dart';
import 'package:mood_tracker/model/post_model.dart';
import 'package:mood_tracker/repo/post_repository.dart';
import 'package:mood_tracker/utils.dart';

class PostViewModel extends AsyncNotifier<void> {
  late final PostRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(postRepository);
  }

  Future<void> uploadPost(BuildContext context) async {
    final form = ref.read(postForm);
    final user = ref.read(authRepository).user;
    if (user != null) {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(
        () async {
          await _repository.uploadPost(
            PostModel(
              uid: null,
              mood: form["mood"],
              content: form["content"],
              creatorUid: user.uid,
              creator: "",
              createdAt: DateTime.now().millisecondsSinceEpoch,
            ),
          );
        },
      );
      context.push("/home");
    }
  }

  Future<void> deletePost(BuildContext context, String postUid) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.deletePost(postUid);
    });
    if (state.hasError) {
      showFirebaseErrorSnack(context, state.error);
    } else {
      context.pop();
    }
  }
}

final postForm = StateProvider((ref) => {});

final postProvider = AsyncNotifierProvider<PostViewModel, void>(
  () => PostViewModel(),
);

final postViewProvider = StreamProvider.autoDispose<List<PostModel>>((ref) {
  final firestore = FirebaseFirestore.instance;
  final user = ref.read(authRepository).user;
  return firestore
      .collection("posts")
      .where("creatorUid", isEqualTo: user!.uid)
      .orderBy("createdAt", descending: true)
      .snapshots()
      .map(
        (event) => event.docs
            .map(
              (e) => PostModel.formJson(
                json: e.data(),
              ),
            )
            .toList(),
      );
});
