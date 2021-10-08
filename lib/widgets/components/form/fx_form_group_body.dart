import 'package:flutter/material.dart';

class FxFormGroupBody extends StatelessWidget {
  final List<Widget> children;

  const FxFormGroupBody({
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
              child: children[index],
            );
          },
          separatorBuilder: (context, index) {
            return const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
              child: Divider(
                thickness: 1,
              ),
            );
          },
          itemCount: children.length,
        ),
      ),
      //child: Column(
      //  crossAxisAlignment: CrossAxisAlignment.start,
      //  children: children,
      //),
    );
  }
}
