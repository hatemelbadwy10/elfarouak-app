import 'package:bloc/bloc.dart';
import 'package:elfarouk_app/core/utils/enums.dart';
import 'package:elfarouk_app/features/expense/data/models/store_expense_mode.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../app_routing/route_names.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../core/services/services_locator.dart';
import '../../domain/repo/expense_repo.dart';
import 'expense_state.dart';

part 'expense_event.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepo _expenseRepo;

  ExpenseBloc(this._expenseRepo) : super(const ExpenseState()) {
    on<GetExpensesEvent>(_getExpenses);
    on<StoreExpenseEvent>(_storeExpense);
    on<UpdateExpenseEvent>(_updateExpense);
    on<DeleteExpenseEvent>(_deleteExpense);
  }

  Future<void> _getExpenses(GetExpensesEvent event, Emitter<ExpenseState> emit) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final result = await _expenseRepo.getExpense();

    result.fold(
          (l) => emit(state.copyWith(
        requestStatus: RequestStatus.failure,
        errMessage: l.message,
      )),
          (r) => emit(state.copyWith(
        requestStatus: RequestStatus.success,
        list: r,
      )),
    );
  }

  Future<void> _storeExpense(StoreExpenseEvent event, Emitter<ExpenseState> emit) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final result = await _expenseRepo.storeExpense(StoreExpenseModel(
      branchId: event.branchId,
      tagId: event.tagId,
      amount: event.amount,
      description: event.description,
    ));

    result.fold(
          (l) {
        emit(state.copyWith(
          requestStatus: RequestStatus.failure,
          storeExpenseFailure: l.message,
        ));
        Fluttertoast.showToast(msg: l.message);
      },
          (r) {
        emit(state.copyWith(
          requestStatus: RequestStatus.success,
          storeExpenseSuccess: r,
        ));
        Fluttertoast.showToast(msg: r);
        getIt<NavigationService>().navigateToAndRemoveUntil(
          RouteNames.expenseView,
          predicate: (route) => route.settings.name == RouteNames.homeView,
        );
      },
    );
  }

  Future<void> _updateExpense(UpdateExpenseEvent event, Emitter<ExpenseState> emit) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final result = await _expenseRepo.updateExpense(
      StoreExpenseModel(
        tagId: event.tagId,
        amount: event.amount,
        branchId: event.branchId,
        description: event.description,
      ),
      event.id,
    );

    result.fold(
          (l) {
        emit(state.copyWith(
          requestStatus: RequestStatus.failure,
          updateExpenseFailure: l.message,
        ));
        Fluttertoast.showToast(msg: l.message);
      },
          (r) {
        emit(state.copyWith(
          requestStatus: RequestStatus.success,
          updateExpenseSuccess: r,
        ));
        Fluttertoast.showToast(msg: r);
        getIt<NavigationService>().navigateToAndRemoveUntil(
          RouteNames.expenseView,
          predicate: (route) => route.settings.name == RouteNames.homeView,
        );
      },
    );
  }

  Future<void> _deleteExpense(DeleteExpenseEvent event, Emitter<ExpenseState> emit) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final result = await _expenseRepo.deleteExpense(event.id);

    result.fold(
          (l) {
        emit(state.copyWith(
          requestStatus: RequestStatus.failure,
          deleteExpenseFailure: l.message,
        ));
        Fluttertoast.showToast(msg: l.message);
      },
          (r) {
        emit(state.copyWith(
          requestStatus: RequestStatus.success,
          deleteExpenseSuccess: r,
        ));
        Fluttertoast.showToast(msg: r);
        getIt<NavigationService>().navigateToAndRemoveUntil(
          RouteNames.expenseView,
          predicate: (route) => route.settings.name == RouteNames.homeView,
        );
      },
    );
  }
}
