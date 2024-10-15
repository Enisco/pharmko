import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmko/components/appstyles.dart';
import 'package:pharmko/controllers/store_controller.dart';
import 'package:pharmko/models/medicine_model.dart';
import 'package:pharmko/shared/curved_container.dart';
import 'package:pharmko/shared/logger.dart';
import 'package:pharmko/views/medicine_store/inventory_med_details_page.dart';

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
              backgroundColor: Colors.teal,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.chevron_left_rounded,
                  size: 35,
                  color: Colors.white,
                ),
              ),
              title: Text(
                'Notifications',
                style:
                    AppStyles.regularStyle(fontSize: 20, color: Colors.white),
              ),
              bottom: TabBar(
                indicatorColor: Colors.amber.shade800,
                indicatorWeight: 2,
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle:
                    AppStyles.regularStyle(fontSize: 16, color: Colors.white),
                unselectedLabelStyle:
                    AppStyles.regularStyle(fontSize: 16, color: Colors.white70),
                tabs: const [
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
        return CustomCurvedContainer(
          // height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(medicine?.name ?? ''),
            subtitle: Text(
              'Expiry: ${DateFormat('MMM dd, yyyy').format(medicine?.expiryDate ?? DateTime.now())}',
              style: const TextStyle(fontSize: 14),
            ),
            trailing: Text(
              'Stock: ${medicine?.itemsRemaining}',
              style: const TextStyle(fontSize: 14),
            ),
            onTap: () {
              logger.w("Clicked ${medicine?.name}");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InventoryMedicineItemDetailsScreen(
                    medicine: medicine!,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
