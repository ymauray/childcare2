import 'package:childcare2/i18n/child_care_localization.dart';
import 'package:childcare2/model/folder.dart';
import 'package:childcare2/widgets/outlined_toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FolderForm extends StatefulWidget {
  const FolderForm({Key? key}) : super(key: key);

  @override
  State<FolderForm> createState() => _FolderFormState();
}

class _FolderFormState extends State<FolderForm> {
  late Folder _folder;
  late Folder? _argument;

  @override
  void didChangeDependencies() {
    _argument = ModalRoute.of(context())!.settings.arguments as Folder?;
    _folder = _argument == null ? Folder() : Folder.clone(_argument!);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final i18n = ChildCareLocalizations.of(context);
    final t = Theme.of(context);
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_outlined),
          onPressed: () {
            Navigator.of(context).pop(null);
          },
        ),
        title: Text(
          _argument == null ? i18n.t('New folder') : "${_folder.childFirstName} ${_folder.childLastName}".trim(),
          style: TextStyle(color: t.colorScheme.onPrimary),
        ),
        backgroundColor: t.colorScheme.primary,
        iconTheme: IconThemeData(color: t.colorScheme.onPrimary),
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                Navigator.of(context).pop(_folder);
              }
            },
            child: Text(
              i18n.t("Save").toUpperCase(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              childFirstName(i18n),
              childLastName(i18n),
              childBirthDate(context, i18n),
              priceRange(i18n),
              parentsFullName(i18n),
              address(i18n),
            ],
          ),
        ),
      ),
    );
  }

  Padding address(ChildCareLocalizations i18n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: TextFormField(
        maxLines: 2,
        decoration: InputDecoration(
          icon: const SizedBox(height: 24, width: 24),
          labelText: i18n.t("Address"),
        ),
        initialValue: _folder.address,
        onChanged: (value) {
          _folder.address = value;
        },
      ),
    );
  }

  Padding parentsFullName(ChildCareLocalizations i18n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: TextFormField(
        decoration: InputDecoration(
          icon: const Icon(Icons.people),
          labelText: i18n.t("Full name"),
        ),
        initialValue: _folder.parentsFullName,
        onChanged: (value) {
          _folder.parentsFullName = value;
        },
      ),
    );
  }

  Padding childBirthDate(BuildContext context, ChildCareLocalizations i18n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: TextFormField(
        decoration: InputDecoration(
          label: Text(i18n.t('Date of birth')),
          icon: const SizedBox(height: 24, width: 24),
        ),
        keyboardType: TextInputType.none,
        showCursor: false,
        enableInteractiveSelection: false,
        controller: TextEditingController(
          text: _folder.childDateOfBirth == null ? "" : DateFormat('dd.MM.yyyy').format(_folder.childDateOfBirth!),
        ),
        onTap: () {
          showDatePicker(
            context: context,
            initialDate: _folder.childDateOfBirth ?? DateTime.now(),
            firstDate: DateTime.now().add(
              const Duration(days: -20 * 366),
            ),
            lastDate: DateTime.now(),
          ).then((date) {
            setState(() {
              _folder.childDateOfBirth = date ?? _folder.childDateOfBirth;
            });
          });
        },
      ),
    );
  }

  Padding childLastName(ChildCareLocalizations i18n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: TextFormField(
        decoration: InputDecoration(
          icon: const SizedBox(height: 24, width: 24),
          labelText: i18n.t("Last name"),
        ),
        initialValue: _folder.childLastName,
        onChanged: (value) {
          _folder.childLastName = value;
        },
      ),
    );
  }

  Padding childFirstName(ChildCareLocalizations i18n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: TextFormField(
        decoration: InputDecoration(
          icon: const Icon(Icons.child_care),
          labelText: i18n.t("First name"),
        ),
        initialValue: _folder.childFirstName,
        onChanged: (value) {
          _folder.childFirstName = value;
        },
        validator: (value) {
          if ((value == null) || (value.isEmpty)) {
            return i18n.t("First name should not be empty.");
          } else {
            return null;
          }
        },
      ),
    );
  }

  Padding priceRange(ChildCareLocalizations i18n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          const SizedBox(
            width: 40,
            height: 24,
          ),
          Expanded(
            child: NullableBooleanFormField(
              autovalidateMode: AutovalidateMode.always,
              initialValue: _folder.preschool,
              trueText: i18n.t('Preschool'),
              falseText: i18n.t('Kindergarten'),
              validator: (value) {
                if (value == null) {
                  return 'Please select one option';
                }
              },
              onSaved: (value) {
                _folder.preschool = value!;
              },
            ),
          )
        ],
      ),
    );
  }
}

class NullableBooleanFormField extends FormField<bool?> {
  NullableBooleanFormField({
    Key? key,
    required FormFieldSetter<bool?> onSaved,
    required FormFieldValidator<bool?> validator,
    bool? initialValue,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
    required String trueText,
    required String falseText,
  }) : super(
            key: key,
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            autovalidateMode: autovalidateMode,
            builder: (FormFieldState<bool?> state) {
              final t = Theme.of(state.context());
              return Column(
                children: [
                  Row(children: [
                    Expanded(
                      flex: 1,
                      child: OutlinedToggleButton(
                        child: Text(trueText),
                        isSelected: state.value ?? false,
                        onPressed: () {
                          state.didChange(true);
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      flex: 1,
                      child: OutlinedToggleButton(
                        child: Text(falseText),
                        isSelected: !(state.value ?? true),
                        onPressed: () {
                          state.didChange(false);
                        },
                      ),
                    ),
                  ]),
                  state.hasError
                      ? Text(
                          state.errorText!,
                          style: TextStyle(color: t.colorScheme.error),
                        )
                      : Container()
                ],
              );
            });
}
