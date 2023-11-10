import 'dart:convert';

import 'package:dedeowner/model/create_shop_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dedeowner/repositories/user_repository.dart';
import 'package:dedeowner/model/user_login_model.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository _userRepository;

  LoginBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(LoginInitial()) {
    on<LoginOnLoad>(_onLoginLoad);
    on<TokenLogin>(_onTokenLogin);
    on<CreateShop>(_onCreateShop);
  }

  void _onLoginLoad(LoginOnLoad event, Emitter<LoginState> emit) async {
    emit(LoginInProgress());
    try {
      final _result = await _userRepository.authenUser(event.userName, event.passWord);

      if (_result.success) {
        final appConfig = GetStorage("AppConfig");
        UserLoginModel userLogin = UserLoginModel(userName: event.userName, token: _result.data["token"]);
        appConfig.write("token", _result.data["token"]);
        emit(LoginSuccess(userLogin: userLogin));
      } else {
        emit(LoginFailed(message: 'User Not Found'));
      }
    } on Exception catch (exception) {
      emit(LoginFailed(message: 'ติดต่อ Server ไม่ได้ : ' + exception.toString()));
    } catch (e) {
      emit(LoginFailed(message: 'ติดต่อ Server ไม่ได้ : ' + e.toString()));
    }
  }

  void _onTokenLogin(TokenLogin event, Emitter<LoginState> emit) async {
    emit(TokenLoginInProgress());
    try {
      final _result = await _userRepository.authenUserByToken(event.token);

      if (_result.success) {
        print(_result.data);
        final appConfig = GetStorage("AppConfig");
        UserLoginModel userLogin = UserLoginModel(userName: "", token: _result.data["token"]);
        appConfig.write("token", _result.data["token"]);
        emit(TokenLoginSuccess(userLogin: userLogin));
      } else {
        emit(TokenLoginFailed(message: _result.message));
      }
    } on Exception catch (exception) {
      emit(TokenLoginFailed(message: 'ติดต่อ Server ไม่ได้ : ' + exception.toString()));
    } catch (e) {
      emit(TokenLoginFailed(message: 'ติดต่อ Server ไม่ได้ : ' + e.toString()));
    }
  }

  void _onCreateShop(CreateShop event, Emitter<LoginState> emit) async {
    emit(CreateShopInProgress());
    try {
      await _userRepository.createShop(event.createShop);
      emit(CreateShopSuccess());
    } catch (e) {
      final error = jsonDecode(e.toString());
      emit(CreateShopFailed(message: error['message']));
    }
  }
}
