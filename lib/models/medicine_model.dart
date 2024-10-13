import 'dart:convert';

MedicineModel medicineModelFromJson(String str) =>
    MedicineModel.fromJson(json.decode(str));

String medicineModelToJson(MedicineModel data) => json.encode(data.toJson());

class MedicineModel {
  String? id;
  String? name;
  String? description;
  double? amount;
  DateTime? expiryDate;
  String? dosage;
  String? caution;
  int? orderQuantity;
  int? itemsRemaining;

  MedicineModel({
    required this.id,
    required this.name,
    required this.description,
    required this.amount,
    required this.expiryDate,
    required this.dosage,
    required this.caution,
    this.orderQuantity = 1,
    this.itemsRemaining = 1,
  });

  // Method to convert a JSON map to a MedicineModel object
  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      amount: double.parse(((json['amount'])).toStringAsFixed(2)),
      expiryDate: DateTime.parse(json['expiryDate']),
      dosage: json['dosage'],
      caution: json['caution'],
      orderQuantity: json['orderQuantity'],
      itemsRemaining: json['itemsRemaining'],
    );
  }

  // Method to convert a MedicineModel object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'amount': amount,
      'expiryDate': expiryDate?.toIso8601String(),
      'dosage': dosage,
      'caution': caution,
      'orderQuantity': orderQuantity,
      'itemsRemaining': itemsRemaining,
    };
  }
}
