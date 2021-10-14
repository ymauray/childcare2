import 'package:childcare2/forms/create_account_form.dart';
import 'package:childcare2/forms/login_form.dart';
import 'package:childcare2/i18n/child_care_localization.dart';
import 'package:childcare2/pages/not_implemented_yet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BackupAndRestorePage extends StatelessWidget {
  const BackupAndRestorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Backup and restore'.t(context),
          style: TextStyle(color: t.colorScheme.onPrimary),
        ),
        backgroundColor: t.colorScheme.primary,
        iconTheme: IconThemeData(color: t.colorScheme.onPrimary),
      ),
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasData) {
            return BackupAndRestoreAuthenticatedPage(email: snapshot.data!.email!);
          } else {
            return const BackupAndRestoreNotAuthenticatedPage();
          }
        },
      ),
    );
  }
}

class BackupAndRestoreNotAuthenticatedPage extends StatelessWidget {
  const BackupAndRestoreNotAuthenticatedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Text(
            'You are not authenticated'.t(context),
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Divider(
            color: Colors.black,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  child: Text('Log in'.t(context)),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LoginForm(),
                      fullscreenDialog: true,
                    ));
                  },
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: ElevatedButton(
                  child: Text('Create account'.t(context)),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const CreateAccountForm(),
                      fullscreenDialog: true,
                    ));
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class BackupAndRestoreAuthenticatedPage extends StatelessWidget {
  final String email;
  const BackupAndRestoreAuthenticatedPage({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Text('You are authenticated'.t(context), style: Theme.of(context).textTheme.headline6),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Text(email, style: Theme.of(context).textTheme.bodyText1),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Divider(
            color: Colors.black,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).push(MaterialPageRoute(fullscreenDialog: true, builder: (context) => const NotImplementedYet()));
                  },
                  child: Text(
                    'Backup'.t(context),
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).push(MaterialPageRoute(fullscreenDialog: true, builder: (context) => const NotImplementedYet()));
                  },
                  child: Text(
                    'Restore'.t(context),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Divider(
            color: Colors.black,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                  },
                  child: Text(
                    'Log out'.t(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
