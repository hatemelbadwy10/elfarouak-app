import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meta/meta.dart';
import '../../../../app_routing/route_names.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../core/services/services_locator.dart';
import '../../data/model/store_customer_model.dart';
import '../../domain/entity/customer_entity.dart';
import '../../domain/repo/customers_repo.dart';

part 'customers_event.dart';

part 'customers_state.dart';

class CustomersBloc extends Bloc<CustomersEvent, CustomersState> {
  final CustomersRepo _customersRepo;

  CustomersBloc(this._customersRepo) : super(CustomersInitial()) {
    on<GetCustomersEvent>(_getCustomers);
    on<StoreCustomerEvent>(_storeCustomer);
    on<UpdateCustomerEvent>(_updateCustomer);
    on<DeleteCustomerEvent>(_deleteCustomer);
  }

  Future<void> _getCustomers(GetCustomersEvent event,
      Emitter<CustomersState> emit) async {
    emit(CustomerLoading());
    final result = await _customersRepo.getCustomers();
    result.fold(
          (l) => emit(CustomerFailure(errMessage: l.message)),
          (r) => emit(CustomerSuccess(list: r)),
    );
  }

  Future<void> _storeCustomer(StoreCustomerEvent event,
      Emitter<CustomersState> emit) async {
    emit(StoreCustomerLoading());

    final result = await _customersRepo.storeCustomer(StoreCustomerModel(
        name: event.name,
        phone: event.phone,
        address: event.address,
        gender: event.gender,
        country: event.country,
        balance: event.balance,
        status: event.status,
        note: event.note,
        image: event.profilePic
    ));

    result.fold(
          (failure) {
        log('Store customer failed: ${failure.message}');
        emit(StoreCustomerFailure(errMessage: failure.message));
      },
          (successMessage) {
        log('Store customer success');
        emit(StoreCustomerSuccess(message: successMessage));
        Fluttertoast.showToast(msg: successMessage);
        getIt<NavigationService>().navigateToAndRemoveUntil(
          RouteNames.customerView,
          predicate: (route) => route.settings.name == RouteNames.homeView,
        );
      },
    );
  }

  Future<void> _updateCustomer(UpdateCustomerEvent event,
      Emitter<CustomersState> emit) async {
    emit(UpdateCustomerLoading());

    final result = await _customersRepo.updateCustomer(
      StoreCustomerModel(
          name: event.name,
          phone: event.phone,
          address: event.address,
          gender: event.gender,
          country: event.country,
          balance: event.balance,
          status: event.status,
          note: event.note,
          image: event.profilePic
      ),
      event.id,
    );

    result.fold(
          (l) {
        emit(UpdateCustomerFailure(errMessage: l.message));
        Fluttertoast.showToast(msg: l.message);
      },
          (r) {
        emit(UpdateCustomerSuccess(message: r));
        Fluttertoast.showToast(msg: r);
        getIt<NavigationService>().navigateToAndRemoveUntil(
          RouteNames.customerView,
          predicate: (route) => route.settings.name == RouteNames.homeView,
        );
      },
    );
  }

  Future<void> _deleteCustomer(DeleteCustomerEvent event,
      Emitter<CustomersState> emit) async {
    emit(DeleteCustomerLoading());

    final result = await _customersRepo.deleteCustomer(event.id);

    result.fold(
          (l) => emit(DeleteCustomerFailure(errMessage: l.message)),
          (r) {
        emit(DeleteCustomerSuccess(message: r));
        getIt<NavigationService>().navigateToAndRemoveUntil(
          RouteNames.customerView,
          predicate: (route) => route.settings.name == RouteNames.homeView,
        );
      },
    );
  }
}
