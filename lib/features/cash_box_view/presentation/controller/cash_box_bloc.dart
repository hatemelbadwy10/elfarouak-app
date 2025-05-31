import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:elfarouk_app/core/utils/enums.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meta/meta.dart';
import '../../../../app_routing/route_names.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../core/services/services_locator.dart';
import '../../data/model/store_cash_box_model.dart';
import '../../domain/repo/cash_box_repo.dart';
import 'cash_box_state.dart';

part 'cash_box_event.dart';

class CashBoxBloc extends Bloc<CashBoxEvent, CashBoxState> {
  final CashBoxRepo _cashBoxRepo;

  CashBoxBloc(this._cashBoxRepo) : super(const CashBoxState()) {
    on<GetCashBoxesEvent>(_getCashBoxes);
    on<StoreCashBoxEvent>(_storeCashBox);
    on<UpdateCashBoxEvent>(_updateCashBox);
    on<DeleteCashBoxEvent>(_deleteCashBox);
  }

  Future<void> _getCashBoxes(
      GetCashBoxesEvent event, Emitter<CashBoxState> emit) async {
    emit(const CashBoxState(requestStatus: RequestStatus.loading));
    final result = await _cashBoxRepo.getCashBoxes();
    result.fold(
      (l) => emit(CashBoxState(
          requestStatus: RequestStatus.failure, errMessage: l.message)),
      (r) => emit(CashBoxState(requestStatus: RequestStatus.success, list: r)),
    );
  }

  Future<void> _storeCashBox(
      StoreCashBoxEvent event, Emitter<CashBoxState> emit) async {
    emit(const CashBoxState(requestStatus: RequestStatus.loading));

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
        emit(CashBoxState(requestStatus: RequestStatus.failure, storeCashBoxFailure: failure.message));
      },
      (successMessage) {
        log('Store cash box success');
        emit(CashBoxState(requestStatus: RequestStatus.success, storeCashBoxSuccess: successMessage));
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
    emit(const CashBoxState(requestStatus: RequestStatus.loading));

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
        emit(CashBoxState(updateCashBoxFailure: l.message));
        Fluttertoast.showToast(msg: l.message);
      },
      (r) {
        emit(CashBoxState(updateCashBoxSuccess: r));
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
    emit(const CashBoxState(requestStatus: RequestStatus.loading));

    final result = await _cashBoxRepo.deleteCashBox(event.id);

    result.fold(
      (l) => emit(CashBoxState(deleteFailure: l.message)),
      (r) {
        emit(CashBoxState(deleteSuccess: r));
        Fluttertoast.showToast(msg: r);
        getIt<NavigationService>().navigateToAndRemoveUntil(
          RouteNames.cashBoxView,
          predicate: (route) => route.settings.name == RouteNames.homeView,
        );
      },
    );
  }
}
