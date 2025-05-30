import 'package:bloc/bloc.dart';
import 'package:elfarouk_app/features/expense/data/models/store_expense_mode.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meta/meta.dart';
import '../../../../app_routing/route_names.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../core/services/services_locator.dart';
import '../../domain/entity/expense_entity.dart';
import '../../domain/repo/expense_repo.dart';

part 'expense_event.dart';
part 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepo _expenseRepo;

  ExpenseBloc(this._expenseRepo) : super(ExpenseInitial()) {
    on<GetExpensesEvent>(_getExpenses);
    on<StoreExpenseEvent>(_storeExpense);
    on<UpdateExpenseEvent>(_updateExpense);
    on<DeleteExpenseEvent>(_deleteExpense);
  }

  Future<void> _getExpenses(GetExpensesEvent event, Emitter<ExpenseState> emit) async {
    emit(ExpenseLoading());
    final result = await _expenseRepo.getExpense();
    result.fold(
          (l) => emit(ExpenseFailure(errMessage: l.message)),
          (r) => emit(ExpenseSuccess(list: r)),
    );
  }

  Future<void> _storeExpense(StoreExpenseEvent event, Emitter<ExpenseState> emit) async {
    emit(StoreExpenseLoading());

    final result = await _expenseRepo.storeExpense(StoreExpenseModel(
      branchId: event.branchId,
      tagId: event.tagId,
      amount: event.amount,
      description: event.description,
    ));

    result.fold(
          (l) {
        emit(StoreExpenseFailure(errMessage: l.message));
        Fluttertoast.showToast(msg: l.message);
      },
          (r) {
        emit(StoreExpenseSuccess(message: r));
        Fluttertoast.showToast(msg: r);
        getIt<NavigationService>().navigateToAndRemoveUntil(
          RouteNames.expenseView,
          predicate: (route) => route.settings.name == RouteNames.homeView,
        );
      },
    );
  }

  Future<void> _updateExpense(UpdateExpenseEvent event, Emitter<ExpenseState> emit) async {
    emit(UpdateExpenseLoading());

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
        emit(UpdateExpenseFailure(errMessage: l.message));
        Fluttertoast.showToast(msg: l.message);
      },
          (r) {
        emit(UpdateExpenseSuccess(message: r));
        Fluttertoast.showToast(msg: r);
        getIt<NavigationService>().navigateToAndRemoveUntil(
          RouteNames.expenseView,
          predicate: (route) => route.settings.name == RouteNames.homeView,
        );
      },
    );
  }

  Future<void> _deleteExpense(DeleteExpenseEvent event, Emitter<ExpenseState> emit) async {
    emit(DeleteExpenseLoading());

    final result = await _expenseRepo.deleteExpense(event.id);

    result.fold(
          (l) {
        emit(DeleteExpenseFailure(errMessage: l.message));
        Fluttertoast.showToast(msg: l.message);
      },
          (r) {
        emit(DeleteExpenseSuccess(message: r));
        Fluttertoast.showToast(msg: r);
        getIt<NavigationService>().navigateToAndRemoveUntil(
          RouteNames.expenseView,
          predicate: (route) => route.settings.name == RouteNames.homeView,
        );
      },
    );
  }
}
