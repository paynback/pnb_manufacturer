part of 'add_offer_products_bloc.dart';

@immutable
sealed class AddOfferProductsState {}

final class AddOfferProductsInitial extends AddOfferProductsState {}

class AddOfferProductsLoading extends AddOfferProductsState {}

class AddOfferProductsLoaded extends AddOfferProductsState {
  final List<ProductForOffer> products;
  AddOfferProductsLoaded(this.products);
}

class AddOfferProductsError extends AddOfferProductsState {
  final String message;
  AddOfferProductsError(this.message);
}

class AddOfferSubmitting extends AddOfferProductsState {}

class AddOfferSuccess extends AddOfferProductsState {
  final String message;
  AddOfferSuccess(this.message);
}