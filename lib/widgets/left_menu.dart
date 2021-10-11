import 'package:childcare2/i18n/child_care_localization.dart';
import 'package:flutter/material.dart';

class LeftMenu extends StatelessWidget {
  const LeftMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final i18n = ChildCareLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    return Drawer(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: ListTile(
              tileColor: cs.primary,
              leading: Icon(
                Icons.child_care,
                color: cs.onPrimary,
              ),
              title: Text(
                i18n.t("Child Care"),
                style: TextStyle(color: cs.onPrimary),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(
              i18n.t("Settings"),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
    );
  }
}
