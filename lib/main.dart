import 'package:do_now/firebase_options.dart';
import 'package:do_now/src/app.dart';
import 'package:do_now/src/data/auth_repository.dart';
import 'package:do_now/src/data/database_repository.dart';
import 'package:do_now/src/data/firebase_auth_repository.dart';
import 'package:do_now/src/data/mock_database_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeDateFormatting('de_DE');

  final AuthRepository auth = FirebaseAuthRepository();
  final DatabaseRepository db = MockDatabaseRepository();

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => auth),
        Provider(create: (_) => db),
      ],
      child: App(),
    ),
  );
}
