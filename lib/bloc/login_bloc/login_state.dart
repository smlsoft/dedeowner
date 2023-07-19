part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginInProgress extends LoginState {}

class LoginSuccess extends LoginState {
  UserLoginModel userLogin;

  LoginSuccess({
    required this.userLogin,
  });

  @override
  List<Object> get props => [userLogin];
}

class LoginFailed extends LoginState {
  final String message;
  LoginFailed({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class TokenLoginInitial extends LoginState {}

class TokenLoginInProgress extends LoginState {}

class TokenLoginSuccess extends LoginState {
  UserLoginModel userLogin;

  TokenLoginSuccess({
    required this.userLogin,
  });

  @override
  List<Object> get props => [userLogin];
}

class TokenLoginFailed extends LoginState {
  final String message;
  TokenLoginFailed({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class CreateShopInProgress extends LoginState {}

class CreateShopSuccess extends LoginState {}

class CreateShopFailed extends LoginState {
  final String message;

  const CreateShopFailed({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
