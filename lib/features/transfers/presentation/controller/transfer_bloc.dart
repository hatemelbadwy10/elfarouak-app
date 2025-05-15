import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../app_routing/route_names.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../core/services/services_locator.dart';
import '../../data/model/auto_complete_model.dart';
import '../../data/model/store_tranfer_model.dart';
import '../../domain/entity/transfer_entity.dart';
import '../../domain/repo/transfer_repo.dart';

part 'transfer_event.dart';

part 'transfer_state.dart';

class TransferBloc extends Bloc<TransferEvent, TransferState> {
  final TransferRepo _transferRepo;

  TransferBloc(this._transferRepo) : super(TransferInitial()) {
    on<GetTransfersEvent>(_getTransfers);
    on<StoreTransferEvent>(_storeTransfer);
    on<DeleteTransferEvent>(_deleteTransfer);
    on<UpdateTransferEvent>(_updateTransfer);
    on<FetchAutoCompleteEvent>(_autoComplete);
    on<StoreTagEvent>(_storeTag);
  }

  void _getTransfers(
      GetTransfersEvent event, Emitter<TransferState> emit) async {
    emit(GetTransfersLoading());
    final result = await _transferRepo.getTransfers(
      search: event.search,
      status: event.status,
      transferType: event.transferType,
      tagId: event.tagId,
      dateRange: event.dateRange,
    );
    log('result $result');
    result.fold((l) {
      log('l ${l.message}');
      emit(GetTransfersFailure(errMessage: l.message));
    }, (r) {
      emit(GetTransfersSuccess(list: r));
    });
  }

  void _storeTransfer(
      StoreTransferEvent event, Emitter<TransferState> emit) async {
    emit(StoreTransferLoading());

    final result = await _transferRepo.storeTransfer(StoreTransferModel(
        senderId: event.senderId,
        receiverId: event.receiverId,
        amountSent: event.amountSent,
        currencySent: event.currencySent,
        amountReceived: event.amountReceived,
        currencyReceived: event.currencyReceived,
        dayExchangeRate: event.dayExchangeRate,
        exchangeRateWithFee: event.exchangeRateWithFee,
        transferType: event.transferType,
        cashBoxId: event.cashBoxId,
        status: event.status,
        note: event.note,
        tagId: event.tagId,
        profilePicture: event.image));

    result.fold(
      (failure) {
        log('left ${failure.data}');
        log('left${failure.message}');
        log('Store transfer failed: ${failure.message}');
        log('failure.message =='
            "Transfer created successfully'${failure.message == 'Transfer created successfully'}");
        if (failure.message == 'Transfer created successfully') {
          getIt<NavigationService>().navigateToAndRemoveUntil(
            RouteNames.transfersView,
            predicate: (Route<dynamic> route) =>
                route.settings.name == RouteNames.homeView,
          );
        }
        emit(StoreTransferFailure(errMessage: failure.message));
      },
      (successMessage) {
        log('Store transfer success');
        emit(StoreTransferSuccess(message: successMessage));
      },
    );
  }

  void _updateTransfer(
      UpdateTransferEvent event, Emitter<TransferState> emit) async {
    emit(UpdateTransferLoading());
    final result = await _transferRepo.updateTransfer(
      StoreTransferModel(
        senderId: event.senderId,
        receiverId: event.receiverId,
        amountSent: event.amountSent,
        currencySent: event.currencySent,
        amountReceived: event.amountReceived,
        currencyReceived: event.currencyReceived,
        dayExchangeRate: event.dayExchangeRate,
        exchangeRateWithFee: event.exchangeRateWithFee,
        transferType: event.transferType,
        cashBoxId: event.cashBoxId,
        status: event.status,
        note: event.note,
        tagId: event.tagId,
      ),
      event.id,
    );
    result.fold((l) {
      emit(UpdateTransferFailure(errMessage: l.message));
      log('left ${l.data}');
      log('left${l.message}');
      Fluttertoast.showToast(msg: l.data['message']);
    }, (r) {
      emit(UpdateTransferSuccess(message: r));
      Fluttertoast.showToast(msg: r);
      getIt<NavigationService>().navigateToAndRemoveUntil(
        RouteNames.transfersView,
        predicate: (Route<dynamic> route) =>
            route.settings.name == RouteNames.homeView,
      );
    });
  }

  void _deleteTransfer(
      DeleteTransferEvent event, Emitter<TransferState> emit) async {
    emit(DeleteTransferLoading());
    final result = await _transferRepo.deleteTransfer(event.id);
    result.fold((l) {
      emit(DeleteTransferFailure(errMessage: l.message));
    }, (r) {
      emit(DeleteTransferSuccess(message: r));
    });
  }

  void _autoComplete(
      FetchAutoCompleteEvent event, Emitter<TransferState> emit) async {
    emit(AutoCompleteLoading());
    final result =
        await _transferRepo.autoCompleteList(event.listType, event.searchText);

    result.fold((l) {
      log('l $l');
      emit(AutoCompleteFailure(errMessage: l.message));
    }, (r) {
      log('r${r}');
      emit(AutoCompleteSuccess(autoCompleteList: r));
    });
  }

  void _storeTag(StoreTagEvent event, Emitter<TransferState> emit) async {
    emit(StoreTagLoading());
    final result = await _transferRepo.storeTag(
      event.tag,
    );
    result.fold((l) {
      log('l $l');
      emit(StoreTagFailure(errMessage: l.message));
    }, (r) {
      log('r${r}');
      emit(StoreTagSuccess(tagId: r));
    });
  }
}
