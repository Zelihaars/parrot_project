import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../features/auth/controlller/auth_controller.dart';
import '../../../features/community/controller/community_controller.dart';

class AddModsScreen extends ConsumerStatefulWidget {
  final String name;
  const AddModsScreen({
    super.key,
    required this.name,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddModsScreenState();
}

class _AddModsScreenState extends ConsumerState<AddModsScreen> {
  //uids Seçilen moderatör kullanıcı kimliklerini tutan  nesne.
  Set<String> uids = {};
  int ctr = 0;

  //Bir kullanıcı kimliğini  uids kümesine eklemek için kullanılır.
  void addUid(String uid) {
    setState(() {
      uids.add(uid);
    });
  }

  //Bir kullanıcı kimliğini  uids kümesine kaldırmak için kullanılır.
  void removeUid(String uid) {
    setState(() {
      uids.remove(uid);
    });
  }

  //Moderatörleri kaydetmek için kullanılır.
  void saveMods() {
    ref.read(communityControllerProvider.notifier).addMods(
      widget.name,
      uids.toList(),
      context,
    );
  }


  //build: Ekranın görünümünü oluşturan ve güncelleyen işlevdir.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: saveMods,
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: ref.watch(getCommunityByNameProvider(widget.name)).when(
        data: (community) => ListView.builder(
          itemCount: community.members.length,
          itemBuilder: (BuildContext context, int index) {
            final member = community.members[index];

            return ref.watch(getUserDataProvider(member)).when(
              data: (user) {
                if (community.mods.contains(member) && ctr == 0) {
                  uids.add(member);
                }
                ctr++;
                return CheckboxListTile(
                  value: uids.contains(user.uid),
                  onChanged: (val) {
                    if (val!) {
                      addUid(user.uid);
                    } else {
                      removeUid(user.uid);
                    }
                  },
                  title: Text(user.name),
                );
              },
              error: (error, stackTrace) => ErrorText(
                error: error.toString(),
              ),
              loading: () => const Loader(),
            );
          },
        ),
        error: (error, stackTrace) => ErrorText(
          error: error.toString(),
        ),
        loading: () => const Loader(),
      ),
    );
  }
}
