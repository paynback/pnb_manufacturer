import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../controller/repositories/product_category_repo.dart';

part 'product_category_event.dart';
part 'product_category_state.dart';

class ProductCategoryBloc extends Bloc<ProductCategoryEvent, ProductCategoryState> {
  final ProductCategoryRepo repo;

  ProductCategoryBloc(this.repo) : super(ProductCategoryInitial()) {
    on<FetchProductCategories>((event, emit) async {
      emit(ProductCategoryLoading());
      try {
        final categories = await repo.getProductCategories();
        emit(ProductCategoryLoaded(categories));
      } catch (e) {
        emit(ProductCategoryError(e.toString()));
      }
    });
  }
}
