// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_repository.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FetchCredentialResult {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FetchCredentialResult);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FetchCredentialResult()';
}


}





/// @nodoc


class FetchCredentialResultSuccess implements FetchCredentialResult {
  const FetchCredentialResultSuccess({required this.credential});
  

 final  OAuthCredential credential;




@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FetchCredentialResultSuccess&&(identical(other.credential, credential) || other.credential == credential));
}


@override
int get hashCode => Object.hash(runtimeType,credential);

@override
String toString() {
  return 'FetchCredentialResult.success(credential: $credential)';
}


}




/// @nodoc


class FetchCredentialResultCanceled implements FetchCredentialResult {
  const FetchCredentialResultCanceled();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FetchCredentialResultCanceled);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FetchCredentialResult.canceled()';
}


}




// dart format on
