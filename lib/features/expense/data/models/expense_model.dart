import 'package:elfarouk_app/features/expense/domain/entity/expense_entity.dart';

class ExpenseModel {
  ExpenseModel({
    required this.message,
    required this.status,
    required this.data,
  });

  final String? message;
  final bool? status;
  final Data? data;

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      message: json["message"],
      status: json["status"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }
}

class Data {
  Data({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  final int? currentPage;
  final List<Datum> data;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final List<Link> links;
  final dynamic nextPageUrl;
  final String? path;
  final int? perPage;
  final dynamic prevPageUrl;
  final int? to;
  final int? total;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      currentPage: json["current_page"],
      data: json["data"] == null
          ? []
          : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      firstPageUrl: json["first_page_url"],
      from: json["from"],
      lastPage: json["last_page"],
      lastPageUrl: json["last_page_url"],
      links: json["links"] == null
          ? []
          : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
      nextPageUrl: json["next_page_url"],
      path: json["path"],
      perPage: json["per_page"],
      prevPageUrl: json["prev_page_url"],
      to: json["to"],
      total: json["total"],
    );
  }
}

class Datum extends ExpenseEntity {
  Datum({
    required this.id,
    required this.cashBoxId,
    required this.tagId,
    required this.description,
    required this.amount,
    required this.date,
    required this.reference,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.cashBox,
    required this.tag,
  }) : super(
            expenseId: id,
            expanseBranch: cashBox!.name ?? '',
            expanseAmount: amount ?? '',
            expanseDescription: description ?? '',
            expanseTag: tag?.name ?? '');

  final int? id;
  final String? cashBoxId;
  final String? tagId;
  final String? description;
  final String? amount;
  final dynamic date;
  final dynamic reference;
  final dynamic notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final CashBox? cashBox;
  final Tag? tag;

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      id: json["id"],
      cashBoxId: json["cash_box_id"],
      tagId: json["tag_id"],
      description: json["description"],
      amount: json["amount"],
      date: json["date"],
      reference: json["reference"],
      notes: json["notes"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      cashBox:
          json["cash_box"] == null ? null : CashBox.fromJson(json["cash_box"]),
      tag: json["tag"] == null ? null : Tag.fromJson(json["tag"]),
    );
  }
}

class CashBox {
  CashBox({
    required this.id,
    required this.name,
    required this.country,
    required this.currency,
    required this.balance,
    required this.note,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  final int? id;
  final String? name;
  final String? country;
  final String? currency;
  final String? balance;
  final String? note;
  final String? status;
  final dynamic createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  factory CashBox.fromJson(Map<String, dynamic> json) {
    return CashBox(
      id: json["id"],
      name: json["name"],
      country: json["country"],
      currency: json["currency"],
      balance: json["balance"],
      note: json["note"],
      status: json["status"],
      createdAt: json["created_at"],
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      deletedAt: json["deleted_at"],
    );
  }
}

class Tag {
  Tag({
    required this.id,
    required this.name,
    required this.color,
    required this.description,
    required this.status,
    required this.tagType,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String? name;
  final dynamic color;
  final dynamic description;
  final String? status;
  final String? tagType;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json["id"],
      name: json["name"],
      color: json["color"],
      description: json["description"],
      status: json["status"],
      tagType: json["tag_type"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }
}

class Link {
  Link({
    required this.url,
    required this.label,
    required this.active,
  });

  final String? url;
  final String? label;
  final bool? active;

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      url: json["url"],
      label: json["label"],
      active: json["active"],
    );
  }
}
