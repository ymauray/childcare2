import 'package:childcare2/widgets/components/form/fx_form_group_body.dart';
import 'package:childcare2/widgets/components/form/fx_form_group_header.dart';
import 'package:flutter/material.dart';

class FxFormGroup extends StatelessWidget {
  final String header;
  final List<Widget> children;

  const FxFormGroup({
    Key? key,
    required this.header,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FxFormGroupHeader(
            header: header,
          ),
          FxFormGroupBody(
            children: children,
          ),
        ],
      ),
    );
  }
}
