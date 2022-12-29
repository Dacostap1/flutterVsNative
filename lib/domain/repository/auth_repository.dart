import 'package:flutter_vs_native/domain/models/auth_user.dart';

abstract class AuthRepository {
  Stream<AuthUser?> get onAuthStateChanged;

  void login({
    required String email,
    required String password,
  });

  void logout();
}
