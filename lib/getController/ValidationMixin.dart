import 'package:formz/formz.dart';
import 'package:get/get.dart';

mixin ValidationMixin on GetxController {
  RxBool isValid = false.obs;

  void validate() {
    final List<FormzInput> inputs = getFormInputs();

    final isFormValid = inputs.every((input) => input.isValid);

    onValidationChange(isFormValid);
  }

  void onValidationChange(bool isValid);

  List<FormzInput> getFormInputs();
}