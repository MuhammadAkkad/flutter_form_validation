import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'getController/FormValidationController.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: App(),
    );
  }
}

class App extends StatelessWidget {
  App({super.key});

  final FormValidationController controller =
      Get.put(FormValidationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GetX Form Validation Example'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            EmailInput(),
            PasswordInput(),
            SubmitButton(),
          ],
        ),
      ),
    );
  }
}

class EmailInput extends StatelessWidget {
  const EmailInput({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FormValidationController>(
      builder: (controller) {
        return TextFormField(
          initialValue: controller.email.value.value,
          decoration: InputDecoration(
            icon: const Icon(Icons.email),
            labelText: 'Email',
            helperText: 'A complete, valid email e.g. joe@gmail.com',
            errorText: controller.email.value.isValid
                ? 'Please ensure the email entered is valid'
                : null,
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: controller.onEmailChanged,
          onEditingComplete: () => controller.onEmailUnfocused(),
          textInputAction: TextInputAction.next,
        );
      },
    );
  }
}

class PasswordInput extends StatelessWidget {
  const PasswordInput({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FormValidationController>(
      builder: (controller) {
        return TextFormField(
          initialValue: controller.password.value.value,
          decoration: InputDecoration(
            icon: const Icon(Icons.lock),
            helperText:
                '''Password should be at least 8 characters with at least one letter and number''',
            helperMaxLines: 2,
            labelText: 'Password',
            errorMaxLines: 2,
            errorText: controller.password.value.displayError != null
                ? '''Password must be at least 8 characters and contain at least one letter and number'''
                : null,
          ),
          obscureText: true,
          onChanged: controller.onPasswordChanged,
          onEditingComplete: () => controller.onPasswordUnfocused(),
          textInputAction: TextInputAction.done,
        );
      },
    );
  }
}

class SubmitButton extends StatelessWidget {
  const SubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FormValidationController>();
    return Obx(
      () => ElevatedButton(
        onPressed: controller.isValid.value ? controller.onFormSubmitted : null,
        child: const Text('Submit'),
      ),
    );
  }
}
