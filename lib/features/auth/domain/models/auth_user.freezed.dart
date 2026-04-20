// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthUser {

 String? get email; bool get hasEmailProvider; List<SocialProvider> get linkedProviders;



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthUser&&(identical(other.email, email) || other.email == email)&&(identical(other.hasEmailProvider, hasEmailProvider) || other.hasEmailProvider == hasEmailProvider)&&const DeepCollectionEquality().equals(other.linkedProviders, linkedProviders));
}


@override
int get hashCode => Object.hash(runtimeType,email,hasEmailProvider,const DeepCollectionEquality().hash(linkedProviders));

@override
String toString() {
  return 'AuthUser(email: $email, hasEmailProvider: $hasEmailProvider, linkedProviders: $linkedProviders)';
}


}





/// @nodoc


class _AuthUser implements AuthUser {
  const _AuthUser({required this.email, required this.hasEmailProvider, required final  List<SocialProvider> linkedProviders}): _linkedProviders = linkedProviders;
  

@override final  String? email;
@override final  bool hasEmailProvider;
 final  List<SocialProvider> _linkedProviders;
@override List<SocialProvider> get linkedProviders {
  if (_linkedProviders is EqualUnmodifiableListView) return _linkedProviders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_linkedProviders);
}





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthUser&&(identical(other.email, email) || other.email == email)&&(identical(other.hasEmailProvider, hasEmailProvider) || other.hasEmailProvider == hasEmailProvider)&&const DeepCollectionEquality().equals(other._linkedProviders, _linkedProviders));
}


@override
int get hashCode => Object.hash(runtimeType,email,hasEmailProvider,const DeepCollectionEquality().hash(_linkedProviders));

@override
String toString() {
  return 'AuthUser(email: $email, hasEmailProvider: $hasEmailProvider, linkedProviders: $linkedProviders)';
}


}




// dart format on
