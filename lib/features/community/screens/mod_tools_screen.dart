import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';


class ModToolsScreen extends StatelessWidget {
  final String name;
  const ModToolsScreen({
    Key? key,
    required this.name,
  }) : super(key: key);

  //Topluluğun düzenleme ekranına yönlendirmek için kullanılan bir işlevdir.
  void navigateToModTools(BuildContext context) {
    Routemaster.of(context).push('/edit-community/$name');
  }

  //Moderatör ekranına yönlendirmek için kullanılan bir işlevdir.
  void navigateToAddMods(BuildContext context) {
    Routemaster.of(context).push('/add-mods/$name');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moderatör araçaları'),
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.add_moderator),
            title: const Text('Moderatör ekle'),
            onTap: () => navigateToAddMods(context),
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Topluluğu düzenle'),
            onTap: () => navigateToModTools(context),
          ),
        ],
      ),
    );
  }
}
