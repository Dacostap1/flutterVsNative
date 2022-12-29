import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_vs_native/domain/models/auth_user.dart';
import 'package:flutter_vs_native/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<AuthUser?> get onAuthStateChanged => _firebaseAuth
      .userChanges()
      .asyncMap((user) => user == null ? null : setUser(user));

  AuthUser setUser(User user) {
    return AuthUser(id: user.uid, email: user.providerData[0].email ?? '');
  }

  @override
  Future<void> login({required String email, required String password}) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print(credential.user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  @override
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
