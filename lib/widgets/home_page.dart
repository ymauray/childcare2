import 'package:childcare2/i18n/child_care_localization.dart';
import 'package:childcare2/model/folder.dart';
import 'package:childcare2/utils/database_utils.dart';
import 'package:childcare2/widgets/left_menu.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Folder> data = [];

  @override
  Widget build(BuildContext context) {
    final i18n = ChildCareLocalizations.of(context);
    final t = Theme.of(context);

    DatabaseUtils.getDatabase().then((db) {
      return db.query('folder', orderBy: 'childFirstName, childLastName');
    }).then((rows) {
      setState(() {
        data = rows.map((row) => Folder.fromDbMap(row)).toList();
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          i18n.t('Child Care'),
          style: TextStyle(color: t.colorScheme.onPrimary),
        ),
        backgroundColor: t.colorScheme.primary,
        iconTheme: IconThemeData(color: t.colorScheme.onPrimary),
      ),
      drawer: const LeftMenu(),
      body: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return folderTile(context, index, i18n);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/edit", arguments: null).then((value) {
            if (value != null) {
              var folder = value as Folder;
              DatabaseUtils.getDatabase().then((db) {
                return db.insert('folder', folder.toDbMap());
              }).then((id) {
                folder.id = id;
                return folder;
              }).then((folder) {
                setState(() {});
              });
            }
          });
        },
        tooltip: i18n.t('New folder'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Card folderTile(BuildContext context, int index, ChildCareLocalizations i18n) {
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.of(context).pushNamed('/entries', arguments: data[index]).then((value) {});
        },
        title: Text("${data[index].childFirstName} ${data[index].childLastName}"),
        subtitle: Text(data[index].address),
        isThreeLine: true,
        trailing: folderMenuButton(context, index, i18n),
      ),
    );
  }

  PopupMenuButton<String> folderMenuButton(BuildContext context, int index, ChildCareLocalizations i18n) {
    return PopupMenuButton<String>(
      onSelected: (result) {
        switch (result) {
          case "edit":
            Navigator.of(context).pushNamed("/edit", arguments: data[index]).then((value) {
              if (value != null) {
                var folder = value as Folder;
                setState(() {
                  DatabaseUtils.getDatabase().then((db) {
                    return db.update('folder', folder.toDbMap(), where: 'id = ${data[index].id}');
                  }).then((_) {
                    setState(() {});
                  });
                });
              }
            });
            break;
          case "delete":
            _showConfirmationDialog(data[index]).then((value) {
              if ((value != null) && (value)) {
                DatabaseUtils.getDatabase().then((db) => {db.delete('folder', where: 'id = ${data[index].id}')});
              }
            });
            break;
        }
      },
      itemBuilder: (context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(value: "edit", child: Text(i18n.t("Edit"))),
        PopupMenuItem<String>(value: "delete", child: Text(i18n.t("Delete"), style: const TextStyle(color: Colors.red))),
      ],
    );
  }

  Future<bool?> _showConfirmationDialog(Folder folder) async {
    return showDialog<bool>(
      context: context(),
      barrierDismissible: false,
      builder: (context) {
        final i18n = ChildCareLocalizations.of(context);
        return AlertDialog(
          title: Text(i18n.t('Delete')),
          content: Text(i18n.t('Are you sure you want to delete this folder ?')),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(i18n.t('Yes'))),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(i18n.t('No'))),
          ],
        );
      },
    );
  }
}
