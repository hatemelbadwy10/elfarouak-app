import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/network/models/api_error_model.dart';
import '../../domain/entity/debtor_customers_entity.dart';
import '../../domain/repo/deptor_customers_repo.dart';

part 'debtor_customer_event.dart';
part 'debtor_customer_state.dart';

class DebtorCustomerBloc extends Bloc<DebtorCustomerEvent, DebtorCustomerState> {
  final DebtorCustomersRepo repo;

  DebtorCustomerBloc(this.repo) : super(DebtorCustomerInitial()) {
    on<GetDebtorsEvent>((event, emit) async {
      emit(DebtorCustomerLoading());

      final Either<ApiFaliureModel, List<DebtorCustomersEntity>> result =
      await repo.getDebtors();

      result.fold(
            (failure) => emit(DebtorCustomerError(failure.message)),
            (debtors) => emit(DebtorCustomerLoaded(debtors)),
      );
    });
  }
}
