import 'package:do_now/src/app.dart';
import 'package:do_now/src/data/database_repository.dart';
import 'package:do_now/src/data/mock_database_repository.dart';
import 'package:flutter/material.dart';

void main() {
  final DatabaseRepository db = MockDatabaseRepository();

  runApp(App(db));
}
