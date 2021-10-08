import 'package:childcare2/model/folder.dart';
import 'package:childcare2/widgets/pages/entries_page.dart';
import 'package:childcare2/i18n/i18n.dart';
import 'package:childcare2/widgets/components/folder_card/folder_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:url_launcher/url_launcher.dart';

class FolderCard extends StatelessWidget {
  final Folder folder;
  final void Function()? onEdit;
  final void Function()? onDelete;

  const FolderCard({
    Key? key,
    required this.folder,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var hasAllergies = folder.allergies?.isNotEmpty ?? false;
    var allergiesText = hasAllergies ? "${'Known allergies'.t(context)} : ${folder.allergies}" : 'No known allergies'.t(context);
    var miscText = folder.misc ?? "";
    var subtitle = "$allergiesText\n$miscText".trim();
    var hasPhoneNumber = folder.phoneNumber?.isNotEmpty ?? false;
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EntriesPage(/*{folder: folder,} */),
            ),
          );
        },
        title: Text("${folder.childFirstName} ${folder.childLastName}"),
        subtitle: Text(subtitle),
        isThreeLine: false,
        trailing: FolderMenuButton(
          key: key,
          folder: folder,
          onEdit: onEdit,
          onDelete: onDelete,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.phone,
            color: hasPhoneNumber ? Colors.green : Colors.red, // hasPhoneNumber ? t.disabledColor : null,
          ),
          onPressed: () {
            if (hasPhoneNumber) {
              FlutterLibphonenumber().parse("${folder.countryCode}${folder.phoneNumber}").then((value) {
                launch("tel://${value['e164']}");
              });
            }
          },
        ),
      ),
    );
  }
}
