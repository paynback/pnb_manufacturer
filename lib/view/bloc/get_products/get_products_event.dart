part of 'get_products_bloc.dart';

@immutable
sealed class GetProductsEvent {}

class FetchProductsEvent extends GetProductsEvent {
  FetchProductsEvent();
}