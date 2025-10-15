part of 'get_offers_bloc.dart';

@immutable
sealed class GetOffersState {}

final class GetOffersInitial extends GetOffersState {}

class GetOffersLoading extends GetOffersState {}

class GetOffersLoaded extends GetOffersState {
  final List<dynamic> offers;
  GetOffersLoaded(this.offers);
}

class GetOffersError extends GetOffersState {
  final String message;
  GetOffersError(this.message);
}