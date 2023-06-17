import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../core/common/sign_in_button.dart';
import '../../../models/community_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../../community/controller/community_controller.dart';


class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  void navigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('/create-community');
  }

  void navigateToCommunity(BuildContext context, Community community) {
    Routemaster.of(context).push('/r/${community.name}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            isGuest
                ? const SignInButton()
                : ListTile(
              title: const Text('Create a community'),
              leading: const Icon(Icons.add),
              onTap: () => navigateToCreateCommunity(context),
            ),
            if (!isGuest)
              ref.watch(userCommunitiesProvider).when(
                data: (communities) => Expanded(
                  child: ListView.builder(
                    itemCount: communities.length,
                    itemBuilder: (BuildContext context, int index) {
                      final community = communities[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(community.avatar),
                        ),
                        title: Text('r/${community.name}'),
                        onTap: () {
                          navigateToCommunity(context, community);
                        },
                      );
                    },
                  ),
                ),
                error: (error, stackTrace) => ErrorText(
                  error: error.toString(),
                ),
                loading: () => const Loader(),
              ),
          ],
        ),
      ),
    );
  }
}
