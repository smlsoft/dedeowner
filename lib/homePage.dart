import 'package:dedeowner/dashboard.dart';
import 'package:dedeowner/product_sales.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  int badgeCount = 8;
  final List<Widget> _children = [
    const DashboardScreen(),
    const ProductSaleScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
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
            icon: Icon(Icons.dashboard),
            label: 'ภาพรวม',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'ยอดขายตามสินค้า',
          ),
        ],
      ),
    );
  }
}
