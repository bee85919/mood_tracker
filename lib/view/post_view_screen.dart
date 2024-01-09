import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mood_tracker/constant/gap.dart';
import 'package:mood_tracker/constant/route.dart';
import 'package:mood_tracker/constant/size.dart';
import 'package:mood_tracker/view_model/post_view_model.dart';

class PostViewScreen extends ConsumerStatefulWidget {
  const PostViewScreen({super.key});

  @override
  ConsumerState<PostViewScreen> createState() => _PostScreenState();
}

class _PostScreenState extends ConsumerState<PostViewScreen> {
  void _onLongPressItem(String? postUid) async {
    print(postUid);
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 175,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("DELETE ?\n",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        side: const BorderSide(color: Colors.pink),
                        elevation: 2,
                      ),
                      child: const Text('   No   ',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black)),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Gaps.h80,
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        side: const BorderSide(color: Colors.pink),
                        elevation: 2,
                      ),
                      child: const Text('   Yes   ',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black)),
                      onPressed: () => _deleteItem(postUid ?? ""),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _deleteItem(String postUid) {
    if (postUid.isEmpty) return;
    ref.read(postProvider.notifier).deletePost(context, postUid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "MOOD",
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: () => context.pushNamed(Routes.SETTING_NAME),
            icon: Icon(
              Icons.settings_sharp,
              color: Theme.of(context).primaryColor,
            ),
          )
        ],
      ),
      body: ref.watch(postViewProvider).when(
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stackTrace) => Center(
              child: Text(
                'Can\'t load posts: $error',
              ),
            ),
            data: (posts) {
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onLongPress: () => _onLongPressItem(post.uid),
                          child: Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(6)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        IconData(post.mood,
                                            fontFamily: 'MaterialIcons'),
                                        color: Theme.of(context).primaryColor,
                                      )
                                    ],
                                  ),
                                  Gaps.v12,
                                  Text(
                                    post.content,
                                    style: const TextStyle(
                                      fontSize: Sizes.size16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: timeAgo(post.createdAt),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
    );
  }
}

Text timeAgo(int savedTimeInMilliseconds) {
  final currentTime = DateTime.now();
  final savedTime =
      DateTime.fromMillisecondsSinceEpoch(savedTimeInMilliseconds);
  final difference = currentTime.difference(savedTime);
  final minutesAgo = difference.inMinutes;

  String timeAgo = '방금 전';
  if (minutesAgo >= 1 && minutesAgo < 60) {
    timeAgo = '$minutesAgo 분 전';
  } else if (minutesAgo >= 60 && minutesAgo < 1440) {
    final hoursAgo = (minutesAgo / 60).round();
    timeAgo = '$hoursAgo 시간 전';
  } else if (minutesAgo >= 1440) {
    final daysAgo = (minutesAgo / 1440).round();
    timeAgo = '$daysAgo 일 전';
  }

  return Text(
    timeAgo,
    style: const TextStyle(fontSize: Sizes.size12),
  );
}
