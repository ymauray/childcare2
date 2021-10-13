import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:childcare2/i18n/child_care_localization.dart';
import 'package:email_validator/email_validator.dart';

class CreateAccountForm extends StatefulWidget {
  const CreateAccountForm({Key? key}) : super(key: key);

  @override
  _CreateAccountFormState createState() => _CreateAccountFormState();
}

class _CreateAccountFormState extends State<CreateAccountForm> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String email = "";
  String password = "";
  String errorMessage = "";
  bool disabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create account'.t(context)),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: TextFormField(
                    enabled: !disabled,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      label: Text('Email'.t(context)),
                      alignLabelWithHint: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email cannot be empty'.t(context);
                      }
                      if (!EmailValidator.validate(value)) {
                        return 'Email is not valid'.t(context);
                      }
                    },
                    onSaved: (value) {
                      email = value!;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: TextFormField(
                    enabled: !disabled,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                      label: Text('Password'.t(context)),
                      alignLabelWithHint: true,
                    ),
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password cannot be empty'.t(context);
                      }
                    },
                    onSaved: (value) {
                      password = value!;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: TextFormField(
                    enabled: !disabled,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                      label: Text('Confirm password'.t(context)),
                      alignLabelWithHint: true,
                    ),
                    controller: _confirmPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password cannot be empty'.t(context);
                      }
                      if (_passwordController.text != _confirmPasswordController.text) {
                        return 'Passwords are different'.t(context);
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          child: Text('Create account'.t(context)),
                          onPressed: disabled
                              ? null
                              : () async {
                                  setState(() {
                                    errorMessage = "";
                                  });
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    setState(() {
                                      disabled = true;
                                    });
                                    try {
                                      await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                        email: email,
                                        password: password,
                                      );
                                      Navigator.of(context).pop();
                                    } on FirebaseAuthException catch (e) {
                                      if (e.code == 'weak-password') {
                                        setState(() {
                                          errorMessage = 'The password provided is too weak.'.t(context);
                                          disabled = false;
                                        });
                                      } else if (e.code == 'email-already-in-use') {
                                        setState(() {
                                          errorMessage = 'The account already exists for that email.'.t(context);
                                          disabled = false;
                                        });
                                      }
                                    } catch (e) {
                                      setState(() {
                                        errorMessage = e.toString();
                                        disabled = false;
                                      });
                                    }
                                  }
                                },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
                  child: Text(
                    errorMessage,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
