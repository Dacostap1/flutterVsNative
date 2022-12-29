part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthFailed extends AuthState {
  final String message;

  AuthFailed(this.message);
}

class AuthLogout extends AuthState {}
