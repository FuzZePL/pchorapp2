import 'package:pchor_app/screens/auth_screen/register_email_auth_field.dart';
import 'package:pchor_app/screens/auth_screen/register_screen.dart';
import 'package:pchor_app/values/colors.dart';
import 'package:pchor_app/values/constant_functions.dart';
import 'package:pchor_app/widgets/buttons/default_button.dart';
import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';

import '../../values/size_config.dart';
import '../../values/strings.dart';

class RegisterWidget2 extends StatefulWidget {
  final Future<void> Function() registerSuccess;
  final PageController controller;
  const RegisterWidget2({
    super.key,
    required this.registerSuccess,
    required this.controller,
  });

  @override
  State<RegisterWidget2> createState() => _RegisterWidget2State();
}

class _RegisterWidget2State extends State<RegisterWidget2>
    with AutomaticKeepAliveClientMixin {
  late FocusNode pin2FocusNode;
  late FocusNode pin3FocusNode;
  late FocusNode pin4FocusNode;
  late FocusNode pin5FocusNode;
  late FocusNode pin6FocusNode;
  late FocusNode pin7FocusNode;
  final _formKey = GlobalKey<FormState>();
  var code = '';
  final String email = RegisterScreen.email;
  final double _defaultSize = SizeConfig.defaultSize!;

  final String sessionName = Strings.appName;
  bool _isLoading = false;

  void _sendOTP() async {
    EmailAuth(sessionName: sessionName);
    var res = await EmailAuth(
      sessionName: sessionName,
    ).sendOtp(recipientMail: email);
    if (!mounted) return;
    if (res) {
      ConstantFunctions.showSnackBar(
        context,
        KColors.kPrimaryColor,
        KColors.kBackgroundColor,
        Strings.emailSendt,
      );
    } else {
      ConstantFunctions.showSnackBar(
        context,
        KColors.kErrorColor,
        KColors.kBackgroundColor,
        Strings.emailSendtError,
      );
    }
  }

  void _verifyOTP(String code) async {
    this.code = '';
    _formKey.currentState!.save();

    var res = EmailAuth(
      sessionName: sessionName,
    ).validateOtp(recipientMail: email, userOtp: this.code);
    if (res) {
      setState(() {
        _isLoading = true;
      });
      await widget.registerSuccess();
      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      ConstantFunctions.showSnackBar(
        context,
        KColors.kErrorColor,
        KColors.kBackgroundColor,
        Strings.wrongCode,
      );
    }
  }

  void _onSaved(String? code1) {
    if (code1 != null) {
      code += code1;
    }
  }

  void _nextField(String value, FocusNode focusNode) {
    if (value.length == 1) {
      focusNode.requestFocus();
    }
  }

  @override
  void initState() {
    super.initState();
    _sendOTP();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
    pin5FocusNode = FocusNode();
    pin6FocusNode = FocusNode();
    pin7FocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    pin2FocusNode.dispose();
    pin3FocusNode.dispose();
    pin4FocusNode.dispose();
    pin5FocusNode.dispose();
    pin6FocusNode.dispose();
    pin7FocusNode.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            height: size.height * 0.55,
            margin: EdgeInsets.only(
              left: size.height * 0.001,
              right: size.height * 0.001,
              top: size.height * 0.2,
            ),
            child: SizedBox(
              child: Card(
                semanticContainer: true,
                elevation: 12,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                margin: EdgeInsets.all(getProportionateScreenWidth(12)),
                color: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height * 0.01),
                    Text(
                      Strings.verifyEmial,
                      style: TextStyle(
                        color: KColors.kBlackColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(14),
                      child: Text(
                        Strings.weSentYouAnEmial,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: KColors.kBlackColor,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(20)),
                    Form(
                      key: _formKey,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RegisterEmailAuthField(
                            focusNode: pin2FocusNode,
                            onSaved: _onSaved,
                            onChanged: _nextField,
                            focusNodeNext: pin3FocusNode,
                          ),
                          RegisterEmailAuthField(
                            focusNode: pin3FocusNode,
                            onSaved: _onSaved,
                            onChanged: _nextField,
                            focusNodeNext: pin4FocusNode,
                          ),
                          RegisterEmailAuthField(
                            focusNode: pin4FocusNode,
                            onSaved: _onSaved,
                            onChanged: _nextField,
                            focusNodeNext: pin5FocusNode,
                          ),
                          RegisterEmailAuthField(
                            focusNode: pin5FocusNode,
                            onSaved: _onSaved,
                            onChanged: _nextField,
                            focusNodeNext: pin6FocusNode,
                          ),
                          RegisterEmailAuthField(
                            focusNode: pin6FocusNode,
                            onSaved: _onSaved,
                            onChanged: _nextField,
                            focusNodeNext: pin7FocusNode,
                          ),
                          RegisterEmailAuthField(
                            focusNode: pin7FocusNode,
                            onSaved: _onSaved,
                            onChanged: _nextField,
                            focusNodeNext: pin7FocusNode,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.05),
                    DefaultButton(
                      text: Strings.registerFinal,
                      defaultSize: _defaultSize,
                      onTap: () {},
                      icon: Icons.done_all_outlined,
                      gradient: ConstantFunctions.secondaryGradient(),
                    ),
                    SizedBox(height: size.height * 0.03),
                    GestureDetector(
                      onTap: _sendOTP,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            Strings.emailNotRecived,
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            Strings.sendOnceMore,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
