import 'package:equatable/equatable.dart';

class CustomerPartialUpadteModel extends Equatable {
    CustomerPartialUpadteModel({
        required this.message,
        required this.status,
        required this.data,
    });

    final String? message;
    final bool? status;
    final Data? data;

    CustomerPartialUpadteModel copyWith({
        String? message,
        bool? status,
        Data? data,
    }) {
        return CustomerPartialUpadteModel(
            message: message ?? this.message,
            status: status ?? this.status,
            data: data ?? this.data,
        );
    }

    factory CustomerPartialUpadteModel.fromJson(Map<String, dynamic> json){ 
        return CustomerPartialUpadteModel(
            message: json["message"],
            status: json["status"],
            data: json["data"] == null ? null : Data.fromJson(json["data"]),
        );
    }

    @override
    List<Object?> get props => [
    message, status, data, ];
}

class Data extends Equatable {
    Data({
        required this.activities,
        required this.pagination,
    });

    final List<Activity> activities;
    final Pagination? pagination;

    Data copyWith({
        List<Activity>? activities,
        Pagination? pagination,
    }) {
        return Data(
            activities: activities ?? this.activities,
            pagination: pagination ?? this.pagination,
        );
    }

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
            activities: json["activities"] == null ? [] : List<Activity>.from(json["activities"]!.map((x) => Activity.fromJson(x))),
            pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
        );
    }

    @override
    List<Object?> get props => [
    activities, pagination, ];
}

class Activity extends Equatable {
    Activity({
        required this.id,
        required this.customerId,
        required this.date,
        required this.operation,
        required this.amount,
        required this.oldBalance,
        required this.newBalance,
        required this.operationNumber,
        required this.notes,
        required this.userName,
    });

    final int? id;
    final int? customerId;
    final DateTime? date;
    final String? operation;
    final num? amount;
    final num? oldBalance;
    final String? newBalance;
    final String? operationNumber;
    final dynamic notes;
    final String? userName;

    Activity copyWith({
        int? id,
        int? customerId,
        DateTime? date,
        String? operation,
        num? amount,
        num? oldBalance,
        String? newBalance,
        String? operationNumber,
        dynamic? notes,
        String? userName,
    }) {
        return Activity(
            id: id ?? this.id,
            customerId: customerId ?? this.customerId,
            date: date ?? this.date,
            operation: operation ?? this.operation,
            amount: amount ?? this.amount,
            oldBalance: oldBalance ?? this.oldBalance,
            newBalance: newBalance ?? this.newBalance,
            operationNumber: operationNumber ?? this.operationNumber,
            notes: notes ?? this.notes,
            userName: userName ?? this.userName,
        );
    }

    factory Activity.fromJson(Map<String, dynamic> json){ 
        return Activity(
            id: json["id"],
            customerId: json["customer_id"],
            date: DateTime.tryParse(json["date"] ?? ""),
            operation: json["operation"],
            amount: json["amount"],
            oldBalance: json["old_balance"],
            newBalance: json["new_balance"],
            operationNumber: json["operation_number"],
            notes: json["notes"],
            userName: json["user_name"],
        );
    }

    @override
    List<Object?> get props => [
    id, customerId, date, operation, amount, oldBalance, newBalance, operationNumber, notes, userName, ];
}

class Pagination extends Equatable {
    Pagination({
        required this.currentPage,
        required this.perPage,
        required this.total,
        required this.lastPage,
    });

    final String? currentPage;
    final String? perPage;
    final num? total;
    final num? lastPage;

    Pagination copyWith({
        String? currentPage,
        String? perPage,
        num? total,
        num? lastPage,
    }) {
        return Pagination(
            currentPage: currentPage ?? this.currentPage,
            perPage: perPage ?? this.perPage,
            total: total ?? this.total,
            lastPage: lastPage ?? this.lastPage,
        );
    }

    factory Pagination.fromJson(Map<String, dynamic> json){ 
        return Pagination(
            currentPage: json["current_page"],
            perPage: json["per_page"],
            total: json["total"],
            lastPage: json["last_page"],
        );
    }

    @override
    List<Object?> get props => [
    currentPage, perPage, total, lastPage, ];
}
