import 'package:get/get.dart';
import 'package:formz/formz.dart';

import '../models/email.dart';
import '../models/password.dart';
import 'ValidationMixin.dart';

class FormValidationController extends GetxController with ValidationMixin {
  final email = const Email.pure().obs;
  final password = const Password.pure().obs;

  @override
  RxBool isValid = false.obs;

  @override
  void onValidationChange(bool isValid) {
    this.isValid(isValid);
  }

  @override
  List<FormzInput> getFormInputs() {
    return [email.value, password.value];
  }

  Future<void> onFormSubmitted() async {
    if (isValid.value) {
      // Handle form submission logic here
      // For example, emit(FormzSubmissionStatus.inProgress) and await a Future
      // Then emit(FormzSubmissionStatus.success)
      Get.snackbar('Form Submitted', 'Success');
    }
  }

  // Event Handlers
  void onEmailChanged(String value) {
    final emailValue = Email.dirty(value);
    email(emailValue);

    validate();
  }

  void onEmailUnfocused() {
    final emailValue = Email.dirty(email.value as String);
    email(emailValue);

    validate();
  }

  void onPasswordChanged(String value) {
    final passwordValue = Password.dirty(value);
    password(passwordValue);

    validate();
  }

  void onPasswordUnfocused() {
    final passwordValue = Password.dirty(password.value as String);
    password(passwordValue);

    validate();
  }
}