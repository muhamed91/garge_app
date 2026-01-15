import 'package:flutter/material.dart';
import 'package:garage_app/screens/dashboard/dashboard.dart';
import 'package:garage_app/screens/new-order/new.order.dart';
import 'package:garage_app/screens/reports/reports.dart';
import 'package:garage_app/screens/settings/settings.dart';

class MainTabs extends StatefulWidget {
  const MainTabs({super.key});

  @override
  State<MainTabs> createState() => _MainTabsState();
}

class _MainTabsState extends State<MainTabs> {
  int index = 0;

  final screens = const [
    Dashboard(), // 0
    Reports(),   // 1
    Settings(),  // 2
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndexFromScreenIndex(index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: Colors.grey,
        backgroundColor: AppColors.background,
        onTap: (navIndex) {
          // ➕ NEW ORDER (modal, not a tab)
          if (navIndex == 1) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const NewOrder()),
            );
            return;
          }

          setState(() {
            index = _screenIndexFromNavIndex(navIndex);
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: "New Order",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Reports",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }

  // -----------------------------
  // INDEX MAPPING (THE FIX)
  // -----------------------------

  int _screenIndexFromNavIndex(int navIndex) {
    if (navIndex < 1) return navIndex;
    return navIndex - 1;
  }

  int _navIndexFromScreenIndex(int screenIndex) {
    if (screenIndex < 1) return screenIndex;
    return screenIndex + 1;
  }
}
