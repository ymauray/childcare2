import 'package:childcare2/widgets/outlined_toggle_button.dart';
import 'package:flutter/material.dart';

class NullableBooleanFormField extends FormField<bool?> {
  final EdgeInsets padding;

  NullableBooleanFormField({
    Key? key,
    required FormFieldSetter<bool?> onChanged,
    required FormFieldValidator<bool?> validator,
    bool? initialValue,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
    required String trueText,
    required String falseText,
    this.padding = EdgeInsets.zero,
  }) : super(
            key: key,
            validator: validator,
            initialValue: initialValue,
            autovalidateMode: autovalidateMode,
            builder: (FormFieldState<bool?> state) {
              final t = Theme.of(state.context);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(
                      flex: 1,
                      child: OutlinedToggleButton(
                        padding: padding,
                        child: Text(trueText),
                        isSelected: state.value ?? false,
                        onPressed: () {
                          state.didChange(true);
                          onChanged(true);
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      flex: 1,
                      child: OutlinedToggleButton(
                        padding: padding,
                        child: Text(falseText),
                        isSelected: !(state.value ?? true),
                        onPressed: () {
                          state.didChange(false);
                          onChanged(false);
                        },
                      ),
                    ),
                  ]),
                  state.hasError
                      ? Column(
                          children: [
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              state.errorText!,
                              style: DefaultTextStyle.of(state.context).style.apply(
                                    fontSizeFactor: .9,
                                    color: t.errorColor,
                                  ),

                              //style: TextStyle(
                              //  color: t.colorScheme.error,
                              //),
                            ),
                          ],
                        )
                      : Container()
                ],
              );
            });
}
