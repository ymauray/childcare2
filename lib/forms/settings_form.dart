import 'dart:developer';

import 'package:childcare2/model/settings.dart';
import 'package:childcare2/utils/database_utils.dart';
import 'package:flutter/material.dart';
import 'package:childcare2/i18n/child_care_localization.dart';

class SettingsForm extends StatelessWidget {
  const SettingsForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _future = settings.load();
    final _focusNode = FocusNode();

    return Form(
      key: _formKey,
      child: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? Container()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: settings.hourlyWeekRate.toString(),
                              decoration: InputDecoration(
                                label: Text(
                                  'Hourly rate Mon-Fri'.t(context),
                                ),
                                alignLabelWithHint: true,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This value cannot be empty'.t(context);
                                }
                              },
                              onSaved: (value) {
                                settings.hourlyWeekRate = double.parse(value!);
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: TextFormField(
                              initialValue: settings.hourlyWeekendRate.toString(),
                              decoration: InputDecoration(
                                label: Text(
                                  'Hourly rate Sat-Sun'.t(context),
                                ),
                                alignLabelWithHint: true,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This value cannot be empty'.t(context);
                                }
                              },
                              onSaved: (value) {
                                settings.hourlyWeekendRate = double.parse(value!);
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: settings.lunchPreSchool.toString(),
                              decoration: InputDecoration(
                                label: Text(
                                  'Lunch preschool'.t(context),
                                ),
                                alignLabelWithHint: true,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This value cannot be empty'.t(context);
                                }
                              },
                              onSaved: (value) {
                                settings.lunchPreSchool = double.parse(value!);
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: TextFormField(
                              initialValue: settings.lunchKindergarten.toString(),
                              decoration: InputDecoration(
                                label: Text(
                                  'Lunch kindergarten'.t(context),
                                ),
                                alignLabelWithHint: true,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This value cannot be empty'.t(context);
                                }
                              },
                              onSaved: (value) {
                                settings.lunchKindergarten = double.parse(value!);
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: settings.dinerPreSchool.toString(),
                              decoration: InputDecoration(
                                label: Text(
                                  'Diner preschool'.t(context),
                                ),
                                alignLabelWithHint: true,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This value cannot be empty'.t(context);
                                }
                              },
                              onSaved: (value) {
                                settings.dinerPreSchool = double.parse(value!);
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: TextFormField(
                              initialValue: settings.dinerKindergarten.toString(),
                              decoration: InputDecoration(
                                label: Text(
                                  'Diner kindergarten'.t(context),
                                ),
                                alignLabelWithHint: true,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This value cannot be empty'.t(context);
                                }
                              },
                              onSaved: (value) {
                                settings.dinerKindergarten = double.parse(value!);
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: settings.overnight.toString(),
                              decoration: InputDecoration(
                                label: Text(
                                  'Night'.t(context),
                                ),
                                alignLabelWithHint: true,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This value cannot be empty'.t(context);
                                }
                              },
                              onSaved: (value) {
                                settings.overnight = double.parse(value!);
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Container(),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 32),
                              child: ElevatedButton(
                                focusNode: _focusNode,
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    DatabaseUtils.getDatabase().then((db) {
                                      settings.save(db);
                                    });
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        _focusNode.requestFocus();
                                        return const SettingsSuccessfullyUpdatedDialog();
                                      },
                                    );

                                    /// Figure out what to do with this page.
                                  }
                                },
                                child: Text(
                                  'Save'.t(context),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}

class SettingsSuccessfullyUpdatedDialog extends StatelessWidget {
  const SettingsSuccessfullyUpdatedDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Settings'.t(context)),
      content: Text('Settings successfully updated'.t(context)),
      actions: [
        TextButton(
          child: Text('OK'.t(context)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
