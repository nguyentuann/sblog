part of 'search_bloc.dart';

abstract class SearchEvent {}


class SearchStart extends SearchEvent {
  final String keyword;
  SearchStart(this.keyword);
}