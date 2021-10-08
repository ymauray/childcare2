import 'package:childcare2/i18n/i18n.dart';
import 'package:childcare2/model/folder.dart';
import 'package:childcare2/utils/database_utils.dart';
import 'package:childcare2/widgets/components/folder_card/folder_card.dart';
import 'package:childcare2/widgets/forms/folder_form.dart';
import 'package:childcare2/widgets/left_menu.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Folder> _data = [];

  void _getData() {
    DatabaseUtils.getDatabase().then((db) {
      return db.query('folder', orderBy: 'childFirstName, childLastName');
    }).then((rows) {
      setState(() {
        _data = rows.map((row) => Folder.fromDbMap(row)).toList();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Child Care'.t(context),
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
      ),
      drawer: const LeftMenu(),
      body: ListView.builder(
        itemCount: _data.length,
        itemBuilder: (context, index) {
          return FolderCard(
            folder: _data[index],
            onEdit: () {
              Navigator.push<Folder>(
                context,
                MaterialPageRoute(
                  builder: (context) => FolderForm(folder: _data[index]),
                ),
              ).then((value) {
                if (value != null) {
                  DatabaseUtils.getDatabase().then((db) {
                    db.update(
                      'folder',
                      value.toDbMap(),
                      where: 'id = ${_data[index].id}',
                    );
                  });
                  _getData();
                }
              });
            },
            onDelete: () {
              DatabaseUtils.delete(
                'folder',
                where: 'id = ${_data[index].id}',
                onDeleted: (_) {
                  _getData();
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push<Folder>(
            MaterialPageRoute(
              builder: (context) => FolderForm(key: widget.key),
            ),
          )
              .then((folder) {
            if (folder != null) {
              DatabaseUtils.getDatabase().then<int>((db) {
                return db.insert('folder', folder.toDbMap());
              }).then<Folder>((id) {
                folder.id = id;
                return folder;
              }).then<void>((folder) {
                setState(() {});
              });
            }
          });
        },
        tooltip: 'New folder'.t(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
