part of 'delete_product_bloc.dart';

@immutable
sealed class DeleteProductEvent {}

class DeleteProductButtonPressed extends DeleteProductEvent {
  final String productId;

  DeleteProductButtonPressed(this.productId);
}