// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:math';

import 'package:dedeowner/model/best_product_model.dart';
import 'package:dedeowner/model/global_model.dart';
import 'package:dedeowner/model/product_sale_model.dart';
import 'package:dedeowner/model/salesumary_model.dart';
import 'package:dedeowner/model/salesumarybyday_model.dart';
import 'package:dedeowner/repositories/client.dart';
import 'package:dedeowner/repositories/report_repository.dart';
import 'package:dedeowner/select_shop_screen.dart';
import 'package:dedeowner/usersystem/login_shop.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:dedeowner/global.dart' as global;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:pie_chart/pie_chart.dart';

class MoreMenuScreen extends StatefulWidget {
  const MoreMenuScreen({super.key});

  @override
  State<MoreMenuScreen> createState() => _MoreMenuScreenState();
}

class _MoreMenuScreenState extends State<MoreMenuScreen> {
  final appConfig = GetStorage("AppConfig");
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      resizeToAvoidBottomInset: true,
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
      ),
      body: Column(
        children: [
          Divider(
            height: 1,
            color: Colors.grey.shade400,
          ),
          ListTile(
            title: const Text("เปลี่ยนร้านค้า"),
            leading: const Icon(Icons.swap_vert),
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const SelectShopScreen()), (route) => false);
            },
          ),
          Divider(
            height: 1,
            color: Colors.grey.shade400,
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginShop()),
              );
            },
            title: const Text("ออกจากระบบ"),
            leading: const Icon(Icons.logout),
          ),
          Divider(
            height: 1,
            color: Colors.grey.shade400,
          ),
        ],
      ),
    );
  }
}
