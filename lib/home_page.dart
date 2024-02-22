import 'package:dedeowner/dashboard.dart';
import 'package:dedeowner/global.dart';
import 'package:dedeowner/menu.dart';
import 'package:dedeowner/product_sales.dart';
import 'package:dedeowner/restaurant_screen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  int badgeCount = 8;
  final List<Widget> _children = [
    const RestaurantScreen(),
    const DashboardScreen(),
    const ProductSaleScreen(),
    const MoreMenuScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    checkDataClickhouse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _children,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.orange.shade700,
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.punch_clock),
            label: 'ร้านอาหาร',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'ภาพรวม',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'ยอดขายตามสินค้า',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'เมนู',
          ),
        ],
      ),
    );
  }
}
