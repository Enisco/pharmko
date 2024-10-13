
import 'dart:convert';

import 'package:pharmko/models/medicine_model.dart';

OrderTicketModel orderTicketModelFromJson(String str) =>
    OrderTicketModel.fromJson(json.decode(str));

String orderTicketModelToJson(OrderTicketModel data) =>
    json.encode(data.toJson());

class OrderTicketModel {
  String? ticketId;
  DateTime? timeCreated;
  String? message;
  bool? isActive;
  List<MedicineModel?>? medications;
  Buyer? buyer;
  Payment? payment;
  Buyer? deliverer;
  bool? orderConfirmed;
  bool? dispatched;
  bool? orderDelivered;
  bool? closed;
  bool? isWalkInSales;

  OrderTicketModel({
    this.ticketId,
    this.timeCreated,
    this.message,
    this.isActive,
    this.medications,
    this.buyer,
    this.payment,
    this.deliverer,
    this.orderConfirmed,
    this.dispatched,
    this.orderDelivered,
    this.closed,
    this.isWalkInSales = true,
  });

  OrderTicketModel copyWith({
    String? ticketId,
    DateTime? timeCreated,
    String? message,
    bool? isActive,
    List<MedicineModel>? medications,
    Buyer? buyer,
    Payment? payment,
    Buyer? deliverer,
    bool? orderConfirmed,
    bool? dispatched,
    bool? orderDelivered,
    bool? closed,
    bool? isWalkInSales,
  }) =>
      OrderTicketModel(
        ticketId: ticketId ?? this.ticketId,
        timeCreated: timeCreated ?? this.timeCreated,
        message: message ?? this.message,
        isActive: isActive ?? this.isActive,
        medications: medications ?? this.medications,
        buyer: buyer ?? this.buyer,
        payment: payment ?? this.payment,
        deliverer: deliverer ?? this.deliverer,
        orderConfirmed: orderConfirmed ?? this.orderConfirmed,
        dispatched: dispatched ?? this.dispatched,
        orderDelivered: orderDelivered ?? this.orderDelivered,
        closed: closed ?? this.closed,
        isWalkInSales: isWalkInSales ?? this.isWalkInSales,
      );

  factory OrderTicketModel.fromJson(Map<String, dynamic> json) =>
      OrderTicketModel(
        ticketId: json["ticketId"],
        timeCreated: json["timeCreated"] == null
            ? null
            : DateTime.parse(json["timeCreated"]),
        message: json["message"],
        isActive: json["isActive"],
        medications: json["medications"] == null
            ? []
            : List<MedicineModel>.from(
                json["medications"]!.map((x) => MedicineModel.fromJson(x))),
        buyer: json["buyer"] == null ? null : Buyer.fromJson(json["buyer"]),
        payment:
            json["payment"] == null ? null : Payment.fromJson(json["payment"]),
        deliverer: json["deliverer"] == null
            ? null
            : Buyer.fromJson(json["deliverer"]),
        orderConfirmed: json["orderConfirmed"],
        dispatched: json["dispatched"],
        orderDelivered: json["orderDelivered"],
        closed: json["closed"],
        isWalkInSales: json["isWalkInSales"],
      );

  Map<String, dynamic> toJson() => {
        "ticketId": ticketId,
        "timeCreated": timeCreated?.toIso8601String(),
        "message": message,
        "isActive": isActive,
        "medications": medications == null
            ? []
            : List<dynamic>.from(medications!.map((x) => x?.toJson())),
        "buyer": buyer?.toJson(),
        "payment": payment?.toJson(),
        "deliverer": deliverer?.toJson(),
        "orderConfirmed": orderConfirmed,
        "dispatched": dispatched,
        "orderDelivered": orderDelivered,
        "closed": closed,
        "isWalkInSales": isWalkInSales,
      };
}

class Buyer {
  String? name;
  String? email;
  String? phoneNumber;
  double? longitude;
  double? latitude;

  Buyer({
    this.name,
    this.email,
    this.phoneNumber,
    this.longitude,
    this.latitude,
  });

  Buyer copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    double? longitude,
    double? latitude,
  }) =>
      Buyer(
        name: name ?? this.name,
        email: email ?? this.email,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        longitude: longitude ?? this.longitude,
        latitude: latitude ?? this.latitude,
      );

  factory Buyer.fromJson(Map<String, dynamic> json) => Buyer(
        name: json["name"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        longitude: json["longitude"]?.toDouble(),
        latitude: json["latitude"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "phoneNumber": phoneNumber,
        "longitude": longitude,
        "latitude": latitude,
      };
}

class Payment {
  double? amount;
  bool? paid;

  Payment({
    this.amount,
    this.paid,
  });

  Payment copyWith({
    double? amount,
    bool? paid,
  }) =>
      Payment(
        amount: amount ?? this.amount,
        paid: paid ?? this.paid,
      );

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        amount: json["amount"]?.toDouble(),
        paid: json["paid"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "paid": paid,
      };
}
