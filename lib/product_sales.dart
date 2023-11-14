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

class ProductSaleScreen extends StatefulWidget {
  const ProductSaleScreen({super.key});

  @override
  State<ProductSaleScreen> createState() => _ProductSaleScreenState();
}

class _ProductSaleScreenState extends State<ProductSaleScreen> {
  TextEditingController searchController = TextEditingController();
  final appConfig = GetStorage("AppConfig");
  List<ProductSaleModel> productSaleList = [];
  int pageActive = 0;
  final ScrollController _scrollController = ScrollController();
  bool productSaleLoad = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    _loadMoreItems();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _loadMoreItems();
      }
    });
    super.initState();
  }

  Future<void> _loadMoreItems() async {
    if (productSaleLoad) return;

    setState(() {
      productSaleLoad = true;
    });

    ReportRepository reportRepository = ReportRepository();
    try {
      ApiResponse result = await reportRepository.getSaleByProduct(searchController.text, pageActive);
      if (result.success) {
        List<ProductSaleModel> products = (result.data as List).map((product) => ProductSaleModel.fromJson(product)).toList();

        productSaleList.addAll(products);
        productSaleLoad = false;
        setState(() {});
      } else {
        setState(() {
          productSaleLoad = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        productSaleLoad = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(seconds: 2), () {
      _searchData();
    });
  }

  Future<void> _searchData() async {
    if (productSaleLoad) return;

    setState(() {
      productSaleLoad = true;
    });
    productSaleList = [];
    pageActive = 0;
    ReportRepository reportRepository = ReportRepository();
    try {
      ApiResponse result = await reportRepository.getSaleByProduct(searchController.text, pageActive);
      if (result.success) {
        List<ProductSaleModel> products = (result.data as List).map((product) => ProductSaleModel.fromJson(product)).toList();

        productSaleList.addAll(products);
        productSaleLoad = false;
        setState(() {});
      } else {
        setState(() {
          productSaleLoad = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        productSaleLoad = false;
      });
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _scrollController.dispose();
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
        leading: IconButton(
          icon: const Icon(Icons.swap_vert),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const SelectShopScreen()), (route) => false);
          },
        ),
        actions: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginShop()),
                  );
                },
              ),
            ],
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
            ),
            height: 50.0,
            child: TextField(
              autofocus: false,
              onChanged: _onSearchChanged,
              onSubmitted: (value) {
                _searchData();
              },
              controller: searchController,
              decoration: InputDecoration(
                hintStyle: const TextStyle(fontSize: 17),
                hintText: 'ค้นหาสินค้า...',
                prefixIcon: IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent.shade400,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onPressed: () {
                        _searchData();
                      },
                      child: const Text(
                        'ค้นหา',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      )),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          ListTile(
            title: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text("สินค้า", style: TextStyle(color: Colors.grey.shade800)),
                ),
                Expanded(child: Center(child: Text("จำนวน", style: TextStyle(color: Colors.grey.shade800)))),
                Expanded(child: Align(alignment: Alignment.centerRight, child: Text("มูลค่า", style: TextStyle(color: Colors.grey.shade800))))
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: productSaleList.length + (productSaleLoad ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == productSaleList.length && productSaleLoad) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Column(
                    children: [
                      ListTile(
                        title: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                (productSaleList[index].names.isNotEmpty)
                                    ? "${productSaleList[index].names.firstWhere((ele) => ele.code == "th", orElse: () => LanguageDataModel(
                                          code: 'en',
                                          name: '',
                                        )).name}@${productSaleList[index].price}"
                                    : "${productSaleList[index].barcode}@${productSaleList[index].price}",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            Expanded(
                                child: Center(
                                    child: Text(
                              global.formatNumber(productSaleList[index].qty),
                              style: const TextStyle(fontSize: 14),
                            ))),
                            Expanded(
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      global.formatNumber(productSaleList[index].sumamount),
                                      style: const TextStyle(fontSize: 14),
                                    )))
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.orange.shade200,
                      )
                    ],
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
