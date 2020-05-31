part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {
  final String userUid;

  const AuthenticationSuccess(this.userUid);

  @override
  List<Object> get props => [userUid];

  @override
  String toString() => 'Authenticated { userUID: $userUid }';
}

class AuthenticationFailure extends AuthenticationState {}
