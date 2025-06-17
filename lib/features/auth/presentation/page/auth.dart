import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sblog/configs/theme/color.dart';
import 'package:sblog/features/auth/presentation/widget/form_login.dart';
import 'package:sblog/features/auth/presentation/widget/form_signup.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  // Tách formKey cho từng form
  final _loginFormKey = GlobalKey<FormState>();
  final _signupFormKey = GlobalKey<FormState>();

  // Tách TextEditingController cho từng form
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController =
      TextEditingController();
  final TextEditingController _signupFirstnameController =
      TextEditingController();
  final TextEditingController _signupPasswordController =
      TextEditingController();
  final TextEditingController _signupEmailController = TextEditingController();
  final TextEditingController _signupLastnameController =
      TextEditingController();

  late TabController _tabController;

  @override
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        if (_tabController.index == 0) {
          _signupFirstnameController.clear();
          _signupPasswordController.clear();
          _signupEmailController.clear();
          _signupLastnameController.clear();
        } else if (_tabController.index == 1) {
          _loginEmailController.clear();
          _loginPasswordController.clear();
        }
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _signupFirstnameController.dispose();
    _signupLastnameController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 80),
          SvgPicture.asset(
            'assets/images/LOGO.svg',
            width: 80,
            height: 80,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 228, 228, 228),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TabBar(
                      dividerHeight: 2,
                      dividerColor: Colors.white,
                      indicatorColor: GeneralColors.bColor,
                      labelColor: GeneralColors.bColor,
                      unselectedLabelColor: GeneralColors.grColor,
                      controller: _tabController,
                      tabs: const [
                        Tab(
                          child: Text(
                            'LOGIN',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'SIGN UP',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        LoginForm(
                          formKey: _loginFormKey,
                          emailController: _loginEmailController,
                          passwordController: _loginPasswordController,
                        ),
                        SignupForm(
                          formKey: _signupFormKey,
                          firstnameController: _signupFirstnameController,
                          passwordController: _signupPasswordController,
                          emailController: _signupEmailController,
                          lastnameController: _signupLastnameController,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
