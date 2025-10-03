class CashBoxReportModel {
  CashBoxReportModel({
    required this.activities,
    required this.pagination,
  });

  final List<Activity> activities;
  final Pagination? pagination;

  factory CashBoxReportModel.fromJson(Map<String, dynamic> json){
    return CashBoxReportModel(
      activities: json["activities"] == null ? [] : List<Activity>.from(json["activities"]!.map((x) => Activity.fromJson(x))),
      pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
    );
  }

}

class Activity {
  Activity({
    required this.id,
    required this.description,
    required this.old,
    required this.activityNew,
    required this.operation,
    required this.amount,
    required this.currency,
    required this.causerName,
    required this.createdAt,
    required this.event,
  });

  final int? id;
  final String? description;
  final String? old;
  final String? activityNew;
  final String? operation;
  final int? amount;
  final String? currency;
  final String? causerName;
  final DateTime? createdAt;
  final String? event;

  factory Activity.fromJson(Map<String, dynamic> json){
    return Activity(
      id: json["id"],
      description: json["description"],
      old: json["old"],
      activityNew: json["new"],
      operation: json["operation"],
      amount: json["amount"],
      currency: json["currency"],
      causerName: json["causer_name"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      event: json["event"],
    );
  }

}

class Pagination {
  Pagination({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  final int? currentPage;
  final int? lastPage;
  final int? perPage;
  final int? total;

  factory Pagination.fromJson(Map<String, dynamic> json){
    return Pagination(
      currentPage: json["current_page"],
      lastPage: json["last_page"],
      perPage: json["per_page"],
      total: json["total"],
    );
  }

}
