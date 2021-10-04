import 'package:childcare2/i18n/child_care_localization.dart';
import 'package:childcare2/model/folder.dart';
import 'package:childcare2/utils/i18n_utils.dart';
import 'package:childcare2/widgets/custom_text_form_field.dart';
import 'package:childcare2/widgets/date_picker_form_field.dart';
import 'package:childcare2/widgets/nullable_boolean_form_field.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';

class FolderForm extends StatefulWidget {
  const FolderForm({Key? key}) : super(key: key);

  @override
  State<FolderForm> createState() => _FolderFormState();
}

class _FolderFormState extends State<FolderForm> {
  late Folder _folder;
  late Folder? _argument;

  bool _isPhoneNumberValid = true;

  @override
  void didChangeDependencies() {
    _argument = ModalRoute.of(context)!.settings.arguments as Folder?;
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
              childFirstName(context, i18n),
              childLastName(i18n),
              childBirthDate(context, i18n),
              preschoolStatus(i18n),
              allergies(i18n),
              parentsFullName(context, i18n),
              address(i18n),
              phoneNumber(context, i18n),
              misc(i18n),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget childFirstName(BuildContext context, ChildCareLocalizations i18n) {
    final t = Theme.of(context);
    return CustomTextFormField(
      labelText: i18n.t("First name"),
      icon: Icon(
        Icons.child_care,
        color: t.colorScheme.primary,
      ),
      initialValue: _folder.childFirstName,
      textCapitalization: TextCapitalization.words,
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
    );
  }

  Widget childLastName(ChildCareLocalizations i18n) {
    return CustomTextFormField(
      labelText: i18n.t("Last name"),
      initialValue: _folder.childLastName,
      textCapitalization: TextCapitalization.words,
      onChanged: (value) {
        _folder.childLastName = value;
      },
    );
  }

  Padding childBirthDate(BuildContext context, ChildCareLocalizations i18n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: DatePickerFormField(
        label: Text(i18n.t('Date of birth')),
        initialDate: _folder.childDateOfBirth,
        onChange: (date) {
          _folder.childDateOfBirth = date;
        },
      ),
    );
  }

  Padding preschoolStatus(ChildCareLocalizations i18n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          const SizedBox(width: 40),
          Expanded(
            child: NullableBooleanFormField(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              initialValue: _folder.preschool,
              trueText: i18n.t('Preschool'),
              falseText: i18n.t('Kindergarten'),
              validator: (value) {
                if (value == null) {
                  return i18n.t('Please select one option');
                }
              },
              onChanged: (value) {
                setState(() {
                  _folder.preschool = value!;
                });
              },
            ),
          )
        ],
      ),
    );
  }

  Widget allergies(ChildCareLocalizations i18n) {
    return CustomTextFormField(
      labelText: i18n.t("Allergies"),
      maxLines: 2,
      initialValue: _folder.allergies,
      onChanged: (value) {
        _folder.allergies = value;
      },
    );
  }

  Widget parentsFullName(BuildContext context, ChildCareLocalizations i18n) {
    final t = Theme.of(context);
    return CustomTextFormField(
      icon: Icon(
        Icons.people,
        color: t.colorScheme.primary,
      ),
      labelText: i18n.t("Full name"),
      textCapitalization: TextCapitalization.words,
      initialValue: _folder.parentsFullName,
      onChanged: (value) {
        _folder.parentsFullName = value;
      },
    );
  }

  Widget address(ChildCareLocalizations i18n) {
    return CustomTextFormField(
      labelText: i18n.t("Address"),
      maxLines: 2,
      initialValue: _folder.address,
      textCapitalization: TextCapitalization.words,
      onChanged: (value) {
        _folder.address = value;
      },
    );
  }

  Widget phoneNumber(BuildContext context, ChildCareLocalizations i18n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          const Icon(Icons.phone),
          CountryCodePicker(
            searchDecoration: const InputDecoration(
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
            onChanged: (countryCode) {
              setState(() {
                _folder.countryCode = countryCode.dialCode!;
                _folder.phoneNumber = null;
              });
            },
            initialSelection: I18nUtils.currentCountryCode ?? '',
            favorite: [I18nUtils.currentCountryCode ?? ''],
            showCountryOnly: true,
            showOnlyCountryWhenClosed: true,
            alignLeft: false,
          ),
          Expanded(
            child: CustomTextFormField(
              icon: null,
              padding: EdgeInsets.zero,
              labelText: i18n.t("Phone number"),
              keyboardType: TextInputType.phone,
              initialValue: _folder.phoneNumber,
              validator: (value) {
                if (value != null && !_isPhoneNumberValid) {
                  return "Invalid phone number";
                }
              },
              onChanged: (value) {
                if (value.isNotEmpty) {
                  _folder.phoneNumber = value;
                  FlutterLibphonenumber().parse("${_folder.countryCode}${_folder.phoneNumber!}").then((value) {
                    _isPhoneNumberValid = true;
                  }).onError((error, stackTrace) {
                    _isPhoneNumberValid = false;
                  });
                } else {
                  _folder.phoneNumber = null;
                  _isPhoneNumberValid = true;
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget misc(ChildCareLocalizations i18n) {
    return CustomTextFormField(
      labelText: i18n.t("Misc. information"),
      maxLines: 4,
      initialValue: _folder.misc,
      onChanged: (value) {
        _folder.misc = value;
      },
    );
  }
}
