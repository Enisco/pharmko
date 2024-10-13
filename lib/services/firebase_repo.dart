// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:convert';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:get/instance_manager.dart';
import 'package:pharmko/components/strings.dart';
import 'package:pharmko/controllers/store_controller.dart';
import 'package:pharmko/data/medicine_list_data.dart';
import 'package:pharmko/models/medicine_model.dart';
import 'package:pharmko/models/ticket_model.dart';
import 'package:pharmko/shared/logger.dart';

class FirebaseRepo {
  createTicket(OrderTicketModel ticket) {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref(AppStrings.activeTickets);
    ref.set(ticket.toJson()).then((_) {
      logger.i("Ticket created successfully");
      Get.put(PharmacyStoreController()).resetTicketCreationData();
      return true;
    }).catchError((error) {
      logger.e("Failed to create ticket: $error");
      return false;
    });
  }

  void updateTicket(OrderTicketModel ticket) {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref(AppStrings.activeTickets);
    ref.update(ticket.toJson()).then((_) {
      logger.i("Ticket updated successfully");
    }).catchError((error) {
      logger.e("Failed to update ticket: $error");
    });
  }

  void completeTransaction(OrderTicketModel ticket) {
    // Deactivate ticket
    updateTicket(ticket.copyWith(isActive: false, closed: true));
    // Close ticket
    DatabaseReference activeRef =
        FirebaseDatabase.instance.ref("ActiveTickets");
    DatabaseReference closedRef =
        FirebaseDatabase.instance.ref("ClosedTickets/${ticket.ticketId}");

    activeRef.once().then((DatabaseEvent event) {
      if (event.snapshot.exists) {
        // Move the ticket to "ClosedTickets"
        closedRef.set(event.snapshot.value).then((_) {
          // Remove the ticket from "ActiveTickets"
          activeRef.remove().then((_) {
            logger.f(
                "Ticket moved to closedTickets and removed from ActiveTickets");
          }).catchError((error) {
            logger.e("Failed to remove ticket from ActiveTickets: $error");
          });
        }).catchError((error) {
          logger.e("Failed to move ticket to closedTickets: $error");
        });
      } else {
        logger.w("Ticket not found in ActiveTickets");
      }
    }).catchError((error) {
      logger.e("Failed to retrieve ticket: $error");
    });
  }

  Future<void> saveSalesTicket(OrderTicketModel ticket) async {
    // Deactivate ticket
    ticket = ticket.copyWith(
      isActive: false,
      closed: true,
      isWalkInSales: true,
      orderConfirmed: true,
      orderDelivered: true,
      timeCreated: DateTime.now(),
    );
    // Create Closed Sales Ticket
    DatabaseReference closedRef =
        FirebaseDatabase.instance.ref("ClosedTickets/${ticket.ticketId}");
    await closedRef.set(ticket.toJson());
  }

  Future<List<OrderTicketModel?>> fecthClosedTickets() async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref("ClosedTickets");
      // DataSnapshot snapshot = await ref.once();
      DatabaseEvent event = await ref.once();

      List<OrderTicketModel> closedTickets = [];
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> data =
            event.snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          closedTickets
              .add(orderTicketModelFromJson(jsonEncode(value)).copyWith(
            orderConfirmed: true,
            closed: true,
            isActive: false,
            orderDelivered: true,
          ));
        });
      }
      logger.f("Closed Tickets: ${closedTickets.length}");
      return closedTickets;
    } catch (e, s) {
      logger.e(e, stackTrace: s);
    }
    return [];
  }

  Future<List<MedicineModel?>> fecthMedicinesInventory() async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref("inventory");
      DatabaseEvent event = await ref.once();

      List<MedicineModel> inventoryList = [];
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> data =
            event.snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          inventoryList.add(medicineModelFromJson(jsonEncode(value)));
        });
      }
      logger.f(
          "Inventory List: ${inventoryList.length}, \n${inventoryList.first.toJson()} ");
      return inventoryList;
    } catch (e, s) {
      logger.e(e, stackTrace: s);
    }
    return [];
  }

  List<MedicineModel?> updateInventoryBasedOnCart(
      List<MedicineModel?> cartList, List<MedicineModel?> inventoryList) {
    // Create a copy of the inventory list to avoid modifying the list while iterating
    List<MedicineModel?> updatedInventoryList = List.from(inventoryList);

    for (var cartItem in cartList) {
      // Find the matching item in the copied inventory list by comparing the "id"
      var inventoryItem = updatedInventoryList.firstWhere(
        (item) => item?.id == cartItem?.id,
        orElse: () => throw Exception(
            'Item with id ${cartItem?.id} not found in inventory'),
      );

      // Subtract the orderQuantity from the itemsRemaining in the copied inventory list
      inventoryItem?.itemsRemaining =
          (inventoryItem.itemsRemaining ?? 0) - (cartItem?.orderQuantity ?? 1);

      // Ensure itemsRemaining does not go below zero
      if ((inventoryItem?.itemsRemaining ?? 0) < 0) {
        inventoryItem?.itemsRemaining = 0;
      }
    }

    // Return the updated inventory list
    return updatedInventoryList;
  }

  Future<void> updateInventoryInDatabase(
      List<MedicineModel?> updatedInventoryList) async {
    // Reference to Firebase Realtime Database "inventory" collection
    DatabaseReference databaseRef =
        FirebaseDatabase.instance.ref().child("inventory");

    // Step 1: Delete the entire inventory repository in Firebase
    await databaseRef.remove();

    // Step 2: Re-upload the updated list to Firebase
    for (var medicine in updatedInventoryList) {
      if (medicine != null) {
        await databaseRef.push().set(medicine.toJson());
        Future.delayed(const Duration(milliseconds: 10));
      }
    }
  }

  Future<void> updateInventory(
    List<MedicineModel?> cartList,
    List<MedicineModel?> inventoryList,
  ) async {
    final List<MedicineModel?> updatedInventoryList =
        updateInventoryBasedOnCart(cartList, inventoryList);

    await updateInventoryInDatabase(updatedInventoryList);
  }

  String generateRandomId(int length) {
    const characters =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(length,
          (_) => characters.codeUnitAt(random.nextInt(characters.length))),
    );
  }

  int generateRandomItemsRemaining() {
    final random = Random();
    return 100 + random.nextInt(401); // Random number between 100 and 500
  }

  Future<void> uploadMedicineList() async {
    DatabaseReference databaseRef =
        FirebaseDatabase.instance.ref().child("inventory");

    for (var medicine in medicineListJson) {
      var modifiableMedicine = Map<String, dynamic>.from(medicine);

      modifiableMedicine["id"] = generateRandomId(12);
      modifiableMedicine["itemsRemaining"] = generateRandomItemsRemaining();

      await databaseRef.push().set(modifiableMedicine);
    }
  }
}
