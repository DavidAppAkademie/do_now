import 'package:do_now/src/app.dart';
import 'package:do_now/src/data/database_repository.dart';
import 'package:do_now/src/data/mock_database_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  await initializeDateFormatting('de_DE', null);

  final DatabaseRepository db = MockDatabaseRepository();

  runApp(App(db));
}
