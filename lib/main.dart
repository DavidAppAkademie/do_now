import 'package:do_now/firebase_options.dart';
import 'package:do_now/src/app.dart';
import 'package:do_now/src/data/database_repository.dart';
import 'package:do_now/src/data/mock_database_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeDateFormatting('de_DE');

  final DatabaseRepository db = MockDatabaseRepository();

  runApp(App(db));
}
