// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_action_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthActionState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthActionState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthActionState()';
}


}





/// @nodoc


class AuthActionStateIdle implements AuthActionState {
  const AuthActionStateIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthActionStateIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthActionState.idle()';
}


}




/// @nodoc


class AuthActionStateProcessing implements AuthActionState {
  const AuthActionStateProcessing();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthActionStateProcessing);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthActionState.processing()';
}


}




/// @nodoc


class AuthActionStateSignedOut implements AuthActionState {
  const AuthActionStateSignedOut();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthActionStateSignedOut);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthActionState.signedOut()';
}


}




/// @nodoc


class AuthActionStateFailed implements AuthActionState {
  const AuthActionStateFailed(this.error);
  

 final  Object error;




@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthActionStateFailed&&const DeepCollectionEquality().equals(other.error, error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(error));

@override
String toString() {
  return 'AuthActionState.failed(error: $error)';
}


}




// dart format on
