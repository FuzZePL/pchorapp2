import 'package:pchor_app/values/constant_functions.dart';
import 'package:pchor_app/values/size_config.dart';
import 'package:flutter/material.dart';

class RegisterEmailAuthField extends StatelessWidget {
  const RegisterEmailAuthField({
    super.key,
    required this.onChanged,
    required this.onSaved,
    required this.focusNode,
    required this.focusNodeNext,
    this.i = 0,
  });
  final void Function(String, FocusNode) onChanged;
  final FocusNode focusNode;
  final FocusNode focusNodeNext;
  final void Function(String?)? onSaved;
  final int i;

  @override
  Widget build(BuildContext context) {
    const double width = 50.0;
    return SizedBox(
      width: getProportionateScreenWidth(width),
      child: TextFormField(
        key: key,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        style: const TextStyle(fontSize: 24),
        textAlign: TextAlign.center,
        decoration: otpInputDecoration,
        onChanged: (value) {
          if (i == 7) {
            focusNode.unfocus();
          } else {
            if (value.isNotEmpty) {
              onChanged(value, focusNodeNext);
            }
          }
        },
        onSaved: onSaved,
      ),
    );
  }
}
