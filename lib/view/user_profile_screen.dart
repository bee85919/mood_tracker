import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:mood_tracker/constant/gap.dart';
import 'package:mood_tracker/constant/route.dart';
import 'package:mood_tracker/constant/size.dart';
import 'package:mood_tracker/view_model/users_view_model.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  final String username;
  final String tab;

  const UserProfileScreen({
    super.key,
    required this.username,
    required this.tab,
  });

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  void _onGearPressed() {
    context.pushNamed(Routes.SETTING_NAME);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(usersProvider).when(
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          data: (data) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "Profile",
                  style: TextStyle(color: Theme.of(context).primaryColor),
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
              body: Column(
                children: [
                  Gaps.v20,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "@${data.name}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: Sizes.size18,
                        ),
                      ),
                      Gaps.h5,
                      FaIcon(
                        FontAwesomeIcons.solidCircleCheck,
                        size: Sizes.size16,
                        color: Theme.of(context).primaryColor,
                      )
                    ],
                  ),
                ],
              ),
            );
          },
        );
  }
}
