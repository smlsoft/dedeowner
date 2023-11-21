// ignore_for_file: sized_box_for_whitespace

import 'package:dedeowner/imports_repositories.dart';
import 'package:dedeowner/model/product_sale_model.dart';
import 'package:dedeowner/repositories/report_repository.dart';
import 'package:flutter/material.dart';
import 'package:dedeowner/global.dart' as global;
import 'package:get_storage/get_storage.dart';

class ProductSaleByOwner extends StatefulWidget {
  final String owner;
  final String manufacturerguid;
  final String fromdate;
  final String todate;
  const ProductSaleByOwner({super.key, required this.owner, required this.fromdate, required this.todate, required this.manufacturerguid});

  @override
  State<ProductSaleByOwner> createState() => _ProductSaleByOwnerState();
}

class _ProductSaleByOwnerState extends State<ProductSaleByOwner> {
  List<ProductSaleModel> productSaleList = [];
  final appConfig = GetStorage("AppConfig");
  @override
  void initState() {
    _loadData();

    super.initState();
  }

  Future<void> _loadData() async {
    productSaleList = [];

    ReportRepository reportRepository = ReportRepository();
    try {
      ApiResponse result = await reportRepository.getReportSaleSummaryByOwner(widget.fromdate, widget.todate, widget.owner);
      if (result.success) {
        List<ProductSaleModel> products = (result.data as List).map((product) => ProductSaleModel.fromJson(product)).toList();
        productSaleList = products;
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade700,
        elevation: 1,
        shadowColor: Colors.orange.shade700,
        title: Text("รายการขายสินค้า ${widget.owner.isEmpty ? appConfig.read("name") : widget.owner}"),
      ),
      body: SafeArea(
        child: (productSaleList.length > 0)
            ? Column(
                children: [
                  ListTile(
                    title: Row(
                      children: [
                        Container(
                          width: 50,
                          child: const Text("#"),
                        ),
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
                        itemCount: productSaleList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              ListTile(
                                title: Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      child: Text("${index + 1}"),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        "${productSaleList[index].itemname}@${productSaleList[index].price}",
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
                  ),
                ],
              )
            : const Center(child: Text("ไม่พบข้อมูล")),
      ),
    );
  }
}
