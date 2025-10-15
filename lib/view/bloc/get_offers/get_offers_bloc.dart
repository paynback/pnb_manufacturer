import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:paynback_manufacturer_app/controller/repositories/get_offers_repo.dart';

part 'get_offers_event.dart';
part 'get_offers_state.dart';

class GetOffersBloc extends Bloc<GetOffersEvent, GetOffersState> {
  final GetOffersRepo repo;

  GetOffersBloc(this.repo) : super(GetOffersInitial()) {
    on<FetchOffersEvent>(_onFetchOffers);
  }

  Future<void> _onFetchOffers(
      FetchOffersEvent event, Emitter<GetOffersState> emit) async {
    emit(GetOffersLoading());
    try {
      final offers = await repo.getOffers();
      print('Offers fetched: $offers');
      emit(GetOffersLoaded(offers));
    } catch (e) {
      emit(GetOffersError(e.toString()));
    }
  }
}
