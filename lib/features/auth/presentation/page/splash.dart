import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sblog/configs/theme/color.dart';
import 'package:sblog/common/presentation/widget/common_button.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  GeneralColors.bColor,
                  GeneralColors.wColor,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: const EdgeInsets.only(
              top: 42,
              bottom: 69,
              left: 46,
              right: 46,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 100,
                    bottom: 20,
                    left: 20,
                    right: 20,
                  ),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        'assets/images/LOGO.svg',
                        width: 200,
                        height: 200,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Welcome to S-Blog!',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Share your thoughts with the world',
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 50,
                    horizontal: 16,
                  ),
                  child: Column(
                    children: [
                      CommonButton(
                        title: 'Get Started',
                        onPressed: () {
                          context.go('/auth');
                        },
                        width: double.infinity,
                        icon: Icons.arrow_right_alt,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
