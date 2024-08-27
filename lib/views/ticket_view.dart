import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmko/components/appstyles.dart';
import 'package:pharmko/components/screen_size.dart';
import 'package:pharmko/components/spacer.dart';
import 'package:pharmko/models/ticket_model.dart';
import 'package:pharmko/pharmko_app.dart';
import 'package:pharmko/services/firebase_repo.dart';
import 'package:pharmko/shared/curved_container.dart';
import 'package:pharmko/shared/custom_button.dart';
import 'package:pharmko/shared/logger.dart';
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
        children: [
          Container(
            margin: const EdgeInsets.only(left: 6, top: 20, bottom: 20),
            width: 34,
            height: 480,
            color: Colors.amber,
          ),
          SizedBox(
            width: screenWidth(context) - 50,
            child: Column(
              children: [
                _buyerDetailsCard(widget.ticketData),
                _orderDetailsCard(widget.ticketData),
                _paymentDetailsCard(widget.ticketData),
                _confirmedDetailsCard(widget.ticketData),
                _dispatchedDetailsCard(widget.ticketData),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dispatchedDetailsCard(OrderTicketModel ticket) {
    final dispatched = ticket.dispatched == true;
    return CustomCurvedContainer(
      height: 200,
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
              // TODO: Change conditional after test
              currentUserRole != Roles.pharmacy
                  ? dispatched
                      ? const SizedBox.shrink()
                      : CustomButton(
                          onPressed: () {
                            logger.i("Confirm Order");
                            showAssignDispatcherSheet(
                              context,
                              widget.ticketData,
                            );
                          },
                          width: 80,
                          height: 25,
                          color: Colors.grey.withOpacity(0.5),
                          child: const Text("Dispatch"),
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
                (ticket.deliverer?.name ?? 'Not assigned yet').toString(),
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
                      (ticket.deliverer?.phoneNumber ?? 'None yet yet')
                          .toString(),
                      style: AppStyles.regularStyle(
                          color: dispatched ? Colors.black : Colors.grey),
                    )
                  : const SizedBox.shrink(),
            ],
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
          horizontalSpacer(size: 10),
          Text("Paid ", style: AppStyles.regularStyle(fontSize: 14)),
          horizontalSpacer(size: 4),
          const Icon(
            CupertinoIcons.check_mark_circled_solid,
            color: Colors.teal,
          ),
        ],
      ),
    );
  }

  Widget _orderDetailsCard(OrderTicketModel ticket) {
    return CustomCurvedContainer(
      height: 100,
      borderColor: Colors.orange,
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
