import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sblog/configs/theme/color.dart';
import 'package:sblog/common/presentation/widget/common_textformfield.dart';
import 'package:sblog/common/presentation/widget/password_textfield.dart';
import 'package:sblog/common/presentation/widget/common_button.dart';
import 'package:sblog/core/state/bloc_state.dart';
import 'package:sblog/core/util/validator.dart';
import 'package:sblog/features/auth/domain/entities/user.dart';
import 'package:sblog/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  var validateMode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        autovalidateMode: validateMode,
        key: widget.formKey,
        child: SingleChildScrollView(
          child: _buildBlocListener(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                CommonTextFormField(
                  controller: widget.emailController,
                  labelText: 'Email',
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty ||
                        !Validators.isValidEmail(value)) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                PasswordTextField(
                  controller: widget.passwordController,
                ),
                const SizedBox(height: 20),
                CommonButton(
                  onPressed: handleLogin,
                  title: 'Login',
                  width: double.infinity,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Forgot password?'),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        context.push('/retrieve_password');
                      },
                      child: Text(
                        'Click here',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: GeneralColors.bColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Hàm tách BlocListener
  Widget _buildBlocListener({required Widget child}) {
    return BlocListener<AuthBloc, BaseState<User?>>(
      listener: (context, state) {
        if (state is LoadingState<User>) {
          // Mở dialog loading
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(
              child: CircularProgressIndicator(
                backgroundColor: GeneralColors.wColor,
              ),
            ),
          );
        } else if (state is SuccessState<User?>) {
          context.go('/');
        } else if (state is FailureState<User?>) {
          // Đóng dialog + show lỗi
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: child,
    );
  }

  void handleLogin() {
    FocusScope.of(context).unfocus();
    if (validateMode == AutovalidateMode.disabled) {
      setState(() {
        validateMode = AutovalidateMode.always;
      });
    }

    if (widget.formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            AuthLoginStarted(
              email: widget.emailController.text,
              password: widget.passwordController.text,
            ),
          );
    }
  }
}
