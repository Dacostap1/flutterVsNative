import 'package:flutter_vs_native/domain/models/auth_user.dart';

abstract class AuthRepository {
  Stream<AuthUser?> get onAuthStateChanged;

  Future<void> login({
    required String email,
    required String password,
  });

  Future<void> logout();
}
