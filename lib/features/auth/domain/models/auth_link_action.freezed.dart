// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_link_action.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthLinkAction {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthLinkAction);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthLinkAction()';
}


}





/// @nodoc


class EmailSignInAuthLinkAction implements AuthLinkAction {
  const EmailSignInAuthLinkAction({required this.email, required this.emailLink, required this.mode, this.continueUrl});
  

 final  String email;
 final  String emailLink;
 final  AuthMode mode;
 final  Uri? continueUrl;




@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmailSignInAuthLinkAction&&(identical(other.email, email) || other.email == email)&&(identical(other.emailLink, emailLink) || other.emailLink == emailLink)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.continueUrl, continueUrl) || other.continueUrl == continueUrl));
}


@override
int get hashCode => Object.hash(runtimeType,email,emailLink,mode,continueUrl);

@override
String toString() {
  return 'AuthLinkAction.emailSignIn(email: $email, emailLink: $emailLink, mode: $mode, continueUrl: $continueUrl)';
}


}




/// @nodoc


class VerifyAndChangeEmailAuthLinkAction implements AuthLinkAction {
  const VerifyAndChangeEmailAuthLinkAction({required this.oobCode, required this.authUrl});
  

 final  String oobCode;
 final  Uri authUrl;




@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VerifyAndChangeEmailAuthLinkAction&&(identical(other.oobCode, oobCode) || other.oobCode == oobCode)&&(identical(other.authUrl, authUrl) || other.authUrl == authUrl));
}


@override
int get hashCode => Object.hash(runtimeType,oobCode,authUrl);

@override
String toString() {
  return 'AuthLinkAction.verifyAndChangeEmail(oobCode: $oobCode, authUrl: $authUrl)';
}


}




/// @nodoc


class ExternalAuthAuthLinkAction implements AuthLinkAction {
  const ExternalAuthAuthLinkAction({required this.url});
  

 final  Uri url;




@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExternalAuthAuthLinkAction&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode => Object.hash(runtimeType,url);

@override
String toString() {
  return 'AuthLinkAction.external(url: $url)';
}


}




// dart format on
