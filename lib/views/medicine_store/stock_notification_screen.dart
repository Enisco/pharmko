import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmko/controllers/store_controller.dart';
import 'package:pharmko/models/medicine_model.dart';

class StockNotificationsScreen extends StatefulWidget {
  const StockNotificationsScreen({super.key});

  @override
  State<StockNotificationsScreen> createState() =>
      _StockNotificationsScreenState();
}

class _StockNotificationsScreenState extends State<StockNotificationsScreen> {
  final controller = Get.put(PharmacyStoreController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PharmacyStoreController>(
      init: PharmacyStoreController(),
      builder: (ctxt) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Notification'),
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Expiring Soon'),
                  Tab(text: 'Low Stock'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                MedicineListView(medicines: controller.expiringSoonList),
                MedicineListView(medicines: controller.lowStockList),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MedicineListView extends StatelessWidget {
  final List<MedicineModel?> medicines;

  const MedicineListView({super.key, required this.medicines});

  @override
  Widget build(BuildContext context) {
    if (medicines.isEmpty) {
      return const Center(
        child: Text('No item to display'),
      );
    }

    return ListView.builder(
      itemCount: medicines.length,
      itemBuilder: (context, index) {
        final medicine = medicines[index];
        return ListTile(
          title: Text(medicine?.name ?? ''),
          subtitle: Text(
              'Expiry: ${medicine?.expiryDate?.toLocal().toIso8601String().substring(0, 10)}'),
          trailing: Text('Stock: ${medicine?.itemsRemaining}'),
          onTap: () {
            // Optionally handle tap events here, like showing detailed information
          },
        );
      },
    );
  }
}
