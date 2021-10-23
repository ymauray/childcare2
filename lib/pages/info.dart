import 'package:childcare2/i18n/child_care_localization.dart';
import 'package:childcare2/model/folder.dart';
import 'package:childcare2/utils/i18n_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Info extends StatelessWidget {
  const Info({Key? key, required this.folder}) : super(key: key);

  final Folder folder;

  @override
  Widget build(BuildContext context) {
    final i18n = ChildCareLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(i18n.t("Info"))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(folder.childFirstName + " " + folder.childLastName, style: Theme.of(context).textTheme.headline5),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Né(e) le " + DateFormat.yMMMMd(I18nUtils.locale).format(folder.childDateOfBirth!), style: Theme.of(context).textTheme.headline6),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(folder.allergies == null ? i18n.t("No known allergies") : folder.allergies!, style: Theme.of(context).textTheme.headline6),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(folder.parentsFullName, style: Theme.of(context).textTheme.headline6),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(folder.address, style: Theme.of(context).textTheme.headline6),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(folder.phoneNumber!, style: Theme.of(context).textTheme.headline6),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(folder.misc!, style: Theme.of(context).textTheme.headline6),
            ),
          ],
        ),
      ),
    );
  }
}
