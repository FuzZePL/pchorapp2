import 'package:flutter/material.dart';
import 'package:pchor_app/values/colors.dart';
import 'package:pchor_app/values/strings.dart';
import 'package:pchor_app/widgets/text_fields/text_field_container.dart';

class RoundedInputField extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final String type;
  final Function(String?) onSaved;
  final TextInputAction textInputAction;
  final TextInputType inputType;
  final TextEditingController? controller;
  final int? limit;
  final int? maxLines;
  final Widget? suffix;
  final bool isPassword;
  final bool isOnlyRead;
  final int i;
  const RoundedInputField({
    super.key,
    required this.hintText,
    required this.icon,
    required this.onChanged,
    required this.type,
    required this.onSaved,
    required this.textInputAction,
    required this.inputType,
    this.controller,
    this.limit,
    this.maxLines = 1,
    this.suffix,
    required this.isPassword,
    this.isOnlyRead = false,
    this.i = 0,
  });

  @override
  State<RoundedInputField> createState() => _RoundedInputFieldState();
}

class _RoundedInputFieldState extends State<RoundedInputField>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(-1, 0),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.decelerate));

  void _playAnimation() {
    Future.delayed(Duration(milliseconds: 50 + (50 * widget.i))).then((value) {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
    _playAnimation();
  }

  @override
  Widget build(BuildContext context) {
    final String type = widget.type;
    final IconData icon = widget.icon;
    final Widget? suffix = widget.suffix;
    return SlideTransition(
      position: _offsetAnimation,
      child: TextFieldContainer(
        child: TextFormField(
          readOnly: widget.isOnlyRead,
          obscureText: _obscureText,
          maxLength: widget.limit,
          onSaved: widget.onSaved,
          controller: widget.controller,
          enableSuggestions: true,
          textCapitalization: TextCapitalization.none,
          textInputAction: widget.textInputAction,
          textAlign: TextAlign.justify,
          style: const TextStyle(
            color: KColors.kBlackColor,
            fontWeight: FontWeight.bold,
          ),
          validator: (value) {
            final validCharacters = RegExp(r"[']");
            if (value != null && type != 'pass') {
              if (value.contains('/*~~@(*%&%#')) {
                return Strings.cantContainSpecial;
              }
            }
            if (type == 'Email') {
              if (value == null) {
                return Strings.emailMustNotBeEmpty;
              }
              if (value.isEmpty || !value.contains('@')) {
                return Strings.emailMustBeCorrect;
              }
            }
            if (type == 'Username') {
              if (value == null) {
                return Strings.usernameMustNotBeEmpty;
              }
              if (value.isEmpty) {
                return Strings.usernameMustNotBeEmpty;
              }
              if (value.length > 20) {
                return Strings.usernameMustBe20;
              }
              if (validCharacters.hasMatch(value)) {
                return Strings.usernameMustBeCorrect;
              }
            }
            if (type == 'School') {
              if (value == null) {
                return Strings.schoolMustNotBeEmpty;
              }
              if (value.isEmpty) {
                return Strings.schoolMustNotBeEmpty;
              }
              if (validCharacters.hasMatch(value)) {
                return Strings.schoolMustNotBeCorrect;
              }
            }
            if (type == 'pass') {
              if (value == null) {
                return Strings.passwordMust7Length;
              }
              if (value.isEmpty) {
                return Strings.passwordMust7Length;
              }
            }

            return null;
          },
          keyboardType: widget.inputType,
          onChanged: widget.onChanged,
          autocorrect: false,
          minLines: 1,
          cursorRadius: const Radius.circular(6),
          maxLines: widget.maxLines,
          decoration: InputDecoration(
            border: InputBorder.none,
            errorStyle: const TextStyle(color: KColors.kTextColorDark),
            contentPadding: const EdgeInsets.all(5),
            prefixIcon: Icon(icon, color: KColors.kPrimaryColor, size: 30),
            suffixIcon: widget.isPassword
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        icon: _obscureText
                            ? const Icon(Icons.visibility_rounded)
                            : const Icon(Icons.visibility_off_rounded),
                        color: KColors.kSecondaryColor,
                      ),
                      if (suffix != null) suffix,
                    ],
                  )
                : widget.suffix,
            labelText: widget.hintText.toUpperCase(),
            labelStyle: const TextStyle(
              color: KColors.kTextColorDark,
              fontSize: 13,
              fontFamily: 'SamsungOne',
              fontWeight: FontWeight.w900,
            ),
            focusedBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
