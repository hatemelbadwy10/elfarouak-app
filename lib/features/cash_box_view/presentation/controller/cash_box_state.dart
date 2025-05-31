import '../../../../core/utils/enums.dart';
import '../../domain/entity/cash_box_entity.dart';

class CashBoxState {
  final RequestStatus requestStatus;
  final List<CashBoxEntity> list;
  final String errMessage;
  final String updateCashBoxSuccess;
  final String updateCashBoxFailure;
  final String storeCashBoxFailure;
  final String storeCashBoxSuccess;
  final String deleteFailure;
  final String deleteSuccess;

  const CashBoxState({
    this.requestStatus = RequestStatus.initial,
    this.list = const [],
    this.errMessage = '',
    this.updateCashBoxSuccess = '',
    this.updateCashBoxFailure = '',
    this.storeCashBoxFailure = '',
    this.storeCashBoxSuccess = '',
    this.deleteFailure = '',
    this.deleteSuccess = '',
  });

  CashBoxState copyWith({
    RequestStatus? requestStatus,
    List<CashBoxEntity>? list,
    String? errMessage,
    String? updateCashBoxSuccess,
    String? updateCashBoxFailure,
    String? storeCashBoxFailure,
    String? storeCashBoxSuccess,
    String? deleteFailure,
    String? deleteSuccess,
  }) {
    return CashBoxState(
      requestStatus: requestStatus ?? this.requestStatus,
      list: list ?? this.list,
      errMessage: errMessage ?? this.errMessage,
      updateCashBoxSuccess: updateCashBoxSuccess ?? this.updateCashBoxSuccess,
      updateCashBoxFailure: updateCashBoxFailure ?? this.updateCashBoxFailure,
      storeCashBoxFailure: storeCashBoxFailure ?? this.storeCashBoxFailure,
      storeCashBoxSuccess: storeCashBoxSuccess ?? this.storeCashBoxSuccess,
      deleteFailure: deleteFailure ?? this.deleteFailure,
      deleteSuccess: deleteSuccess ?? this.deleteSuccess,
    );
  }
}
