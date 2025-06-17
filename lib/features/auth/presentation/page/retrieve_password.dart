import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class RetrievePassword extends StatefulWidget {
  const RetrievePassword({super.key});

  @override
  State<RetrievePassword> createState() => _RetrievePasswordState();
}

class _RetrievePasswordState extends State<RetrievePassword> {
  final PageController _pageController = PageController();
  TextEditingController emailController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  String otpCode = '';

  int currentStep = 0;

  void nextStep() {
    setState(() {
      if (currentStep < 2) {
        currentStep++;
        _pageController.animateToPage(
          currentStep,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void previousStep() {
    setState(() {
      if (currentStep > 0) {
        currentStep--;
        _pageController.animateToPage(
          currentStep,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quên Mật Khẩu')),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildEnterEmailStep(),
          _buildEnterCodeStep(),
          _buildResetPasswordStep(),
        ],
      ),
    );
  }

  Widget _buildEnterEmailStep() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Nhập email để nhận mã xác nhận'),
          const SizedBox(height: 10),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: nextStep, // Giả lập gửi email
            child: const Text('Gửi mã'),
          ),
        ],
      ),
    );
  }

  Widget _buildEnterCodeStep() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Nhập mã xác nhận từ email'),
          const SizedBox(height: 10),
          Center(
            child: Pinput(
              length: 6,
              onChanged: (value) => otpCode = value,
              onCompleted: (value) => nextStep(), // Tự động chuyển bước khi nhập đủ 4 số
              defaultPinTheme: PinTheme(
                width: 56,
                height: 56,
                textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(onPressed: previousStep, child: const Text('Quay lại')),
              ElevatedButton(onPressed: nextStep, child: const Text('Xác nhận')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResetPasswordStep() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Nhập mật khẩu mới'),
          const SizedBox(height: 10),
          TextField(
            controller: newPasswordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Mật khẩu mới'),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(onPressed: previousStep, child: const Text('Quay lại')),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mật khẩu đã được đặt lại!')),
                  );
                },
                child: const Text('Đặt lại mật khẩu'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
