import 'package:elfarouk_app/features/customers/domain/entity/customer_entity.dart';

class CustomerModel {
  CustomerModel({
    required this.message,
    required this.status,
    required this.data,
  });

  final String? message;
  final bool? status;
  final Data? data;

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
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

class Datum extends CustomerEntity {
  Datum({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.status,
    required this.gender,
    required this.note,
    required this.balance,
    required this.country,
    required this.profilePicture,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  }) : super(
            customerId: id!,
            customerName: name!,
            customerPhone: phone!,
            customerAddress: address!,
            customerGender: gender!,
            customerNote: note!,
            customerBalance: balance!,
            customerCountry: country!,
            customerProfilePicture: profilePicture!);

  final int? id;
  final String? name;
  final String? phone;
  final String? address;
  final String? status;
  final String? gender;
  final String? note;
  final String? balance;
  final String? country;
  final String? profilePicture;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      id: json["id"],
      name: json["name"],
      phone: json["phone"],
      address: json["address"],
      status: json["status"],
      gender: json["gender"],
      note: json["note"],
      balance: json["balance"],
      country: json["country"],
      profilePicture: json["profile_picture"]??'',
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
