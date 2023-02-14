part of 'user_display_bloc.dart';

@immutable
abstract class UserDisplayEvent {}

class FetchUserDataEvent extends UserDisplayEvent {}

class SortUsersByAlphabetUserDataEvent extends UserDisplayEvent {}

class SortNumericUserDataEvent extends UserDisplayEvent {}
