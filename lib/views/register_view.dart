import 'package:flutter/material.dart';
import 'package:noteit/constants/routes.dart';
import 'package:noteit/services/auth/auth_exceptions.dart';
import 'package:noteit/services/auth/auth_service.dart';
import 'package:noteit/utilities/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    // TODO: implement initState
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Please enter your details to register an account:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'Enter Your Email'),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: 'Enter Your Password',
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(19.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 45,
                      width: 130,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Color.fromARGB(255, 27, 111, 220),
                          onSurface: Colors.grey,
                        ),
                        onPressed: () async {
                          final email = _email.text;
                          final password = _password.text;

                          try {
                            await AuthService.firebase().createUser(
                              email: email,
                              password: password,
                            );
                            final user = AuthService.firebase().currentUser;
                            AuthService.firebase().sendEmailVerification();
                            Navigator.of(context).pushNamed(verifyEmailRoute);
                          } on WeakPasswordAuthException {
                            await showErrorDialog(
                              context,
                              'Weak password',
                            );
                          } on EmailAlreadyInUseAuthException {
                            await showErrorDialog(
                              context,
                              'Email already is n use',
                            );
                          } on InvalidEmailAuthException {
                            await showErrorDialog(
                              context,
                              'Invalid password entered',
                            );
                          } on GenericAuthException {
                            await showErrorDialog(
                              context,
                              'Failed to Register',
                            );
                          }
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          loginRoute,
                          (route) => false,
                        );
                      },
                      child: const Text(
                        ' Already Registered?',
                        style: TextStyle(
                            decoration: TextDecoration.underline, fontSize: 15),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
