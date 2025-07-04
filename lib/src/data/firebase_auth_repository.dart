import 'package:do_now/src/data/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthRepository implements AuthRepository {
  @override
  Future<void> createUserWithEmailAndPassword(String email, String pw) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: pw);
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String pw) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: pw);
  }

  @override
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Stream<User?> authStateChanges() {
    return FirebaseAuth.instance.authStateChanges();
  }

  @override
  Future<void> sendVerificationEmail() async {
    await FirebaseAuth.instance.currentUser?.sendEmailVerification();
  }
}
