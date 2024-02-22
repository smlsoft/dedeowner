import 'package:dedeowner/dashboard.dart';
import 'package:dedeowner/global.dart';
import 'package:dedeowner/menu.dart';
import 'package:dedeowner/product_sales.dart';
import 'package:dedeowner/select_shop_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({
    super.key,
  });

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen>
    with SingleTickerProviderStateMixin {
  Widget tableInfo() {
    return Wrap(
      children: [],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          shadowColor: Colors.orange.shade700,
          automaticallyImplyLeading: false,
          title: Align(
            alignment: Alignment.center,
            child: Text(
              appConfig.read("name"),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          backgroundColor: Colors.orange.shade700,
          leading: IconButton(
            icon: const Icon(Icons.swap_vert),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const SelectShopScreen()),
                  (route) => false);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              tableInfo(),
            ],
          ),
        ));
  }
}
