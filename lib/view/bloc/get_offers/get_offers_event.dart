part of 'get_offers_bloc.dart';

@immutable
sealed class GetOffersEvent {}

class FetchOffersEvent extends GetOffersEvent {}
