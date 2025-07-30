import 'package:device_preview/device_preview.dart';
import 'package:do_now/firebase_options.dart';
import 'package:do_now/src/app.dart';
import 'package:do_now/src/data/auth_repository.dart';
import 'package:do_now/src/data/database_repository.dart';
import 'package:do_now/src/data/firebase_auth_repository.dart';
import 'package:do_now/src/data/firestore_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main.g.dart';

@Riverpod(keepAlive: true)
DatabaseRepository db(Ref ref) {
  return FirestoreRepository();
}

@Riverpod(keepAlive: true)
AuthRepository auth(Ref ref) {
  return FirebaseAuthRepository();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeDateFormatting('de_DE');

  runApp(
    ProviderScope(
      child: DevicePreview(
        enabled: false,
        builder: (context) => App(),
      ),
    ),
  );
}
