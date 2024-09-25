// ignore_for_file: prefer_is_empty

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pharmko/components/appstyles.dart';
import 'package:pharmko/components/screen_size.dart';
import 'package:pharmko/components/spacer.dart';
import 'package:pharmko/models/ticket_model.dart';
import 'package:pharmko/pharmko_app.dart';
import 'package:pharmko/services/firebase_repo.dart';
import 'package:pharmko/shared/curved_container.dart';
import 'package:pharmko/shared/custom_button.dart';
import 'package:pharmko/shared/logger.dart';
import 'package:pharmko/views/maps_view/viewers_map.dart';
import 'package:pharmko/views/widgets/dispatch_bottomsheet.dart';
import 'package:pharmko/views/widgets/landing_page_options_card.dart';

class ActiveTicketWidget extends StatefulWidget {
  final OrderTicketModel ticketData;
  const ActiveTicketWidget({super.key, required this.ticketData});

  @override
  State<ActiveTicketWidget> createState() => _ActiveTicketWidgetState();
}

class _ActiveTicketWidgetState extends State<ActiveTicketWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _milestoneCard(widget.ticketData),
          SizedBox(
            width: screenWidth(context) - 50,
            child: Column(
              children: [
                _buyerDetailsCard(widget.ticketData),
                _orderDetailsCard(widget.ticketData),
                _paymentDetailsCard(widget.ticketData),
                _confirmedDetailsCard(widget.ticketData),
                _dispatchedDetailsCard(widget.ticketData),
                currentUserRole == Roles.pharmacy
                    ? _pharmacyTransactionCompletedCard(widget.ticketData)
                    : _patientTransactionCompletedCard(widget.ticketData),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _milestoneCard(OrderTicketModel ticket) {
    return Container(
      margin: const EdgeInsets.only(left: 6, top: 20, bottom: 20),
      width: 34,
      child: Column(
        children: [
          verticalSpacer(size: 25),
          _milestoneWidget(90, ticket.buyer != null),
          _milestoneWidget(75, (ticket.medications ?? []).length >= 1),
          _milestoneWidget(70, ticket.payment?.paid == true),
          _milestoneWidget(150, ticket.orderConfirmed == true),
          _milestoneWidget(155, ticket.dispatched == true),
          _milestoneWidget(
            1,
            currentUserRole == Roles.pharmacy
                ? ticket.closed == true
                : ticket.orderDelivered == true,
            isLast: true,
          ),
          verticalSpacer(size: 75),
        ],
      ),
    );
  }

  Widget _milestoneWidget(double height, bool isFulfilled, {bool? isLast}) {
    return SizedBox(
      child: Column(
        children: [
          Icon(
            isFulfilled
                ? Icons.check_circle_outline_rounded
                : Icons.circle_outlined,
            size: 30,
            color: isFulfilled ? Colors.teal : Colors.grey.withOpacity(0.5),
          ),
          isLast == true
              ? const SizedBox.shrink()
              : Container(
                  height: height,
                  width: 2,
                  color:
                      isFulfilled ? Colors.teal : Colors.grey.withOpacity(0.5),
                ),
        ],
      ),
    );
  }

  Widget _pharmacyTransactionCompletedCard(OrderTicketModel ticket) {
    return CustomCurvedContainer(
      borderColor: ticket.closed == true ? null : Colors.grey,
      height: 70,
      width: screenWidth(context),
      child: ticket.closed == true
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Transaction completed:",
                  style: AppStyles.headerStyle(
                      color: ticket.closed == true ? Colors.black : Colors.grey,
                      fontSize: 16),
                ),
                horizontalSpacer(size: 8),
                Text(ticket.closed == true ? "Completed " : "",
                    style: AppStyles.regularStyle(fontSize: 14)),
                horizontalSpacer(size: 4),
                ticket.closed == true
                    ? const Icon(
                        CupertinoIcons.check_mark_circled_solid,
                        color: Colors.teal,
                      )
                    : Text(
                        "Still in progress ",
                        style: AppStyles.lightStyle(
                          fontSize: 14,
                          color: ticket.closed == true
                              ? Colors.black
                              : Colors.grey,
                        ),
                      ),
              ],
            )
          : CustomButton(
              onPressed: () {
                if (ticket.orderDelivered == true) {
                  logger.i("Close Transaction Ticket");
                  FirebaseRepo().completeTransaction(ticket);
                } else {
                  Fluttertoast.showToast(
                      msg: "The customer is yet to confirm delivery");
                }
              },
              width: 200,
              height: 25,
              color: Colors.grey.withOpacity(0.5),
              child: const Text("Transaction Completed"),
            ),
    );
  }

  Widget _patientTransactionCompletedCard(OrderTicketModel ticket) {
    return CustomCurvedContainer(
      borderColor: ticket.orderDelivered == true ? null : Colors.grey,
      height: 70,
      width: screenWidth(context),
      child: ticket.orderDelivered == true
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Transaction completed:",
                  style: AppStyles.headerStyle(
                      color: ticket.orderDelivered == true
                          ? Colors.black
                          : Colors.grey,
                      fontSize: 16),
                ),
                horizontalSpacer(size: 8),
                Text(ticket.orderDelivered == true ? "Completed " : "",
                    style: AppStyles.regularStyle(fontSize: 14)),
                horizontalSpacer(size: 4),
                ticket.orderDelivered == true
                    ? const Icon(
                        CupertinoIcons.check_mark_circled_solid,
                        color: Colors.teal,
                      )
                    : Text(
                        "Still in progress ",
                        style: AppStyles.lightStyle(
                          fontSize: 14,
                          color: ticket.orderDelivered == true
                              ? Colors.black
                              : Colors.grey,
                        ),
                      ),
              ],
            )
          : CustomButton(
              onPressed: () {
                logger.i("Confirm Order Received");
                FirebaseRepo()
                    .updateTicket(ticket.copyWith(orderDelivered: true));
              },
              width: 200,
              height: 25,
              color: Colors.grey.withOpacity(0.5),
              child: const Text("Confirm Order Received"),
            ),
    );
  }

  Widget _dispatchedDetailsCard(OrderTicketModel ticket) {
    final dispatched = ticket.dispatched == true;
    return CustomCurvedContainer(
      height: 240,
      borderColor: dispatched ? Colors.teal : Colors.grey,
      width: screenWidth(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Dispatch Status",
            style: AppStyles.headerStyle(color: Colors.black, fontSize: 16),
          ),
          verticalSpacer(size: 12),
          Row(
            children: [
              Text(
                dispatched ? "Dispatched" : "Pending",
                style: AppStyles.regularStyle(
                  fontSize: 14,
                  color: dispatched ? Colors.black : Colors.grey,
                ),
              ),
              horizontalSpacer(size: 4),
              Icon(
                dispatched
                    ? CupertinoIcons.check_mark_circled_solid
                    : CupertinoIcons.hourglass,
                color: dispatched ? Colors.teal : Colors.grey,
              ),
              const Expanded(child: SizedBox()),
              currentUserRole == Roles.pharmacy && ticket.orderDelivered != true
                  ? CustomButton(
                      onPressed: () {
                        logger.i("Dispatch Order");
                        showAssignDispatcherSheet(
                          context,
                          widget.ticketData,
                        );
                      },
                      width: ticket.deliverer == null ? 80 : 140,
                      height: 25,
                      color: Colors.grey.withOpacity(0.5),
                      child: Text(
                        ticket.deliverer == null
                            ? "Dispatch"
                            : "Change Dispatcher",
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          verticalSpacer(size: 8),
          Divider(color: Colors.blueGrey.withOpacity(0.5)),
          verticalSpacer(size: 8),
          Text(
            "Dispatcher Details",
            style: AppStyles.headerStyle(
                color: dispatched ? Colors.black : Colors.grey, fontSize: 16),
          ),
          verticalSpacer(size: 12),
          Row(
            children: [
              Text("Name: ",
                  style: AppStyles.lightStyle(
                      fontSize: 14,
                      color: dispatched ? Colors.black : Colors.grey)),
              Text(
                dispatched
                    ? (ticket.deliverer?.name ?? 'Not assigned yet').toString()
                    : 'Nil',
                style: AppStyles.regularStyle(
                    color: dispatched ? Colors.black : Colors.grey),
              ),
            ],
          ),
          verticalSpacer(size: 8),
          Row(
            children: [
              Text("Phone Number: ",
                  style: AppStyles.lightStyle(
                      fontSize: 14,
                      color: dispatched ? Colors.black : Colors.grey)),
              dispatched
                  ? SelectableText(
                      dispatched ? ticket.deliverer?.phoneNumber ?? '' : 'Nil',
                      style: AppStyles.regularStyle(
                          color: dispatched ? Colors.black : Colors.grey),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          verticalSpacer(size: 12),
          CustomButton(
            height: 30,
            color: dispatched ? Colors.teal : Colors.grey,
            onPressed: dispatched
                ? () {
                    logger.f("Track clicked");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewersMapView(
                          start: LatLng(ticket.deliverer!.latitude!,
                              ticket.deliverer!.longitude!),
                          destination: LatLng(ticket.buyer!.latitude!,
                              ticket.buyer!.longitude!),
                        ),
                      ),
                    );
                  }
                : () {
                    logger.w("Package not yet dispatched");
                  },
            child: Text(
              "Track package",
              style: AppStyles.regularStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _confirmedDetailsCard(OrderTicketModel ticket) {
    final confirmed = ticket.orderConfirmed == true;
    return CustomCurvedContainer(
      height: 90,
      borderColor: confirmed ? Colors.teal : Colors.grey,
      width: screenWidth(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Confirmation Status",
            style: AppStyles.headerStyle(color: Colors.black, fontSize: 16),
          ),
          verticalSpacer(size: 12),
          Row(
            children: [
              Text(
                confirmed ? "Confirmed" : "Pending",
                style: AppStyles.regularStyle(
                  fontSize: 14,
                  color: confirmed ? Colors.black : Colors.grey,
                ),
              ),
              horizontalSpacer(size: 4),
              Icon(
                confirmed
                    ? CupertinoIcons.check_mark_circled_solid
                    : CupertinoIcons.hourglass,
                color: confirmed ? Colors.teal : Colors.grey,
              ),
              const Expanded(child: SizedBox()),
              currentUserRole == Roles.pharmacy
                  ? confirmed
                      ? const SizedBox.shrink()
                      : CustomButton(
                          onPressed: () {
                            logger.i("Confirm Order");
                            FirebaseRepo().updateTicket(
                                ticket.copyWith(orderConfirmed: true));
                          },
                          width: 80,
                          height: 25,
                          color: Colors.grey.withOpacity(0.5),
                          child: const Text("Confirm"),
                        )
                  : const SizedBox.shrink(),
            ],
          )
        ],
      ),
    );
  }

  Widget _paymentDetailsCard(OrderTicketModel ticket) {
    return CustomCurvedContainer(
      height: 70,
      width: screenWidth(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Payment Status:",
            style: AppStyles.headerStyle(color: Colors.black, fontSize: 16),
          ),
          horizontalSpacer(size: 8),
          Text(ticket.payment?.paid == true ? "Paid " : "",
              style: AppStyles.regularStyle(fontSize: 14)),
          horizontalSpacer(size: 4),
          ticket.payment?.paid == true
              ? const Icon(
                  CupertinoIcons.check_mark_circled_solid,
                  color: Colors.teal,
                )
              : Text("Not yet paid ",
                  style: AppStyles.lightStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _orderDetailsCard(OrderTicketModel ticket) {
    return CustomCurvedContainer(
      height: 100,
      width: screenWidth(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Order Details",
            style: AppStyles.headerStyle(color: Colors.teal, fontSize: 16),
          ),
          verticalSpacer(size: 8),
          Row(
            children: [
              Text("No of items: ", style: AppStyles.lightStyle(fontSize: 14)),
              Text(
                (ticket.medications?.length ?? 1).toString(),
                style: AppStyles.regularStyle(),
              ),
            ],
          ),
          verticalSpacer(size: 3),
          Row(
            children: [
              Text("Total cost: ", style: AppStyles.lightStyle(fontSize: 14)),
              Text("₦${((ticket.payment?.amount ?? 0.0) / 100)}",
                  style: AppStyles.regularStyle()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buyerDetailsCard(OrderTicketModel ticket) {
    return CustomCurvedContainer(
      height: 100,
      width: screenWidth(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Buyer Details",
            style: AppStyles.headerStyle(color: Colors.black, fontSize: 16),
          ),
          verticalSpacer(size: 8),
          Row(
            children: [
              Text("Name: ", style: AppStyles.lightStyle(fontSize: 14)),
              Text(ticket.buyer?.name ?? '', style: AppStyles.regularStyle()),
            ],
          ),
          verticalSpacer(size: 3),
          Row(
            children: [
              Text("Phone Number: ", style: AppStyles.lightStyle(fontSize: 14)),
              Text(ticket.buyer?.phoneNumber ?? '',
                  style: AppStyles.regularStyle()),
            ],
          ),
        ],
      ),
    );
  }
}
