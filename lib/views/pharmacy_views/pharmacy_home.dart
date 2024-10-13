import 'package:flutter/material.dart';
import 'package:pharmko/components/appstyles.dart';
import 'package:pharmko/components/screen_size.dart';
import 'package:pharmko/components/spacer.dart';
import 'package:pharmko/data/appdata.dart';
import 'package:pharmko/views/medicine_store/medicine_store_page.dart';
import 'package:pharmko/views/pharmacy_views/closed_tickets_view.dart';
import 'package:pharmko/views/pharmacy_views/pharmacy_active_orders_view.dart';

class PharmacyHomePage extends StatefulWidget {
  const PharmacyHomePage({super.key});

  @override
  State<PharmacyHomePage> createState() => _PharmacyHomePageState();
}

class _PharmacyHomePageState extends State<PharmacyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  // List of section titles
  final List<String> _sections = ['Home', 'Inventory', 'Sales'];

  // List of corresponding sections' widgets
  final List<Widget> _pages = [
    PharmacyActiveTicketPage(),
    const Center(child: Text('Inventory Page')),
    const ClosedTicketsListScreen(),
  ];
  final List<IconData> _menuIcons = [
    Icons.home,
    Icons.shopping_cart_checkout_sharp,
    Icons.money,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _sections.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Drawer for mobile
  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  'https://i.pinimg.com/originals/bd/4e/c7/bd4ec7d3e70257653cb069fc46a8a616.jpg',
                ),
              ),
              color: Colors.teal,
            ),
            child: Text('Pharmko',
                style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ..._sections.asMap().entries.map((entry) {
            int index = entry.key;
            String section = entry.value;
            return ListTile(
              leading: Icon(_menuIcons[index]),
              title: Text(section),
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
                Navigator.of(context).pop(); // Close the drawer after selection
              },
            );
          }).toList(),
        ],
      ),
    );
  }

  // Top TabBar for desktop
  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      unselectedLabelStyle:
          const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
      labelStyle: const TextStyle(
          color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18),
      tabs: _sections.map((section) {
        return Tab(text: section);
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = screenWidth(context) < 600;
    // bool isMobile = screenWidth(context) < 300;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pharmko Pharmacy',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        // automaticallyImplyLeading: false,
        // Drawer is shown in mobile view, TabBar in desktop view
        bottom: PreferredSize(
          preferredSize: Size(screenWidth(context), isMobile ? 0 : 50),
          child: isMobile ? const SizedBox.shrink() : _buildTabBar(),
        ),
      ),

      drawer:
          isMobile ? _buildDrawer() : null, // Only show drawer in mobile view
      body: isMobile
          ? _pages[_selectedIndex] // Show the selected page for mobile
          : TabBarView(
              controller: _tabController,
              children: _pages, // Show TabBarView for desktop
            ),
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MedicineStorePage(
                role: Roles.pharmacy,
              ),
            ),
          );
        },
        child: Container(
          width: 200,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.teal,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.shopping_basket_rounded,
                color: Colors.white,
                size: 22,
              ),
              horizontalSpacer(size: 5),
              Text(
                "Make New Sales",
                style: AppStyles.regularStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
