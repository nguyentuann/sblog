import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sblog/configs/theme/color.dart';
import 'package:sblog/common/presentation/widget/common_button.dart';
import 'package:sblog/common/presentation/widget/common_textformfield.dart';
import 'package:sblog/common/presentation/widget/password_textfield.dart';
import 'package:sblog/core/state/bloc_state.dart';
import 'package:sblog/features/auth/domain/entities/user.dart';
import 'package:sblog/features/auth/presentation/bloc/auth_bloc.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({
    super.key,
    required this.formKey,
    required this.firstnameController,
    required this.lastnameController,
    required this.emailController,
    required this.passwordController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController firstnameController;
  final TextEditingController lastnameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  var validateMode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: widget.formKey,
        autovalidateMode: validateMode,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              CommonTextFormField(
                controller: widget.firstnameController,
                labelText: 'Firstname',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CommonTextFormField(
                controller: widget.lastnameController,
                labelText: 'Lastname ',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20),
              CommonTextFormField(
                controller: widget.emailController,
                labelText: 'Email',
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty ||
                      !value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              PasswordTextField(controller: widget.passwordController),
              const SizedBox(height: 20),
              _buildBlocListener(
                child: CommonButton(
                  onPressed: () {
                    handleRegister();
                  },
                  title: 'Register',
                  width: double.infinity,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBlocListener({required Widget child}) {
    return BlocListener<AuthBloc, BaseState<User?>>(
      listener: (context, state) {
        if (state is LoadingState<User>) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder:
                (_) => const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: GeneralColors.wColor,
                  ),
                ),
          );
        } else if (state is SuccessState<User?>) {
          context.go('/home');
        } else if (state is FailureState<User?>) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: child,
    );
  }

  void handleRegister() {
    FocusScope.of(context).unfocus();
    if (validateMode == AutovalidateMode.disabled) {
      setState(() {
        validateMode = AutovalidateMode.always;
      });
    }

    if (widget.formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        AuthRegisterStarted(
          firstname: widget.firstnameController.text,
          lastname: widget.lastnameController.text,
          email: widget.emailController.text,
          password: widget.passwordController.text,
        ),
      );
    }
  }
}
