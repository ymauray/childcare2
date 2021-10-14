import 'package:flutter/material.dart';
import 'package:childcare2/i18n/child_care_localization.dart';

class NotImplementedYet extends StatelessWidget {
  const NotImplementedYet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Not implemented yet'.t(context)),
      ),
      body: Center(
        child: Text('Not implemented yet'.t(context), style: Theme.of(context).textTheme.headline5),
      ),
    );
  }
}
