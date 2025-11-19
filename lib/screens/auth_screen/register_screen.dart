import 'package:flutter/material.dart';
import 'package:pchor_app/screens/auth_screen/register_widget_2.dart';
import 'package:pchor_app/values/colors.dart';
import 'package:pchor_app/values/constant_functions.dart';
import 'package:pchor_app/values/size_config.dart';
import 'package:pchor_app/values/strings.dart';
import 'package:pchor_app/widgets/buttons/default_button.dart';
import 'package:pchor_app/widgets/buttons/on_back_pressed.dart';
import 'package:pchor_app/widgets/text_fields/rounded_input_field.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = '/register-screen';
  static String email = '';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();

  int _step = 0;

  final PageController _controller = PageController(
    initialPage: 0,
    keepPage: true,
  );

  final double _defaultSize = SizeConfig.defaultSize!;
  bool _isLoading = false;
  final String _requiredDomain = "@student.wat.edu.pl";

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    super.dispose();
  }

  bool _validateData() {
    if (_passwordController.value == _repeatPasswordController.value) {

    } else {
      ConstantFunctions.showSnackBar(context, KColors.kErrorColor, K, text)
    }
    return false;
  }

  void _submitStep(PageController controller) {
    if (_validateData()) {
      _step = 1;
      setState(() {});
      controller.animateToPage(
        _step,
        duration: const Duration(milliseconds: 600),
        curve: Curves.ease,
      );
    }
  }

  void _onBackPressed() {
    if (_step == 0) {
      Navigator.of(context).pop();
    } else {
      _step = _step - 1;
      _controller.animateToPage(
        _step - 1,
        duration: const Duration(milliseconds: 600),
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final PageView pageView = PageView(
      physics: const NeverScrollableScrollPhysics(),
      onPageChanged: (value) {
        _step = value;
      },
      controller: _controller,
      scrollDirection: Axis.horizontal,
      children: [
        RegisterWidget1(
          formKey: _formKey,
          nameController: _nameController,
          surnameController: _surnameController,
          emailController: _emailController,
          defaultSize: _defaultSize,
          submit: _submitStep,
          controller: _controller,
        ),
        RegisterWidget2(
          registerSuccess: () {
            return Future.delayed(const Duration(milliseconds: 500), () {
              return;
            });
          },
          controller: _controller,
        ),
      ],
    );
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          gradient: ConstantFunctions.defaultGradient(),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              pageView,
              Positioned(
                top: 14,
                left: 14,
                child: OnBackPressed(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onBackPressed: _onBackPressed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterWidget1 extends StatelessWidget {
  const RegisterWidget1({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController nameController,
    required TextEditingController surnameController,
    required TextEditingController emailController,
    required double defaultSize,
    required void Function(PageController) submit,
    required PageController controller,
  }) : _formKey = formKey,
       _nameController = nameController,
       _surnameController = surnameController,
       _emailController = emailController,
       _defaultSize = defaultSize,
       _submit = submit,
       _controller = controller;

  final void Function(PageController) _submit;
  final PageController _controller;
  final GlobalKey<FormState> _formKey;
  final TextEditingController _nameController;
  final TextEditingController _surnameController;
  final TextEditingController _emailController;
  final double _defaultSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              RoundedInputField(
                controller: _nameController,
                hintText: Strings.name,
                icon: Icons.person_2_outlined,
                onChanged: (val) {},
                type: 'Username',
                onSaved: (val) {},
                textInputAction: TextInputAction.next,
                inputType: TextInputType.text,
                isPassword: false,
              ),
              SizedBox(height: 8),
              RoundedInputField(
                controller: _surnameController,
                hintText: Strings.surname,
                icon: Icons.font_download_outlined,
                onChanged: (val) {},
                type: 'Username',
                onSaved: (val) {},
                textInputAction: TextInputAction.next,
                inputType: TextInputType.text,
                isPassword: false,
              ),
              SizedBox(height: 8),
              RoundedInputField(
                controller: _emailController,
                hintText: Strings.email,
                icon: Icons.email_outlined,
                onChanged: (val) {},
                type: 'Email',
                onSaved: (val) {},
                textInputAction: TextInputAction.next,
                inputType: TextInputType.emailAddress,
                isPassword: false,
              ),
              SizedBox(height: 16),
              // TODO add pluton compania batalion
              DefaultButton(
                defaultSize: _defaultSize,
                onTap: () {
                  _submit(_controller);
                  FocusScope.of(context).unfocus();
                },
                text: Strings.nextStep,
                icon: Icons.arrow_forward_ios_rounded,
                gradient: ConstantFunctions.secondaryGradient(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
