
class AutoCompleteModel {
  final int id;
  final String label;

  AutoCompleteModel({
    required this.id,
    required this.label,
  });

  factory AutoCompleteModel.fromJson(Map<String, dynamic> json) {
    return AutoCompleteModel(
      id: json['id'],
      label: json['label']??'',
    );
  }

  @override
  String toString() => label;
}