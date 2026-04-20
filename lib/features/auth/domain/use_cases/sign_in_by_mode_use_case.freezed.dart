// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sign_in_by_mode_use_case.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SignInResult {

 AuthMode get mode; SignInCompletionResult? get signInCompletionResult;



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignInResult&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.signInCompletionResult, signInCompletionResult) || other.signInCompletionResult == signInCompletionResult));
}


@override
int get hashCode => Object.hash(runtimeType,mode,signInCompletionResult);

@override
String toString() {
  return 'SignInResult(mode: $mode, signInCompletionResult: $signInCompletionResult)';
}


}





/// @nodoc


class _SignInResult implements SignInResult {
  const _SignInResult({required this.mode, this.signInCompletionResult});
  

@override final  AuthMode mode;
@override final  SignInCompletionResult? signInCompletionResult;




@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SignInResult&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.signInCompletionResult, signInCompletionResult) || other.signInCompletionResult == signInCompletionResult));
}


@override
int get hashCode => Object.hash(runtimeType,mode,signInCompletionResult);

@override
String toString() {
  return 'SignInResult(mode: $mode, signInCompletionResult: $signInCompletionResult)';
}


}




/// @nodoc
mixin _$SignInCompletionResult {

 bool get newUser; bool get notificationPermissionDenied;



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignInCompletionResult&&(identical(other.newUser, newUser) || other.newUser == newUser)&&(identical(other.notificationPermissionDenied, notificationPermissionDenied) || other.notificationPermissionDenied == notificationPermissionDenied));
}


@override
int get hashCode => Object.hash(runtimeType,newUser,notificationPermissionDenied);

@override
String toString() {
  return 'SignInCompletionResult(newUser: $newUser, notificationPermissionDenied: $notificationPermissionDenied)';
}


}





/// @nodoc


class _SignInCompletionResult implements SignInCompletionResult {
  const _SignInCompletionResult({required this.newUser, required this.notificationPermissionDenied});
  

@override final  bool newUser;
@override final  bool notificationPermissionDenied;




@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SignInCompletionResult&&(identical(other.newUser, newUser) || other.newUser == newUser)&&(identical(other.notificationPermissionDenied, notificationPermissionDenied) || other.notificationPermissionDenied == notificationPermissionDenied));
}


@override
int get hashCode => Object.hash(runtimeType,newUser,notificationPermissionDenied);

@override
String toString() {
  return 'SignInCompletionResult(newUser: $newUser, notificationPermissionDenied: $notificationPermissionDenied)';
}


}




// dart format on
