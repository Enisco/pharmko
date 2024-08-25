class MedicineModel {
  String name;
  String description;
  double amount;
  DateTime expiryDate;
  String dosage;
  String? caution;

  MedicineModel({
    required this.name,
    required this.description,
    required this.amount,
    required this.expiryDate,
    required this.dosage,
    required this.caution,
  });

  // Method to convert a JSON map to a MedicineModel object
  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      name: json['name'],
      description: json['description'],
      amount: double.parse(((json['amount']) * 40.00).toStringAsFixed(2)),
      expiryDate: DateTime.parse(json['expiryDate']),
      dosage: json['dosage'],
      caution: json['caution'],
    );
  }

  // Method to convert a MedicineModel object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'amount': amount,
      'expiryDate': expiryDate.toIso8601String(),
      'dosage': dosage,
      'caution': caution,
    };
  }
}
