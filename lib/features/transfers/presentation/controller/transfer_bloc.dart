import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  int currentPage = 1;
  bool isLoading = false;
  bool hasReachedEnd = false;

  TransferBloc(this._transferRepo) : super(TransferInitial()) {
    on<GetTransfersEvent>(_getTransfers);
    on<StoreTransferEvent>(_storeTransfer);
    on<DeleteTransferEvent>(_deleteTransfer);
    on<UpdateTransferEvent>(_updateTransfer);
    on<FetchAutoCompleteEvent>(_autoComplete);
    on<StoreTagEvent>(_storeTag);
    on<ImagePickedEvent>(_onImagePicked);
    on<LoadMoreTransfersEvent>(_loadMoreTransfers);
    on<ConvertCurrency>(_convertCurrency);
    on<PartialUpdateCustomerEvent>(_partialUpdateCustomer);
    on<SendMoneyEvent>(_sendMoney);
    on<UpdateImage>(_updateImage);
    on<GetTagsEvent>(_getTags);
    on<UpdateStatus>(_updateStatus);
  }

  void _getTransfers(
    GetTransfersEvent event,
    Emitter<TransferState> emit,
  ) async {
    // Reset pagination parameters when doing a new search
    if (!event.isLoadMore) {
      currentPage = 1;
      hasReachedEnd = false;
      emit(GetTransfersLoading());
    }

    if (isLoading || hasReachedEnd) return;

    isLoading = true;

    final result = await _transferRepo.getTransfers(
      search: event.search,
      status: event.status,
      transferType: event.transferType,
      tagId: event.tagId,
      dateRange: event.dateRange,
      page: currentPage,
      isHome: event.isHome
    );

    isLoading = false;

    result.fold(
      (l) {
        emit(GetTransfersFailure(errMessage: l.message));
      },
      (r) {
        // Check if we've reached the end (no more items)
        if (r.list.isEmpty) {
          hasReachedEnd = true;
        }

        if (state is GetTransfersSuccess && event.isLoadMore) {
          final prevState = state as GetTransfersSuccess;
          final updatedList = List<TransferEntity>.from(prevState.list)
            ..addAll(r.list);
          emit(GetTransfersSuccess(
            rate: r.transferRate,
            list: updatedList,
            hasReachedEnd: hasReachedEnd,
            currentPage: currentPage,
            totalTransfers: r.totalTransfers,
            totalAmountReceived: r.totalAmountReceived,
            totalBalanceEgp: r.totalBalanceEgp,
            showBox: r.showBox
          ));
        } else {
          log('r ${r.totalBalanceEgp}');
          log('r ${r.totalAmountReceived}');
          log('r ${r.totalTransfers}');
          emit(GetTransfersSuccess(
              list: r.list,
              hasReachedEnd: hasReachedEnd,
              currentPage: currentPage,
              rate: r.transferRate,
            totalTransfers: r.totalTransfers,
            totalAmountReceived: r.totalAmountReceived,
            totalBalanceEgp: r.totalBalanceEgp,
            search: event.search,
            dateRange: event.dateRange,
            status: event.status,
            transferType: event.transferType,
            showBox: r.showBox
          ));
        }

        // Increment page for next load
        if (!hasReachedEnd) {
          currentPage++;
        }
      },
    );
  }

  void _loadMoreTransfers(
    LoadMoreTransfersEvent event,
    Emitter<TransferState> emit,
  ) async {
    if (state is GetTransfersSuccess && !isLoading && !hasReachedEnd) {
      final currentState = state as GetTransfersSuccess;

      add(GetTransfersEvent(
        search: event.search,
        status: event.status,
        transferType: event.transferType,
        tagId: event.tagId,
        dateRange: event.dateRange,
        isLoadMore: true,
        page: currentPage,
      ));

      // Show loading more indicator while keeping current list
      emit(GetTransfersSuccess(
        rate: currentState.rate,
        list: currentState.list,
        hasReachedEnd: currentState.hasReachedEnd,
        currentPage: currentState.currentPage,
        isLoadingMore: true,
        showBox: currentState.showBox
      ));
    }
  }

  void _storeTransfer(
      StoreTransferEvent event, Emitter<TransferState> emit) async {
    emit(StoreTransferLoading());

    final result = await _transferRepo.storeTransfer(StoreTransferModel(
        senderId: event.senderId,
        receiverId: event.receiverId,
        amountSent: event.amountSent,
        transferType: event.transferType,
        cashBoxId: event.cashBoxId,
        note: event.note,
        status: "pending",
        tagId: event.tagId,
        exchangeRateWithFee: event.exchangeRateWithFee));

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
          transferType: event.transferType,
          cashBoxId: event.cashBoxId,
          note: event.note,
          tagId: event.tagId,
          exchangeRateWithFee: event.exchangeRateWithFee),
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
    //emit(DeleteTransferLoading());
    final result = await _transferRepo.deleteTransfer(event.id);
    result.fold((l) {
      Fluttertoast.showToast(msg: l.message);

      //emit(DeleteTransferFailure(errMessage: l.message));
    }, (r) {
      Fluttertoast.showToast(msg: r);
      getIt<NavigationService>().navigateTo(RouteNames.homeView);
      //emit(DeleteTransferSuccess(message: r));
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
      log('r$r');
      emit(AutoCompleteSuccess(autoCompleteList: r));
    });
  }

  void _storeTag(StoreTagEvent event, Emitter<TransferState> emit) async {
    emit(StoreTagLoading());
    final result = await _transferRepo.storeTag(
      event.tag,
      event.type
    );
    result.fold((l) {
      log('l $l');
      emit(StoreTagFailure(errMessage: l.message));
    }, (r) {
      log('r$r');
      emit(StoreTagSuccess(title: r.label,id:r.id));
      Fluttertoast.showToast(msg: "تم الانشاء بنجاح");
    });
  }

  void _onImagePicked(ImagePickedEvent event, Emitter<TransferState> emit) {
    emit(ImagePickedState(image: event.image));
  }

  void _convertCurrency(ConvertCurrency event, Emitter<TransferState> emit) {
    if (event.branchId == 1) {
      emit(CurrencyExchanged(
          currencyExchange: event.amount / event.exchangeFee));
    } else {
      emit(CurrencyExchanged(
          currencyExchange: event.amount * event.exchangeFee));
    }
  }

  void _partialUpdateCustomer(
    PartialUpdateCustomerEvent event,
    Emitter<TransferState> emit,
  ) async {
    emit(PartialUpdateCustomerLoading());

    final result = await _transferRepo.partialUpdate(
      event.customerId,
      balance: event.balance,
      transferType: event.transferType,
      type: event.type,
    );

    result.fold(
      (failure) {
        log('Partial update failed: ${failure.message}');
        emit(PartialUpdateCustomerFailure(errMessage: failure.message));
      },
      (successMessage) {
        log('Partial update success');
        emit(PartialUpdateCustomerSuccess(message: successMessage));
      },
    );
  }

  Future<void> _sendMoney(
      SendMoneyEvent event, Emitter<TransferState> emit) async {
    emit(SendMoneyLoading());

    final result = await _transferRepo.sendMoney(
      event.fromCashBoxId,
      event.toCashBoxId,
      event.amount,
      event.note,
    );

    result.fold(
      (failure) {
        log('Send money failed: ${failure.message}');
        emit(SendMoneyFailure(errMessage: failure.message));
      },
      (successMessage) {
        log('Send money success: $successMessage');
        emit(SendMoneySuccess(message: successMessage));
      },
    );
  }

  Future<void> _updateImage(
      UpdateImage event, Emitter<TransferState> emit) async {
    final result = await _transferRepo.updateImage(event.id, event.image);
    result.fold((l) {
      Fluttertoast.showToast(msg: l.data['message']);
    }, (r) {
      Fluttertoast.showToast(msg: r);
    });
  }
    Future<void>_getTags(GetTagsEvent event,Emitter<TransferState> emit )async{
      final result = await _transferRepo.getTags(event.type);
      result.fold((l) {
        Fluttertoast.showToast(msg: l.data['message']);
      }, (r) {
        emit(GetTagsSuccess(list: r));
      });
    }
    Future<void>_updateStatus(UpdateStatus event,Emitter<TransferState> emit )async{
    final result = await _transferRepo.updateStatus(event.id, event.status);
    result.fold((l){
      log('l ${l.status}');
      log('l ${l.data}');
      log('l ${l.message}');
      Fluttertoast.showToast(msg: l.message);

    }, (r){
      log("r ${r}");
      Fluttertoast.showToast(msg: r);
    });
    }
}
