// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sign_in_page_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SignInPageViewModel {

 SocialProvider? get loadingProvider;
/// Create a copy of SignInPageViewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignInPageViewModelCopyWith<SignInPageViewModel> get copyWith => _$SignInPageViewModelCopyWithImpl<SignInPageViewModel>(this as SignInPageViewModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignInPageViewModel&&(identical(other.loadingProvider, loadingProvider) || other.loadingProvider == loadingProvider));
}


@override
int get hashCode => Object.hash(runtimeType,loadingProvider);

@override
String toString() {
  return 'SignInPageViewModel(loadingProvider: $loadingProvider)';
}


}

/// @nodoc
abstract mixin class $SignInPageViewModelCopyWith<$Res>  {
  factory $SignInPageViewModelCopyWith(SignInPageViewModel value, $Res Function(SignInPageViewModel) _then) = _$SignInPageViewModelCopyWithImpl;
@useResult
$Res call({
 SocialProvider? loadingProvider
});




}
/// @nodoc
class _$SignInPageViewModelCopyWithImpl<$Res>
    implements $SignInPageViewModelCopyWith<$Res> {
  _$SignInPageViewModelCopyWithImpl(this._self, this._then);

  final SignInPageViewModel _self;
  final $Res Function(SignInPageViewModel) _then;

/// Create a copy of SignInPageViewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loadingProvider = freezed,}) {
  return _then(_self.copyWith(
loadingProvider: freezed == loadingProvider ? _self.loadingProvider : loadingProvider // ignore: cast_nullable_to_non_nullable
as SocialProvider?,
  ));
}

}



/// @nodoc


class _SignInPageViewModel implements SignInPageViewModel {
  const _SignInPageViewModel({this.loadingProvider});
  

@override final  SocialProvider? loadingProvider;

/// Create a copy of SignInPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SignInPageViewModelCopyWith<_SignInPageViewModel> get copyWith => __$SignInPageViewModelCopyWithImpl<_SignInPageViewModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SignInPageViewModel&&(identical(other.loadingProvider, loadingProvider) || other.loadingProvider == loadingProvider));
}


@override
int get hashCode => Object.hash(runtimeType,loadingProvider);

@override
String toString() {
  return 'SignInPageViewModel(loadingProvider: $loadingProvider)';
}


}

/// @nodoc
abstract mixin class _$SignInPageViewModelCopyWith<$Res> implements $SignInPageViewModelCopyWith<$Res> {
  factory _$SignInPageViewModelCopyWith(_SignInPageViewModel value, $Res Function(_SignInPageViewModel) _then) = __$SignInPageViewModelCopyWithImpl;
@override @useResult
$Res call({
 SocialProvider? loadingProvider
});




}
/// @nodoc
class __$SignInPageViewModelCopyWithImpl<$Res>
    implements _$SignInPageViewModelCopyWith<$Res> {
  __$SignInPageViewModelCopyWithImpl(this._self, this._then);

  final _SignInPageViewModel _self;
  final $Res Function(_SignInPageViewModel) _then;

/// Create a copy of SignInPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loadingProvider = freezed,}) {
  return _then(_SignInPageViewModel(
loadingProvider: freezed == loadingProvider ? _self.loadingProvider : loadingProvider // ignore: cast_nullable_to_non_nullable
as SocialProvider?,
  ));
}


}

// dart format on
