part of 'add_offer_products_bloc.dart';

@immutable
sealed class AddOfferProductsEvent {}

class FetchAddOfferProductsEvent extends AddOfferProductsEvent {}

class SubmitAddOfferEvent extends AddOfferProductsEvent {
  final String description;
  final String startDate;
  final String endDate;
  final String offerValue;
  final List<String> selectedProductIds;

  SubmitAddOfferEvent({
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.offerValue,
    required this.selectedProductIds,
  });
}