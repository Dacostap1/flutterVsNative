import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_vs_native/domain/repository/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  late StreamSubscription _streamSubscription;

  AuthCubit(this._authRepository) : super(AuthInitial());

  init() async {
    print('init-auth');
    _streamSubscription = _authRepository.onAuthStateChanged.listen((auhtUser) {
      print(auhtUser);
      auhtUser == null ? emit(AuthLogout()) : emit(AuthSuccess());
    });

    await Future.delayed(const Duration(seconds: 1));
    FlutterNativeSplash.remove();
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }

  void login({required String email, required String password}) async {
    await _authRepository
        .login(email: email, password: password)
        .then((value) => emit(AuthSuccess()))
        .catchError((e) {
      emit(AuthFailed(e.message));
    });
  }

  void logout() async {
    await _authRepository
        .logout()
        .then((value) => emit(AuthLogout()))
        .catchError((e) {
      emit(AuthFailed(e.message));
    });
  }
}
