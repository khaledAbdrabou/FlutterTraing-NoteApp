import 'package:flutter/material.dart';
import 'package:noteit/constants/routes.dart';
import 'package:noteit/services/auth/auth_service.dart';
import 'package:noteit/views/Verify_email_view.dart';
import 'package:noteit/views/login_view.dart';
import 'package:noteit/views/notes/create_update_note_view.dart';
import 'package:noteit/views/notes/notes_view.dart';
import 'package:noteit/views/register_view.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
    routes: {
      loginRoute: ((context) => const LoginView()),
      registerRoute: ((context) => const RegisterView()),
      notesRoute: (context) => const NotesView(),
      verifyEmailRoute: (context) => const VerifyEmailView(),
      createorUpdateNewRoute: (context) => const CreateUpdateNoteView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            print(user);
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
