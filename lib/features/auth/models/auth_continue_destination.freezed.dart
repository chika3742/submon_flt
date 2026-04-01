// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_continue_destination.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthContinueDestination {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthContinueDestination);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthContinueDestination()';
}


}





/// @nodoc


class AuthContinueDestinationChangeEmail extends AuthContinueDestination {
  const AuthContinueDestinationChangeEmail({required this.newEmail}): super._();
  

 final  String newEmail;




@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthContinueDestinationChangeEmail&&(identical(other.newEmail, newEmail) || other.newEmail == newEmail));
}


@override
int get hashCode => Object.hash(runtimeType,newEmail);

@override
String toString() {
  return 'AuthContinueDestination.changeEmail(newEmail: $newEmail)';
}


}




/// @nodoc


class AuthContinueDestinationDeleteAccount extends AuthContinueDestination {
  const AuthContinueDestinationDeleteAccount(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthContinueDestinationDeleteAccount);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthContinueDestination.deleteAccount()';
}


}




// dart format on
