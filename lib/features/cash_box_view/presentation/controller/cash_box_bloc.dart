import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meta/meta.dart';
import '../../../../app_routing/route_names.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../core/services/services_locator.dart';
import '../../data/model/store_cash_box_model.dart';
import '../../data/model/update_model.dart';
import '../../domain/entity/cash_box_entity.dart';
import '../../domain/repo/cash_box_repo.dart';

part 'cash_box_event.dart';

part 'cash_box_state.dart';

class CashBoxBloc extends Bloc<CashBoxEvent, CashBoxState> {
  final CashBoxRepo _cashBoxRepo;

  CashBoxBloc(this._cashBoxRepo) : super(CashBoxInitial()) {
    on<GetCashBoxesEvent>(_getCashBoxes);
    on<StoreCashBoxEvent>(_storeCashBox);
    on<UpdateCashBoxEvent>(_updateCashBox);
    on<DeleteCashBoxEvent>(_deleteCashBox);
    on<UpdateCashBoxBalanceEvent>(_updateCashBoxBalance);
  }

  Future<void> _getCashBoxes(
      GetCashBoxesEvent event, Emitter<CashBoxState> emit) async {
    emit(CashBoxLoading());
    final result = await _cashBoxRepo.getCashBoxes();
    result.fold(
      (l) => emit(CashBoxFailure(errMessage: l.message)),
      (r) => emit(CashBoxSuccess(list: r)),
    );
  }

  Future<void> _storeCashBox(
      StoreCashBoxEvent event, Emitter<CashBoxState> emit) async {
    emit(StoreCashBoxLoading());

    final result = await _cashBoxRepo.storeCashBox(StoreCashBoxModel(
      name: event.name,
      country: event.country,
      balance: event.balance,
      note: event.note,
      status: event.status,
    ));

    result.fold(
      (failure) {
        log('Store cash box failed: ${failure.message}');
        emit(StoreCashBoxFailure(errMessage: failure.message));
      },
      (successMessage) {
        log('Store cash box success');
        emit(StoreCashBoxSuccess(message: successMessage));
        Fluttertoast.showToast(msg: successMessage);
        getIt<NavigationService>().navigateToAndRemoveUntil(
          RouteNames.cashBoxView,
          predicate: (route) => route.settings.name == RouteNames.homeView,
        );
      },
    );
  }

  Future<void> _updateCashBox(
      UpdateCashBoxEvent event, Emitter<CashBoxState> emit) async {
    emit(UpdateCashBoxLoading());

    final result = await _cashBoxRepo.updateCashBox(
      StoreCashBoxModel(
        name: event.name,
        country: event.country,
        balance: event.balance,
        note: event.note,
        status: event.status,
      ),
      event.id,
    );

    result.fold(
      (l) {
        emit(UpdateCashBoxFailure(errMessage: l.message));
        Fluttertoast.showToast(msg: l.message);
      },
      (r) {
        emit(UpdateCashBoxSuccess(message: r));
        Fluttertoast.showToast(msg: r);
        getIt<NavigationService>().navigateToAndRemoveUntil(
          RouteNames.cashBoxView,
          predicate: (route) => route.settings.name == RouteNames.homeView,
        );
      },
    );
  }

  Future<void> _deleteCashBox(
      DeleteCashBoxEvent event, Emitter<CashBoxState> emit) async {
    emit(DeleteCashBoxLoading());

    final result = await _cashBoxRepo.deleteCashBox(event.id);

    result.fold(
      (l) => emit(DeleteCashBoxFailure(errMessage: l.message)),
      (r) {
        emit(DeleteCashBoxSuccess(message: r));
        Fluttertoast.showToast(msg: r);
        getIt<NavigationService>().navigateToAndRemoveUntil(
          RouteNames.cashBoxView,
          predicate: (route) => route.settings.name == RouteNames.homeView,
        );
      },
    );
  }

  Future _updateCashBoxBalance(
      UpdateCashBoxBalanceEvent event, Emitter<CashBoxState> emit) async {
    emit(UpdateCashBoxBalanceLoading());
    final result = await _cashBoxRepo.updateCashBoxBalance(event.id,event.updateModel);
    result.fold((l) => emit(UpdateCashBoxBalanceFailure(errorMsg: l.message)),
        (r) => emit(UpdateCashBoxBalanceSuccess(r)));
  }
}
