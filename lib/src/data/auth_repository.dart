import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<void> signInWithEmailAndPassword(String email, String pw);
  Future<String> createUserWithEmailAndPassword(String email, String pw);
  Future<void> signOut();
  Future<void> sendVerificationEmail();
  Future<void> sendPasswordResetEmail(String email);
  Stream<User?> authStateChanges();
}
