import 'package:childcare2/forms/entry_form.dart';
import 'package:childcare2/i18n/child_care_localization.dart';
import 'package:childcare2/model/entry.dart';
import 'package:childcare2/model/folder.dart';
import 'package:childcare2/utils/i18n_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EntriesPage extends StatefulWidget {
  const EntriesPage({Key? key}) : super(key: key);

  @override
  _EntriesPageState createState() => _EntriesPageState();
}

class _EntriesPageState extends State<EntriesPage> {
  List<Entry> entries = [];
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final i18n = ChildCareLocalizations.of(context);
    final t = Theme.of(context);
    final folder = ModalRoute.of(context)!.settings.arguments as Folder;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${folder.childFirstName} ${folder.childLastName}",
          style: TextStyle(color: t.colorScheme.onPrimary),
        ),
        backgroundColor: t.colorScheme.primary,
        iconTheme: IconThemeData(color: t.colorScheme.onPrimary),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${'Total pending billing :'.t(context)} 123.45"),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Text(
                    "Legend".t(context) + " :  ",
                  ),
                  const Icon(Icons.wb_sunny_outlined),
                  Text(" = ${'Lunch'.t(context)}, "),
                  const Icon(Icons.nightlight_round_sharp),
                  Text(" = ${'Dinner'.t(context)}, "),
                  const Icon(Icons.night_shelter_outlined),
                  Text(" = ${'Night'.t(context)}, "),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Column(
                children: [
                  Row(
                    children: const [
                      Expanded(
                        child: SizedBox(
                          height: 8,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          "Date".t(context),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                            "Duration".t(context),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const SizedBox(
                        width: 24,
                        child: Center(
                          child: Icon(Icons.wb_sunny_outlined),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const SizedBox(
                        width: 24,
                        child: Center(
                          child: Icon(Icons.nightlight_round_sharp),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const SizedBox(
                        width: 24,
                        child: Center(
                          child: Icon(Icons.night_shelter_outlined),
                        ),
                      ),
                      const SizedBox(
                        width: 8 + 48,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Container(height: 1, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                DateFormat.yMMMMd(I18nUtils.locale).format(entries[index].date),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              flex: 1,
                              child: Center(child: Text("${entries[index].hours}h${entries[index].minutes}")),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            SizedBox(
                              width: 24,
                              child: Center(child: Icon(entries[index].lunch ? Icons.check_box_outlined : Icons.check_box_outline_blank)),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            SizedBox(
                              width: 24,
                              child: Center(child: Icon(entries[index].diner ? Icons.check_box_outlined : Icons.check_box_outline_blank)),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            SizedBox(
                              width: 24,
                              child: Center(child: Icon(entries[index].night ? Icons.check_box_outlined : Icons.check_box_outline_blank)),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            PopupMenuButton<String>(
                              itemBuilder: (context) => <PopupMenuEntry<String>>[
                                PopupMenuItem<String>(value: "edit", child: Text(i18n.t("Edit"))),
                                PopupMenuItem<String>(value: "delete", child: Text(i18n.t("Delete"), style: const TextStyle(color: Colors.red))),
                              ],
                              onSelected: (result) {
                                switch (result) {
                                  case "edit":
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EntryForm(),
                                        )).then((entry) {
                                      if (entry != null) {
                                        setState(() {
                                          entries.add(entry);
                                        });
                                      }
                                    });
                                    break;
                                  case "delete":
                                    _showConfirmationDialog().then((value) {
                                      if ((value != null) && (value)) {
                                        //DatabaseUtils.getDatabase().then((db) => {db.delete('folder', where: 'id = ${data[index].id}')});
                                        setState(() {
                                          entries.remove(entries[index]);
                                        });
                                      }
                                    });
                                    break;
                                }
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Container(height: 1, color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EntryForm(),
              )).then((entry) {
            if (entry != null) {
              setState(() {
                entries.add(entry);
              });
            }
          });
        },
        tooltip: i18n.t('New folder'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<bool?> _showConfirmationDialog() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete'.t(context)),
          content: Text('Are you sure you want to delete this entry ?'.t(context)),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('Yes'.t(context))),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('No'.t(context))),
          ],
        );
      },
    );
  }
}
