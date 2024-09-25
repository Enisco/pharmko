import 'package:firebase_database/firebase_database.dart';
import 'package:get/instance_manager.dart';
import 'package:pharmko/components/strings.dart';
import 'package:pharmko/controllers/store_controller.dart';
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

  Future<OrderTicketModel?> fecthClosedTickets() async {
    try {} catch (e, s) {
      logger.e(e, stackTrace: s);
    }
    return null;
  }
}
