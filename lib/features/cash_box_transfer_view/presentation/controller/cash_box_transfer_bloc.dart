import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import '../../domain/repo/cash_box_transfer_repo.dart';
import 'cash_box_transfer_event.dart';
import 'cash_box_transfer_state.dart';

class CashBoxTransferBloc
    extends Bloc<CashBoxTransferEvent, CashBoxTransferState> {
  final CashBoxTransferRepo repo;

  CashBoxTransferBloc(this.repo) : super(CashBoxTransferInitial()) {
    on<GetCashBoxTransferEvent>((event, emit) async {
      emit(CashBoxTransferLoading());

      final Either failureOrTransfers = await repo.getCashBoxTransfer();

      failureOrTransfers.fold(
        (failure) => emit(CashBoxTransferError(failure.message)),
        (transfers) => emit(CashBoxTransferLoaded(transfers)),
      );
    });
    on<CompleteCashBoxTransferEvent>((event, emit) async {
      emit(CashBoxTransferCompleteLoading());

      final result = await repo.completeSuccess(event.id);

      result.fold(
        (failure) => emit(CashBoxTransferCompleteError(failure.message)),
        (successMessage) =>
            emit(CashBoxTransferCompleteSuccess(successMessage)),
      );
    });
  }
}
