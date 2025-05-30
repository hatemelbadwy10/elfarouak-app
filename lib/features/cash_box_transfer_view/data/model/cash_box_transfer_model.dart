import 'package:elfarouk_app/features/cash_box_transfer_view/domain/entity/cash_box_transfer_entity.dart';

class CashBoxTransfers {
  CashBoxTransfers({
    required this.message,
    required this.status,
    required this.data,
  });

  final dynamic message;
  final bool? status;
  final Data? data;

  factory CashBoxTransfers.fromJson(Map<String, dynamic> json) {
    return CashBoxTransfers(
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

class Datum extends CashBoxTransferEntity {
  Datum({
    required this.id,
    required this.fromCashBoxIdRaw,
    required this.toCashBoxIdRaw,
    required this.amount,
    required this.currency,
    required this.notes,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.fromCashBox,
    required this.toCashBox,
  }) : super(
    fromCashBoxId: fromCashBox?.name ?? '',
    toCashBoxId: toCashBox?.name ?? '',
    amount: amount,
    note: notes,
      transferCreatedAt: createdAt.toString(),
    creator: createdBy?.name??'No Name'
  );

  final int? id;
  final String fromCashBoxIdRaw;
  final String toCashBoxIdRaw;
  final String amount;
  final String? currency;
  final dynamic notes;
  final CreatedBy? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final CashBox? fromCashBox;
  final CashBox? toCashBox;

  factory Datum.fromJson(Map<String, dynamic> json) {
    final fromCashBox = json["from_cash_box"] == null
        ? null
        : CashBox.fromJson(json["from_cash_box"]);
    final toCashBox = json["to_cash_box"] == null
        ? null
        : CashBox.fromJson(json["to_cash_box"]);

    return Datum(
      id: json["id"],
      fromCashBoxIdRaw: json["from_cash_box_id"],
      toCashBoxIdRaw: json["to_cash_box_id"],
      amount: json["amount"],
      currency: json["currency"],
      notes: json["notes"],
      createdBy: json["created_by"] == null
          ? null
          : CreatedBy.fromJson(json["created_by"]),
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      fromCashBox: fromCashBox,
      toCashBox: toCashBox,
    );
  }
}

class CreatedBy {
  CreatedBy({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.role,
    required this.countryCode,
    required this.status,
    required this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  final int? id;
  final String? name;
  final String? phone;
  final String? email;
  final String? role;
  final String? countryCode;
  final String? status;
  final dynamic emailVerifiedAt;
  final dynamic createdAt;
  final dynamic updatedAt;
  final dynamic deletedAt;

  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return CreatedBy(
      id: json["id"],
      name: json["name"],
      phone: json["phone"],
      email: json["email"],
      role: json["role"],
      countryCode: json["country_code"],
      status: json["status"],
      emailVerifiedAt: json["email_verified_at"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      deletedAt: json["deleted_at"],
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
  final DateTime? createdAt;
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
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      deletedAt: json["deleted_at"],
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
