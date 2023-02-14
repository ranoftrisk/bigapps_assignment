part of 'user_display_bloc.dart';

@immutable
abstract class UserDisplayState {}

class UserDisplayInitial extends UserDisplayState {}

class LoadingUserDisplayState extends UserDisplayState {}

class CompletedLoadingDisplayState extends UserDisplayState {}

class AnimateAlphabetDisplayState extends UserDisplayState {}

class AnimateNumericDisplayState extends UserDisplayState {}
