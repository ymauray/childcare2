import 'package:childcare2/i18n/child_care_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BackupAndRestorePage extends StatelessWidget {
  const BackupAndRestorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final i18n = ChildCareLocalizations.of(context);
    final t = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          i18n.t('Settings'),
          style: TextStyle(color: t.colorScheme.onPrimary),
        ),
        backgroundColor: t.colorScheme.primary,
        iconTheme: IconThemeData(color: t.colorScheme.onPrimary),
      ),
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasData) {
            return const LoggedInMenuWidget();
          } else {
            return const NotLoggedInMenuWidget();
          }
        },
      ),
    );
  }
}

class NotLoggedInMenuWidget extends StatefulWidget {
  const NotLoggedInMenuWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<NotLoggedInMenuWidget> createState() => _NotLoggedInMenuWidgetState();
}

class _NotLoggedInMenuWidgetState extends State<NotLoggedInMenuWidget> {
  bool showLoginForm = false;
  bool showRegisterForm = false;
  bool buttonsDisabled = false;
  final _formKey = GlobalKey<FormState>();

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  String email = "";
  String password = "";
  String errorMessage = "No error, everything is good !";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          showLoginForm || showRegisterForm
              ? Container()
              : Column(
                  children: [
                    Text(
                      "You are not logged in".t(context),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showLoginForm = true;
                          showRegisterForm = false;
                        });
                      },
                      child: Text('Log in'.t(context)),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showLoginForm = false;
                          showRegisterForm = true;
                        });
                      },
                      child: Text('Create account'.t(context)),
                    ),
                  ],
                ),
          !showRegisterForm && !showLoginForm
              ? Container()
              : Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                    child: Column(
                      children: [
                        Text(
                          "Create account".t(context),
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'email *',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'email cannot be empty'.t(context);
                            }
                            if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
                              return 'Not a valid email'.t(context);
                            }
                          },
                          onSaved: (value) {
                            email = value!;
                          },
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          obscureText: true,
                          controller: passwordController,
                          decoration: const InputDecoration(
                            labelText: 'password *',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'password cannot be empty'.t(context);
                            }
                          },
                          onSaved: (value) {
                            password = value!;
                          },
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        !showRegisterForm
                            ? Container()
                            : TextFormField(
                                obscureText: true,
                                controller: confirmPasswordController,
                                decoration: const InputDecoration(
                                  labelText: 'Confim password *',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'password cannot be empty'.t(context);
                                  }
                                  if (passwordController.text != confirmPasswordController.text) {
                                    return 'password does not match'.t(context);
                                  }
                                },
                              ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: showRegisterForm
                                  ? ElevatedButton(
                                      onPressed: buttonsDisabled
                                          ? null
                                          : () async {
                                              if (_formKey.currentState!.validate()) {
                                                _formKey.currentState!.save();
                                                setState(() {
                                                  buttonsDisabled = true;
                                                });
                                                FocusScope.of(context).unfocus();
                                                try {
                                                  await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
                                                } on FirebaseAuthException catch (e) {
                                                  if (e.code == 'weak-password') {
                                                    setState(() {
                                                      errorMessage = 'The password is too weak'.t(context);
                                                      buttonsDisabled = false;
                                                    });
                                                  } else if (e.code == 'email-already-in-use') {
                                                    setState(() {
                                                      errorMessage = 'An account already exists for that email'.t(context);
                                                      buttonsDisabled = false;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      errorMessage = '${'An undefined error occured'.t(context)} : ${e.code}';
                                                      buttonsDisabled = false;
                                                    });
                                                  }
                                                } catch (e) {
                                                  setState(() {
                                                    errorMessage = '${'An undefined error occured'.t(context)} : ${e.toString()}';
                                                    buttonsDisabled = false;
                                                  });
                                                }
                                              }
                                            },
                                      child: Text(
                                        'Create account'.t(context),
                                      ),
                                    )
                                  : ElevatedButton(
                                      onPressed: buttonsDisabled
                                          ? null
                                          : () async {
                                              if (_formKey.currentState!.validate()) {
                                                _formKey.currentState!.save();
                                                setState(() {
                                                  buttonsDisabled = true;
                                                });
                                                FocusScope.of(context).unfocus();
                                                try {
                                                  await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
                                                } on FirebaseAuthException catch (e) {
                                                  if (e.code == 'user-not-found' || e.code == 'wrong-password') {
                                                    setState(() {
                                                      errorMessage = 'Invalid credentials'.t(context);
                                                      buttonsDisabled = false;
                                                    });
                                                  }
                                                } catch (e) {
                                                  setState(() {
                                                    errorMessage = '${'An undefined error occured'.t(context)} : ${e.toString()}';
                                                    buttonsDisabled = false;
                                                  });
                                                }
                                              }
                                            },
                                      child: Text(
                                        'Log in'.t(context),
                                      ),
                                    ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              flex: 1,
                              child: ElevatedButton(
                                onPressed: buttonsDisabled
                                    ? null
                                    : () {
                                        setState(() {
                                          showRegisterForm = false;
                                          showLoginForm = false;
                                          email = "";
                                          password = "";
                                          passwordController.clear();
                                          confirmPasswordController.clear();
                                        });
                                      },
                                child: Text(
                                  'Cancel'.t(context),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(errorMessage),
                      ],
                    ),
                  ),
                )
        ],
      ),
    );
  }
}

class LoggedInMenuWidget extends StatelessWidget {
  const LoggedInMenuWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {},
            child: Text(
              'Backup'.t(context),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text(
              'Restore'.t(context),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            child: Text(
              'Log out'.t(context),
            ),
          ),
        ],
      ),
    );
  }
}
