import 'package:childcare2/forms/entry_form.dart';
import 'package:childcare2/i18n/child_care_localization.dart';
import 'package:childcare2/model/entry.dart';
import 'package:childcare2/model/entry_model.dart';
import 'package:childcare2/model/folder.dart';
import 'package:childcare2/pages/not_implemented_yet.dart';
import 'package:childcare2/utils/i18n_utils.dart';
import 'package:childcare2/utils/int_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EntriesPage extends StatelessWidget {
  const EntriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final i18n = ChildCareLocalizations.of(context);
    final t = Theme.of(context);
    final folder = ModalRoute.of(context)!.settings.arguments as Folder;

    context.read<EntryModel>().loadForFolder(folder.id!);

    final ButtonStyle style = TextButton.styleFrom(primary: Theme.of(context).colorScheme.onPrimary);

    return Scaffold(
      appBar: AppBar(
        title: Text("${folder.childFirstName} ${folder.childLastName}"),
        actions: [
          TextButton(
              style: style,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(fullscreenDialog: true, builder: (context) => const NotImplementedYet()));
              },
              child: Text(
                'Create invoice'.t(context).toUpperCase(),
                // style: TextStyle(
                //   color: Theme.of(context).colorScheme.onPrimary,
                // ),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<EntryModel>(
                builder: (context, model, child) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text("${'Total pending billing :'.t(context)} ${model.pendingBillingTotal.toStringAsFixed(2)}"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
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
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Container(height: 1, color: Colors.black),
              ),
              Consumer<EntryModel>(
                builder: (context, model, child) => ListView.builder(
                    shrinkWrap: true,
                    itemCount: model.count,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  DateFormat.yMMMMd(I18nUtils.locale).format(model.items[index].date),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                flex: 1,
                                child: Center(child: Text("${model.items[index].hours}h${model.items[index].minutes.toPaddedString(2)}")),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              SizedBox(
                                width: 24,
                                child: Center(child: Icon(model.items[index].lunch ? Icons.check_box_outlined : Icons.check_box_outline_blank)),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              SizedBox(
                                width: 24,
                                child: Center(child: Icon(model.items[index].diner ? Icons.check_box_outlined : Icons.check_box_outline_blank)),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              SizedBox(
                                width: 24,
                                child: Center(child: Icon(model.items[index].night ? Icons.check_box_outlined : Icons.check_box_outline_blank)),
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
                                          builder: (context) => EntryForm(entry: Entry.clone(model.items[index])),
                                        ),
                                      ).then((entry) {
                                        if (entry != null) {
                                          entry.id = model.items[index].id;
                                          context.read<EntryModel>().update(entry!);
                                        }
                                      });
                                      break;
                                    case "delete":
                                      _showConfirmationDialog(context).then((value) {
                                        if ((value != null) && (value)) {
                                          context.read<EntryModel>().remove(model.items[index]);
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
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
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
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EntryForm(
                  folderId: folder.id!,
                  preschool: folder.preschool!,
                ),
              )).then((entry) {
            if (entry != null) {
              context.read<EntryModel>().add(entry);
            }
          });
        },
        tooltip: i18n.t('New folder'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<bool?> _showConfirmationDialog(BuildContext context) async {
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
