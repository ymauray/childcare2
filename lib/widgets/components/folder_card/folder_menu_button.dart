import 'package:childcare2/model/folder.dart';
import 'package:childcare2/utils/database_utils.dart';
import 'package:childcare2/i18n/i18n.dart';
import 'package:flutter/material.dart';

class FolderMenuButton extends StatelessWidget {
  final Folder folder;
  final void Function()? onEdit;
  final void Function()? onDelete;

  const FolderMenuButton({
    Key? key,
    required this.folder,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (result) {
        switch (result) {
          case "edit":
            onEdit?.call();
            break;
          case "delete":
            showDialog<bool>(
              context: context,
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
            ).then((value) {
              if (value ?? false) onDelete?.call();
            });
            break;
        }
      },
      itemBuilder: (context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: "edit",
          child: Text(
            'Edit'.t(context),
          ),
        ),
        PopupMenuItem<String>(
          value: "delete",
          child: Text(
            'Delete'.t(context),
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
