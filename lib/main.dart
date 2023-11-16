import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_validation/bloc/my_form_bloc.dart';
import 'package:formz/formz.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Flutter Form Validation')),
        body: BlocProvider(
          create: (_) => MyFormBloc(),
          child: const MyForm(),
        ),
      ),
    );
  }
}

class MyForm extends StatelessWidget {
  const MyForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<MyFormBloc, MyFormState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          showDialog<void>(
            context: context,
            builder: (_) => const SuccessDialog(),
          );
        }
        if (state.status.isInProgress) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Submitting...')),
            );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            EmailInput(),
            PasswordInput(),
            const SubmitButton(),
          ],
        ),
      ),
    );
  }
}

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyFormBloc, MyFormState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.email.value,
          decoration: InputDecoration(
            icon: const Icon(Icons.email),
            labelText: 'Email',
            helperText: 'A complete, valid email e.g. joe@gmail.com',
            errorText: state.email.displayError != null
                ? 'Please ensure the email entered is valid'
                : null,
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) {
            context.read<MyFormBloc>().emailChanged(value);
          },
          textInputAction: TextInputAction.next,
        );
      },
    );
  }
}

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyFormBloc, MyFormState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.password.value,
          decoration: InputDecoration(
            icon: const Icon(Icons.lock),
            helperText:
                '''Password should be at least 8 characters with at least one letter and number''',
            helperMaxLines: 2,
            labelText: 'Password',
            errorMaxLines: 2,
            errorText: state.password.displayError != null
                ? '''Password must be at least 8 characters and contain at least one letter and number'''
                : null,
          ),
          obscureText: true,
          onChanged: (value) {
            context.read<MyFormBloc>().passwordChanged(value);
          },
          textInputAction: TextInputAction.done,
        );
      },
    );
  }
}

class SubmitButton extends StatelessWidget {
  const SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isValid = context.select((MyFormBloc bloc) => bloc.state.isValid);
    return ElevatedButton(
      onPressed:
          isValid ? () => context.read<MyFormBloc>().formSubmitted() : null,
      child: const Text('Submit'),
    );
  }
}

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Row(
              children: <Widget>[
                Icon(Icons.info),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Form Submitted Successfully!',
                      softWrap: true,
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
