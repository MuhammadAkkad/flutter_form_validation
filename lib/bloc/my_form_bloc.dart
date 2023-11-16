import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_form_validation/models/models.dart';
import 'package:formz/formz.dart';

part 'my_form_state.dart';

class MyFormBloc extends Cubit<MyFormState> {
  MyFormBloc() : super(const MyFormState());

  void emailChanged(String email) {
    final emailResult = Email.dirty(email);
    emit(state.copyWith(
      email: emailResult.isValid ? emailResult : Email.pure(email),
      isValid: Formz.validate([emailResult, state.password]),
    ));
  }

  void passwordChanged(String password) {
    final passwordResult = Password.dirty(password);
    emit(state.copyWith(
      password: passwordResult.isValid ? passwordResult : Password.pure(password),
      isValid: Formz.validate([state.email, passwordResult]),
    ));
  }

  void emailUnfocused() {
    final emailResult = Email.dirty(state.email.value);
    emit(state.copyWith(
      email: emailResult,
      isValid: Formz.validate([emailResult, state.password]),
    ));
  }

  void passwordUnfocused() {
    final passwordResult = Password.dirty(state.password.value);
    emit(state.copyWith(
      password: passwordResult,
      isValid: Formz.validate([state.email, passwordResult]),
    ));
  }

  Future<void> formSubmitted() async {
    final emailResult = Email.dirty(state.email.value);
    final passwordResult = Password.dirty(state.password.value);
    emit(state.copyWith(
      email: emailResult,
      password: passwordResult,
      isValid: Formz.validate([emailResult, passwordResult]),
    ));
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      await Future<void>.delayed(const Duration(seconds: 1));
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    }
  }
}