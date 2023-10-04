// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:math';

import 'package:dedeowner/model/best_product_model.dart';
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

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<GlobalKey> keys = List.generate(
    13,
    (index) => GlobalKey(),
  );
  Timer? reFreshTimer;
  final widgetKeyDaily = GlobalKey();
  final widgetKeyDeliveryDaily = GlobalKey();
  final widgetKeyWeekly = GlobalKey();
  final widgetKeyDeliveryWeekly = GlobalKey();
  final widgetKeyMonthly = GlobalKey();
  final widgetKeyDeliveryMonthly = GlobalKey();
  final widgetKeyThreeMonthly = GlobalKey();
  final widgetKeyDeliveryThreeMonthly = GlobalKey();
  final widgetKeyYearly = GlobalKey();
  final widgetKeyDeliveryYearly = GlobalKey();
  int Piekey = 0;
  DateTime selectedDateGraph = DateTime.now();

  void _selectPreviousWeek() {
    setState(() {
      selectedDateGraph = selectedDateGraph.subtract(const Duration(days: 7));
    });
  }

  void _selectNextWeek() {
    setState(() {
      selectedDateGraph = selectedDateGraph.add(const Duration(days: 7));
    });
  }

  final colorList = <Color>[
    const Color(0xfffdcb6e),
    const Color(0xff0984e3),
    const Color(0xfffd79a8),
    const Color(0xffe17055),
    const Color(0xff6c5ce7),
  ];

  final gradientList = <List<Color>>[
    [
      const Color.fromRGBO(223, 250, 92, 1),
      const Color.fromRGBO(129, 250, 112, 1),
    ],
    [
      const Color.fromRGBO(129, 182, 205, 1),
      const Color.fromRGBO(91, 253, 199, 1),
    ],
    [
      const Color.fromRGBO(175, 63, 62, 1.0),
      const Color.fromRGBO(254, 154, 92, 1),
    ],
    [
      const Color.fromARGB(255, 238, 157, 168),
      const Color.fromARGB(255, 254, 219, 223),
    ],
    [
      const Color.fromARGB(255, 97, 67, 133),
      const Color.fromARGB(255, 81, 98, 149),
    ],
    [
      const Color.fromARGB(255, 222, 212, 240),
      const Color.fromARGB(255, 249, 172, 169),
    ]
  ];
  bool saleSummaryLoad = true;
  bool dailyLoad = true;
  bool weeklyLoad = true;
  bool monthlyLoad = true;
  bool threeMonthlyLoad = true;
  bool yearlyLoad = true;
  bool bestSellLoad = true;
  bool isSaleShop = false;
  bool isDeliveryShop = false;
  List<Widget> widgetList = [];
  List<bool> loadSuccess = [];
  SalesumaryModel salesumary = SalesumaryModel(
      cash: 0,
      takeAway: 0,
      cashierAmount: 0,
      qrcodeAmount: 0,
      walletAmount: 0,
      deliveryAmount: 0,
      gpAmount: 0,
      qrcode: [],
      wallet: [],
      delivery: [],
      bestseller: [],
      bestsellerdelivery: [],
      bestsellershop: []);

  SalesumaryByDayModel saleByDay = SalesumaryByDayModel();

  SalesumaryModel dailysale = SalesumaryModel(
      cash: 0,
      takeAway: 0,
      cashierAmount: 0,
      qrcodeAmount: 0,
      walletAmount: 0,
      deliveryAmount: 0,
      gpAmount: 0,
      qrcode: [],
      wallet: [],
      delivery: [],
      bestseller: [],
      bestsellerdelivery: [],
      bestsellershop: []);
  SalesumaryModel weeklysale = SalesumaryModel(
      cash: 0,
      takeAway: 0,
      cashierAmount: 0,
      qrcodeAmount: 0,
      walletAmount: 0,
      deliveryAmount: 0,
      gpAmount: 0,
      qrcode: [],
      wallet: [],
      delivery: [],
      bestseller: [],
      bestsellerdelivery: [],
      bestsellershop: []);
  SalesumaryModel monthlysale = SalesumaryModel(
      cash: 0,
      takeAway: 0,
      cashierAmount: 0,
      qrcodeAmount: 0,
      walletAmount: 0,
      deliveryAmount: 0,
      gpAmount: 0,
      qrcode: [],
      wallet: [],
      delivery: [],
      bestseller: [],
      bestsellerdelivery: [],
      bestsellershop: []);
  SalesumaryModel threemonthlysale = SalesumaryModel(
      cash: 0,
      takeAway: 0,
      cashierAmount: 0,
      qrcodeAmount: 0,
      walletAmount: 0,
      deliveryAmount: 0,
      gpAmount: 0,
      qrcode: [],
      wallet: [],
      delivery: [],
      bestseller: [],
      bestsellerdelivery: [],
      bestsellershop: []);
  SalesumaryModel yearlysale = SalesumaryModel(
      cash: 0,
      takeAway: 0,
      cashierAmount: 0,
      qrcodeAmount: 0,
      walletAmount: 0,
      deliveryAmount: 0,
      gpAmount: 0,
      qrcode: [],
      wallet: [],
      delivery: [],
      bestseller: [],
      bestsellerdelivery: [],
      bestsellershop: []);
  List<BestProductModel> bestSeller = [];
  List<BestProductModel> bestPosSeller = [];
  List<BestProductModel> bestDeliverySeller = [];
  List<ChartData> chartWeeklyData = [];
  List<ChartData> chartPOSData = [];
  List<ChartData> chartDeliveryData = [];
  List<ChartData> chartPOSDataWeekly = [];
  List<ChartData> chartDeliveryDataWeekly = [];
  List<ChartData> chartPOSDataThreeMonthly = [];
  List<ChartData> chartDeliveryDataThreeMonthly = [];
  List<ChartData> chartPOSDataMonthly = [];
  List<ChartData> chartDeliveryDataMonthly = [];
  List<ChartData> chartPOSDataYearly = [];
  List<ChartData> chartDeliveryDataYearly = [];
  ScrollController _scrollController = ScrollController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  List<String> dropdownSelect = ['รายวัน', 'รายสัปดาห์', 'รายเดือน', 'รายปี'];
  List<String> graphSelect = ['รายวัน', 'รายสัปดาห์', 'รายเดือน', 'รายปี'];
  List<String> graphDeliverySelect = ['รายวัน', 'รายสัปดาห์', 'รายเดือน', 'รายปี'];
  String selectedItem = 'รายวัน';
  String graphSelectedItem = 'รายวัน';
  String graphDeliverySelectedItem = 'รายวัน';

  double opacityText = 1;
  final appConfig = GetStorage("AppConfig");
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  // Future<void> _handleRefresh() async {
  //   await Future.delayed(const Duration(seconds: 2));
  //   getReport();
  // }

  @override
  void initState() {
    fromDateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    toDateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    // salesumary.cash = 6000;
    // salesumary.takeAway = 5000;

    // salesumary.qrcode.add(WalletPaymentModel(code: 'QR001', name: 'เฮียจืด', amount: 700));
    // salesumary.qrcode.add(WalletPaymentModel(code: 'QR002', name: 'เจ๊จุ๋ม', amount: 600));
    // salesumary.qrcode.add(WalletPaymentModel(code: 'QR003', name: 'เจ๊เพ็ญ', amount: 500));

    // salesumary.wallet.add(WalletPaymentModel(code: 'TRUE', name: 'TrueMoney', amount: 300));
    // salesumary.wallet.add(WalletPaymentModel(code: 'SHOPEE', name: 'Shopee', amount: 800));
    // salesumary.wallet.add(WalletPaymentModel(code: 'MANEE', name: 'แม่มณีPay', amount: 1200));

    // salesumary.delivery.add(DeliveryPaymentModel(code: 'foodpanda', name: 'Foodpanda', amount: 2000, gpPercent: 31, gpAmount: 0));
    // salesumary.delivery.add(DeliveryPaymentModel(code: 'grab', name: 'Grab', amount: 1500, gpPercent: 30.5, gpAmount: 0));
    // salesumary.delivery.add(DeliveryPaymentModel(code: 'lineman', name: 'LineMan', amount: 2000, gpPercent: 32.5, gpAmount: 0));
    // salesumary.delivery.add(DeliveryPaymentModel(code: 'shopee', name: 'Shopee', amount: 3000, gpPercent: 32, gpAmount: 0));

    // salesumary.bestseller.add(ProductModel(
    //     imgUri: "https://dedeposblosstorage.blob.core.windows.net/dedeposdevcontainer/2QoilMQkX9i6vtAE88ilEubnrhz/2QrRYK6znPoFNyFbmaengspfZch.png",
    //     barcode: "A00001",
    //     name: "ไก่ทอดน้ำปลา",
    //     qty: 15,
    //     unit: "จาน"));
    // salesumary.bestseller.add(ProductModel(
    //     imgUri: "https://dedeposblosstorage.blob.core.windows.net/dedeposdevcontainer/2QoilMQkX9i6vtAE88ilEubnrhz/2QrRbJsMd1e3Tjy7QRjGOcffheT.png",
    //     barcode: "A00002",
    //     name: "ปลาทอดน้ำปลา",
    //     qty: 13,
    //     unit: "จาน"));
    // salesumary.bestseller.add(ProductModel(
    //     imgUri: "https://dedeposblosstorage.blob.core.windows.net/dedeposdevcontainer/2QoilMQkX9i6vtAE88ilEubnrhz/2QrRddGUcSt8aYujZlWfNKHlWpA.png",
    //     barcode: "A00003",
    //     name: "ปลาทอดสมุนไพร",
    //     qty: 12,
    //     unit: "จาน"));
    // salesumary.bestseller.add(ProductModel(
    //     imgUri: "https://dedeposblosstorage.blob.core.windows.net/dedeposdevcontainer/2QoilMQkX9i6vtAE88ilEubnrhz/2QrRfDwdjjUBmmfCYtshN7J6cK1.png",
    //     barcode: "A00004",
    //     name: "ไก่บ้านย่าง",
    //     qty: 11,
    //     unit: "ตัว"));
    // salesumary.bestseller.add(ProductModel(
    //     imgUri: "https://dedeposblosstorage.blob.core.windows.net/dedeposdevcontainer/2QoilMQkX9i6vtAE88ilEubnrhz/2Qude2dvSMo75l9jl08VIOEuxTJ.png",
    //     barcode: "A00005",
    //     name: "ส้มตำลาว",
    //     qty: 10,
    //     unit: "ตัว"));
    // salesumary.bestseller.add(ProductModel(
    //     imgUri: "https://dedeposblosstorage.blob.core.windows.net/dedeposdevcontainer/2QoilMQkX9i6vtAE88ilEubnrhz/2Qudmru0uANlmlPABwi84n7BSPu.png",
    //     barcode: "A00006",
    //     name: "ตำหมูยอ",
    //     qty: 8,
    //     unit: "ตัว"));

    // salesumary.bestsellershop.add(ProductModel(
    //     imgUri: "https://dedeposblosstorage.blob.core.windows.net/dedeposdevcontainer/2QoilMQkX9i6vtAE88ilEubnrhz/2QrRfDwdjjUBmmfCYtshN7J6cK1.png",
    //     barcode: "A00002",
    //     name: "ปลาทอดน้ำปลา",
    //     qty: 13,
    //     unit: "จาน"));
    // salesumary.bestsellershop.add(ProductModel(
    //     imgUri: "https://dedeposblosstorage.blob.core.windows.net/dedeposdevcontainer/2QoilMQkX9i6vtAE88ilEubnrhz/2Qude2dvSMo75l9jl08VIOEuxTJ.png",
    //     barcode: "A00004",
    //     name: "ไก่บ้านย่าง",
    //     qty: 11,
    //     unit: "ตัว"));
    // salesumary.bestsellershop.add(ProductModel(
    //     imgUri: "https://dedeposblosstorage.blob.core.windows.net/dedeposdevcontainer/2QoilMQkX9i6vtAE88ilEubnrhz/2Qudmru0uANlmlPABwi84n7BSPu.png",
    //     barcode: "A00006",
    //     name: "ตำหมูยอ",
    //     qty: 8,
    //     unit: "ตัว"));

    // salesumary.bestsellerdelivery.add(ProductModel(
    //     imgUri: "https://dedeposblosstorage.blob.core.windows.net/dedeposdevcontainer/2QoilMQkX9i6vtAE88ilEubnrhz/2QrRYK6znPoFNyFbmaengspfZch.png",
    //     barcode: "A00001",
    //     name: "ไก่ทอดน้ำปลา",
    //     qty: 15,
    //     unit: "จาน"));
    // salesumary.bestsellerdelivery.add(ProductModel(
    //     imgUri: "https://dedeposblosstorage.blob.core.windows.net/dedeposdevcontainer/2QoilMQkX9i6vtAE88ilEubnrhz/2QrRbJsMd1e3Tjy7QRjGOcffheT.png",
    //     barcode: "A00003",
    //     name: "ปลาทอดสมุนไพร",
    //     qty: 12,
    //     unit: "จาน"));
    // salesumary.bestsellerdelivery.add(ProductModel(
    //     imgUri: "https://dedeposblosstorage.blob.core.windows.net/dedeposdevcontainer/2QoilMQkX9i6vtAE88ilEubnrhz/2QrRddGUcSt8aYujZlWfNKHlWpA.png",
    //     barcode: "A00005",
    //     name: "ส้มตำลาว",
    //     qty: 10,
    //     unit: "ตัว"));

    // calAmount();
    // chartPOSData.addAll([
    //   ChartData('เงินสด', salesumary.cash, Colors.orangeAccent),
    //   ChartData('สั่งกลับบ้าน', salesumary.takeAway, Colors.blue),
    //   ChartData('QRCode', salesumary.qrcodeAmount, Colors.green),
    //   ChartData('Wallet', salesumary.walletAmount, Colors.red),
    // ]);
    // for (var delivery in salesumary.delivery) {
    //   chartDeliveryData.add(ChartData(delivery.name, delivery.amount, getRandomColor()));
    // }

    getAllReport();
    reFreshTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      getAllReport();
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    reFreshTimer?.cancel();
    super.dispose();
  }

  void getAllReport() async {
    getReport();
    await Future.delayed(const Duration(seconds: 6));
    getReportSaleWeek();
    await Future.delayed(const Duration(seconds: 6));
    getGraphStore();
    await Future.delayed(const Duration(seconds: 6));
    getGraphDelivery();
    await Future.delayed(const Duration(seconds: 6));
    if (bestSellLoad) {
      getSellLoad();
    }
  }

  void getGraphDelivery() async {
    if (graphDeliverySelectedItem == 'รายวัน') {
      DateTime currentDate = DateTime.now();
      String queryFromdate = "&fromdate=${DateFormat('yyyy-MM-dd').format(currentDate)}";
      String queryTodate = "&todate=${DateFormat('yyyy-MM-dd').format(currentDate)}";
      getGraph(1, queryFromdate, queryTodate);
    } else if (graphDeliverySelectedItem == 'รายสัปดาห์') {
      DateTime currentDate = DateTime.now();
      DateTime firstDayOfWeek = currentDate.subtract(Duration(days: currentDate.weekday - 1));
      DateTime lastDayOfWeek = firstDayOfWeek.add(const Duration(days: 6));
      String queryFromdate = "&fromdate=${DateFormat('yyyy-MM-dd').format(firstDayOfWeek)}";
      String queryTodate = "&todate=${DateFormat('yyyy-MM-dd').format(lastDayOfWeek)}";
      getGraph(1, queryFromdate, queryTodate);
    } else if (graphDeliverySelectedItem == 'รายเดือน') {
      String queryFromdate = "";
      String queryTodate = "";
      DateTime currentDate = DateTime.now();
      DateTime firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
      DateTime lastDayOfMonth = DateTime(currentDate.year, currentDate.month + 1, 0);
      queryFromdate = "&fromdate=${DateFormat('yyyy-MM-dd').format(firstDayOfMonth)}";
      queryTodate = "&todate=${DateFormat('yyyy-MM-dd').format(lastDayOfMonth)}";
      getGraph(1, queryFromdate, queryTodate);
    } else if (graphDeliverySelectedItem == 'รายปี') {
      String queryFromdate = "";
      String queryTodate = "";
      DateTime currentDate = DateTime.now();
      DateTime firstDayOfYear = DateTime(currentDate.year, 1, 1);
      DateTime lastDayOfYear = DateTime(currentDate.year, 12, 31);
      queryFromdate = "&fromdate=${DateFormat('yyyy-MM-dd').format(firstDayOfYear)}";
      queryTodate = "&todate=${DateFormat('yyyy-MM-dd').format(lastDayOfYear)}";
      getGraph(1, queryFromdate, queryTodate);
    } else {
      String queryFromdate = "";
      String queryTodate = "";
      queryFromdate = "&fromdate=${DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(fromDateController.text))}";
      queryTodate = "&todate=${DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(toDateController.text))}";
      getGraph(1, queryFromdate, queryTodate);
    }
  }

  void getGraphStore() async {
    if (graphSelectedItem == 'รายวัน') {
      DateTime currentDate = DateTime.now();
      String queryFromdate = "&fromdate=${DateFormat('yyyy-MM-dd').format(currentDate)}";
      String queryTodate = "&todate=${DateFormat('yyyy-MM-dd').format(currentDate)}";
      getGraph(0, queryFromdate, queryTodate);
    } else if (graphSelectedItem == 'รายสัปดาห์') {
      DateTime currentDate = DateTime.now();
      DateTime firstDayOfWeek = currentDate.subtract(Duration(days: currentDate.weekday - 1));
      DateTime lastDayOfWeek = firstDayOfWeek.add(const Duration(days: 6));
      String queryFromdate = "&fromdate=${DateFormat('yyyy-MM-dd').format(firstDayOfWeek)}";
      String queryTodate = "&todate=${DateFormat('yyyy-MM-dd').format(lastDayOfWeek)}";

      getGraph(0, queryFromdate, queryTodate);
    } else if (graphSelectedItem == 'รายเดือน') {
      String queryFromdate = "";
      String queryTodate = "";
      DateTime currentDate = DateTime.now();
      DateTime firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
      DateTime lastDayOfMonth = DateTime(currentDate.year, currentDate.month + 1, 0);
      queryFromdate = "&fromdate=${DateFormat('yyyy-MM-dd').format(firstDayOfMonth)}";
      queryTodate = "&todate=${DateFormat('yyyy-MM-dd').format(lastDayOfMonth)}";

      getGraph(0, queryFromdate, queryTodate);
    } else if (graphSelectedItem == 'รายปี') {
      String queryFromdate = "";
      String queryTodate = "";
      DateTime currentDate = DateTime.now();
      DateTime firstDayOfYear = DateTime(currentDate.year, 1, 1);
      DateTime lastDayOfYear = DateTime(currentDate.year, 12, 31);
      queryFromdate = "&fromdate=${DateFormat('yyyy-MM-dd').format(firstDayOfYear)}";
      queryTodate = "&todate=${DateFormat('yyyy-MM-dd').format(lastDayOfYear)}";

      getGraph(0, queryFromdate, queryTodate);
    } else {
      String queryFromdate = "";
      String queryTodate = "";
      queryFromdate = "&fromdate=${DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(fromDateController.text))}";
      queryTodate = "&todate=${DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(toDateController.text))}";
      getGraph(0, queryFromdate, queryTodate);
    }
  }

  Future<void> getReport() async {
    String queryFromdate = "";
    String queryTodate = "";
    DateTime currentDate = DateTime.now();

    if (selectedItem == 'รายวัน') {
      fromDateController.text = DateFormat('dd/MM/yyyy').format(currentDate);
      toDateController.text = DateFormat('dd/MM/yyyy').format(currentDate);
      queryFromdate = "&fromdate=${DateFormat('yyyy-MM-dd').format(currentDate)}";
      queryTodate = "&todate=${DateFormat('yyyy-MM-dd').format(currentDate)}";
    } else if (selectedItem == 'รายสัปดาห์') {
      DateTime firstDayOfWeek = currentDate.subtract(Duration(days: currentDate.weekday - 1));
      DateTime lastDayOfWeek = firstDayOfWeek.add(const Duration(days: 6));

      fromDateController.text = DateFormat('dd/MM/yyyy').format(firstDayOfWeek);
      toDateController.text = DateFormat('dd/MM/yyyy').format(lastDayOfWeek);
      queryFromdate = "&fromdate=${DateFormat('yyyy-MM-dd').format(firstDayOfWeek)}";
      queryTodate = "&todate=${DateFormat('yyyy-MM-dd').format(lastDayOfWeek)}";
    } else if (selectedItem == 'รายเดือน') {
      DateTime firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
      DateTime lastDayOfMonth = DateTime(currentDate.year, currentDate.month + 1, 0);

      fromDateController.text = DateFormat('dd/MM/yyyy').format(firstDayOfMonth);
      toDateController.text = DateFormat('dd/MM/yyyy').format(lastDayOfMonth);
      queryFromdate = "&fromdate=${DateFormat('yyyy-MM-dd').format(firstDayOfMonth)}";
      queryTodate = "&todate=${DateFormat('yyyy-MM-dd').format(lastDayOfMonth)}";
    } else if (selectedItem == 'ยอดขาย3เดือน') {
      DateTime firstDayOfLastThreeMonths = DateTime(currentDate.year, currentDate.month - 2, 1);
      DateTime lastDayOfLastThreeMonths = DateTime(currentDate.year, currentDate.month + 1, 0);

      fromDateController.text = DateFormat('dd/MM/yyyy').format(firstDayOfLastThreeMonths);
      toDateController.text = DateFormat('dd/MM/yyyy').format(lastDayOfLastThreeMonths);
      queryFromdate = "&fromdate=${DateFormat('yyyy-MM-dd').format(firstDayOfLastThreeMonths)}";
      queryTodate = "&todate=${DateFormat('yyyy-MM-dd').format(lastDayOfLastThreeMonths)}";
    } else if (selectedItem == 'รายปี') {
      DateTime firstDayOfYear = DateTime(currentDate.year, 1, 1);
      DateTime lastDayOfYear = DateTime(currentDate.year, 12, 31);

      fromDateController.text = DateFormat('dd/MM/yyyy').format(firstDayOfYear);
      toDateController.text = DateFormat('dd/MM/yyyy').format(lastDayOfYear);
      queryFromdate = "&fromdate=${DateFormat('yyyy-MM-dd').format(firstDayOfYear)}";
      queryTodate = "&todate=${DateFormat('yyyy-MM-dd').format(lastDayOfYear)}";
    } else {
      queryFromdate = "&fromdate=${DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(fromDateController.text))}";
      queryTodate = "&todate=${DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(toDateController.text))}";
    }

    ReportRepository reportRepository = ReportRepository();

    ApiResponse result = await reportRepository.getReportSaleSummary(queryFromdate, queryTodate);
    if (result.success) {
      salesumary = SalesumaryModel.fromJson(result.data);
      calAmount();
      setState(() {
        opacityText = 0.1;
      });

      setState(() {
        opacityText = 1;
      });
    }
  }

  Future<void> getReportSaleWeek() async {
    String queryFromdate = "";
    String queryTodate = "";

    DateTime firstDayOfWeek = selectedDateGraph.subtract(Duration(days: selectedDateGraph.weekday - 1));
    DateTime lastDayOfWeek = firstDayOfWeek.add(const Duration(days: 6));
    queryFromdate = "&fromdate=${DateFormat('yyyy-MM-dd').format(firstDayOfWeek)}";
    queryTodate = "&todate=${DateFormat('yyyy-MM-dd').format(lastDayOfWeek)}";
    ReportRepository reportRepository = ReportRepository();
    chartWeeklyData = [];
    chartWeeklyData.addAll([
      ChartData('Mon', 20000, Colors.yellow),
      ChartData('Tue', 30000, Colors.pink),
      ChartData('Wed', 5000, Colors.green),
      ChartData('Thu', 5454, Colors.orange),
      ChartData('Fri', 12000, Colors.blue),
      ChartData('Sat', 60000, Colors.purple),
      ChartData('Sun', 54200, Colors.red),
    ]);
    // ApiResponse result = await reportRepository.getReportSaleSummary(queryFromdate, queryTodate);
    // if (result.success) {
    //   saleByDay = SalesumaryByDayModel.fromJson(result.data);
    //   calAmount();
    //   setState(() {
    //     opacityText = 0.1;
    //   });

    //   setState(() {
    //     opacityText = 1;
    //   });
    // }
  }

  Future<void> getGraph(int mode, String queryFromdate, String queryTodate) async {
    ReportRepository reportRepository = ReportRepository();

    ApiResponse result = await reportRepository.getReportSaleSummary(queryFromdate, queryTodate);

    if (result.success) {
      SalesumaryModel resData = SalesumaryModel.fromJson(result.data);

      if (mode == 0) {
        chartPOSData = [];
        chartPOSData.addAll([
          ChartData('เงินสด', resData.cash, Colors.orangeAccent),
          ChartData('สั่งกลับบ้าน', 5000, Colors.blue),
          ChartData('QRCode', 1000, Colors.green),
          ChartData('Wallet', 12522, Colors.red),
        ]);
      } else {
        chartDeliveryData = [];
        chartDeliveryData.add(ChartData('Panda', 1500, getRandomColor()));
        chartDeliveryData.add(ChartData('Grab', 2000, getRandomColor()));
        chartDeliveryData.add(ChartData('Shopee', 3000, getRandomColor()));
        chartDeliveryData.add(ChartData('Line', 4000, getRandomColor()));
        // for (var delivery in resData.delivery) {
        //   chartDeliveryData.add(ChartData(delivery.name, delivery.amount, getRandomColor()));
        // }
      }
      saleSummaryLoad = true;

      setState(() {});
    }
  }

  Future<void> getSellLoad() async {
    String queryFromdate = "";
    String queryTodate = "";
    DateTime currentDate = DateTime.now();
    DateTime firstDayOfYear = DateTime(currentDate.year, 1, 1);
    DateTime lastDayOfYear = DateTime(currentDate.year, 12, 31);

    queryFromdate = "&fromdate=${DateFormat('yyyy-MM-dd').format(firstDayOfYear)}";
    queryTodate = "&todate=${DateFormat('yyyy-MM-dd').format(lastDayOfYear)}";

    ReportRepository reportRepository = ReportRepository();

    ApiResponse result = await reportRepository.getReportBestSellSummary(queryFromdate, queryTodate);

    if (result.success) {
      List<BestProductModel> products = (result.data as List).map((product) => BestProductModel.fromJson(product)).toList();
      bestSeller = [];
      bestSeller = products;
      bestSellLoad = true;
      setState(() {});
    }
  }

  void calAmount() {
    double calqrcodeAmount = 0;
    double calwalletAmount = 0;
    double caldeliveryAmount = 0;
    double calgpAmount = 0;
    for (var qrcode in salesumary.qrcode) {
      calqrcodeAmount += qrcode.amount;
    }
    for (var wallet in salesumary.wallet) {
      calwalletAmount += wallet.amount;
    }
    for (var delivery in salesumary.delivery) {
      caldeliveryAmount += delivery.amount;
      delivery.gpAmount = (delivery.amount * delivery.gpPercent) / 100;
      calgpAmount += delivery.gpAmount;
      chartDeliveryData.add(ChartData(delivery.name, delivery.amount, getRandomColor()));
    }

    salesumary.cashierAmount = salesumary.cash + salesumary.takeAway + calwalletAmount + calqrcodeAmount;
    salesumary.qrcodeAmount = calqrcodeAmount;
    salesumary.walletAmount = calwalletAmount;
    salesumary.deliveryAmount = caldeliveryAmount;
    salesumary.gpAmount = calgpAmount;
  }

  Color getRandomColor() {
    Random random = Random();
    int r = random.nextInt(256); // Generate a random value for the red channel (0-255)
    int g = random.nextInt(256); // Generate a random value for the green channel (0-255)
    int b = random.nextInt(256); // Generate a random value for the blue channel (0-255)
    return Color.fromRGBO(r, g, b, 1.0); // Create a Color object with the random RGB values
  }

  @override
  Widget build(BuildContext context) {
    buildReport();
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 232, 233, 237),
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Align(
            alignment: Alignment.center,
            child: Text(
              appConfig.read("name"),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          backgroundColor: Colors.indigo.shade700,
          leading: IconButton(
            icon: const Icon(Icons.swap_vert),
            onPressed: () {
              reFreshTimer?.cancel();
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
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int loop = 0; loop < widgetList.length; loop++)
                  VisibilityDetector(
                      onVisibilityChanged: (visibilityInfo) {
                        print(visibilityInfo);
                        if (visibilityInfo.visibleFraction == 1) {
                          print("$loop : Visible");

                          if (loadSuccess[loop] == false) {
                            if (widgetList[loop].key != null) {
                              print("get key : $loop");
                              if (loop == 11) {
                                getSellLoad();
                              }
                              // if (loop == 20) {
                              //   //รายสัปดาห์นี้
                              //   getGraphWeekly();
                              // }
                              // if (loop == 29) {
                              //   //รายเดือน
                              //   getGraphMonthly();
                              // }
                              // if (loop == 38) {
                              //   //3รายเดือน
                              //   getGraphThreeMonthly();
                              // }
                              // if (loop == 47) {
                              //   //ปีนี้
                              //   getGraphYearly();
                              // }
                              // if (loop == 56) {
                              //   //ขายดี
                              // }
                            }

                            loadSuccess[loop] = true;
                          }
                        }
                      },
                      key: Key(loop.toString()),
                      child: widgetList[loop])
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _selectDocDate(String cmd, String selectedDate) async {
    DateTime dateTime = DateFormat('dd/MM/yyyy').parse(selectedDate);
    DateTime lateDate = DateTime.now();
    DateTime firstDate = DateTime(2000);
    if (cmd == 'fromdate') {
      lateDate = DateFormat('dd/MM/yyyy').parse(toDateController.text);
    } else {
      firstDate = DateFormat('dd/MM/yyyy').parse(fromDateController.text);
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: firstDate,
      lastDate: lateDate,
    );

    if (pickedDate != null) {
      setState(() {
        selectedItem = 'กำหนดเอง';
        graphSelectedItem = 'xx';
        graphDeliverySelectedItem = 'xx';
        DateTime? pickDateTimeFormat = DateTime.parse('${DateFormat('yyyy-MM-dd').format(pickedDate)} ${DateFormat('HH:mm:ss.sss').format(DateTime.now())}');
        if (cmd == 'fromdate') {
          fromDateController.text = DateFormat('dd/MM/yyyy').format(pickDateTimeFormat);
        } else {
          toDateController.text = DateFormat('dd/MM/yyyy').format(pickDateTimeFormat);
        }
      });

      getReport();
      getGraphStore();
      getGraphDelivery();
    }
  }

  List<Widget> buildReport() {
    widgetList = [];
    loadSuccess = [];
    widgetList.add(
      Center(
        child: Padding(
            padding: const EdgeInsets.all(2),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (int i = 0; i < dropdownSelect.length; i++)
                    Container(
                      margin: const EdgeInsets.all(2),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedItem = dropdownSelect[i];

                            if (selectedItem != 'Custom') {
                              graphSelectedItem = selectedItem;
                              graphDeliverySelectedItem = selectedItem;
                              getReport();
                              getGraphStore();
                              getGraphDelivery();
                            }
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>((selectedItem == dropdownSelect[i]) ? Colors.blue : Colors.white),
                          foregroundColor: MaterialStateProperty.all<Color>((selectedItem == dropdownSelect[i]) ? Colors.white : Colors.blue), // This changes the color of the text
                          side: MaterialStateProperty.all<BorderSide>(const BorderSide(color: Colors.blue, width: 2)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                        child: Text(dropdownSelect[i]),
                      ),
                    ),
                ],
              ),
            )),
      ),
    );

    widgetList.add(
      SizedBox(
        width: double.infinity,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              readOnly: true,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "จากวันที่",
                  suffixIcon: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        focusNode: FocusNode(skipTraversal: true),
                        icon: const Icon(Icons.calendar_month),
                        onPressed: () {
                          _selectDocDate("fromdate", fromDateController.text);
                        },
                      ),
                    ],
                  )),
              controller: fromDateController,
              onChanged: (value) {
                setState(() {
                  try {
                    List<String> valueSplit = value.replaceAll(".", "/").split("/");
                    if (valueSplit.length == 3) {
                      if (valueSplit[2].length == 2) {
                        valueSplit[2] = '25${valueSplit[2]}';
                      }
                      int year = int.tryParse(valueSplit[2]) ?? 0;
                      year = year - 543;
                      int month = int.tryParse(valueSplit[1]) ?? 0;
                      int day = int.tryParse(valueSplit[0]) ?? 0;
                      value = "$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";
                    }
                  } catch (e) {
                    print(e);
                  }
                });
              },
              onSubmitted: (value) {
                //  fromDateController.text = DateFormat('dd/MM/yyyy').format(DateTime.parse(screenData.docdatetime));
              },
            ),
          ),
        ),
      ),
    );
    widgetList.add(SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            readOnly: true,
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: "ถึงวันที่",
                suffixIcon: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      focusNode: FocusNode(skipTraversal: true),
                      icon: const Icon(Icons.calendar_month),
                      onPressed: () {
                        _selectDocDate("todate", toDateController.text);
                      },
                    ),
                  ],
                )),
            controller: toDateController,
            onChanged: (value) {
              setState(() {
                try {
                  List<String> valueSplit = value.replaceAll(".", "/").split("/");
                  if (valueSplit.length == 3) {
                    if (valueSplit[2].length == 2) {
                      valueSplit[2] = '25${valueSplit[2]}';
                    }
                    int year = int.tryParse(valueSplit[2]) ?? 0;
                    year = year - 543;
                    int month = int.tryParse(valueSplit[1]) ?? 0;
                    int day = int.tryParse(valueSplit[0]) ?? 0;
                    value = "$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";
                  }
                } catch (e) {
                  print(e);
                }
              });
            },
            onSubmitted: (value) {
              //  fromDateController.text = DateFormat('dd/MM/yyyy').format(DateTime.parse(screenData.docdatetime));
            },
          ),
        ),
      ),
    ));

    widgetList.add(const SizedBox(
      height: 5,
    ));

    widgetList.add(
      Center(
        child: Container(
          height: 220,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.indigo.shade800,
                spreadRadius: 0,
                blurRadius: 3,
                offset: const Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Opacity(
            opacity: opacityText,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  global.formatNumber(salesumary.cashierAmount + salesumary.deliveryAmount),
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.indigo.shade800),
                ),
                const SizedBox(
                  height: 4,
                ),
                const Text(
                  "รวมยอดขาย",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // widgetList.add(
    //   Container(
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(5),
    //         boxShadow: [
    //           BoxShadow(
    //             color: Colors.grey.withOpacity(0.8),
    //             spreadRadius: 0,
    //             blurRadius: 3,
    //             offset: const Offset(0, 1), // changes position of shadow
    //           ),
    //         ],
    //         color: Colors.purple.shade400,
    //       ),
    //       height: 100,
    //       padding: const EdgeInsets.all(12),
    //       child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           children: [
    //             const Expanded(
    //               child: Text(
    //                 "ยอดขายทั้งหมด",
    //                 maxLines: 1,
    //                 overflow: TextOverflow.ellipsis,
    //                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
    //               ),
    //             ),
    //             Opacity(
    //               opacity: opacityText,
    //               child: Text(
    //                 global.formatNumber(salesumary.cashierAmount + salesumary.deliveryAmount),
    //                 style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ])),
    // );

    widgetList.add(const SizedBox(
      height: 5,
    ));

    Widget posSales = Expanded(
      child: InkWell(
        onTap: () {
          if (isSaleShop) {
            isSaleShop = false;
          } else {
            isSaleShop = true;
          }

          setState(() {});
        },
        child: Container(
          margin: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.shade600,
                spreadRadius: 0,
                blurRadius: 3,
                offset: const Offset(0, 0),
              ),
            ],
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "ขายหน้าร้าน",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  global.formatNumber(salesumary.cashierAmount),
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.indigo.shade800),
                ),
                const SizedBox(
                  height: 2,
                ),
                const Text(
                  "กดเพื่อดูรายละเอียด",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Widget deliverySales = Expanded(
      child: InkWell(
        onTap: () {
          if (isDeliveryShop) {
            isDeliveryShop = false;
          } else {
            isDeliveryShop = true;
          }

          setState(() {});
        },
        child: Container(
          margin: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.shade600,
                spreadRadius: 0,
                blurRadius: 3,
                offset: const Offset(0, 0), // changes position of shadow
              ),
            ],
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "บริการจัดส่งอาหาร",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  global.formatNumber(salesumary.deliveryAmount),
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.indigo.shade800),
                ),
                const SizedBox(
                  height: 2,
                ),
                const Text(
                  "กดเพื่อดูรายละเอียด",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    widgetList.add(Row(
      children: [posSales, deliverySales],
    ));

    widgetList.add(const SizedBox(
      height: 4,
    ));

    widgetList.add(
      Visibility(
        visible: isSaleShop,
        child: Container(
          margin: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 10),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.shade600,
                spreadRadius: 0,
                blurRadius: 4,
                offset: const Offset(0, 0),
              ),
            ],
            color: Colors.white,
          ),
          child: Column(
            children: [
              const Text(
                "รายละเอียดยอดขายหน้าร้าน",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Divider(height: 5, color: Colors.orange.shade600),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "เงินสด",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  Opacity(
                    opacity: opacityText,
                    child: Text(
                      global.formatNumber(salesumary.cash),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "สั่งกลับบ้าน",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  Opacity(
                    opacity: opacityText,
                    child: Text(
                      global.formatNumber(salesumary.takeAway),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "QR code",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  Opacity(
                    opacity: opacityText,
                    child: Text(
                      global.formatNumber(salesumary.qrcodeAmount),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  )
                ],
              ),
              for (var data in salesumary.qrcode)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      " - ${data.name}",
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    Text(
                      global.formatNumber(data.amount),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                    )
                  ],
                ),
              const SizedBox(
                height: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Wallet",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  Opacity(
                    opacity: opacityText,
                    child: Text(
                      global.formatNumber(salesumary.walletAmount),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  )
                ],
              ),
              for (var data in salesumary.wallet)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      " - ${data.name}",
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    Text(
                      global.formatNumber(data.amount),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                    )
                  ],
                ),
            ],
          ),
        ),
      ),
    );

    widgetList.add(Visibility(
      visible: isDeliveryShop,
      child: Container(
        margin: const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade600,
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
          color: Colors.white,
        ),
        child: Column(
          children: [
            const Text(
              "รายละเอียดบริการจัดส่ง",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Divider(height: 5, color: Colors.blue.shade600),
            for (var data in salesumary.delivery)
              Container(
                margin: const EdgeInsets.only(top: 2),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          data.name,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Text(
                          global.formatNumber(data.amount),
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "GP ${data.gpPercent}%",
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Text(
                          global.formatNumber(data.gpAmount * -1),
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "รวม",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Text(
                          global.formatNumber((data.amount - data.gpAmount)),
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Divider(
                      height: 2,
                      color: Colors.blue.shade600,
                    ),
                    const SizedBox(
                      height: 5,
                    )
                  ],
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "รวม",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Text(
                  global.formatNumber(salesumary.deliveryAmount),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                )
              ],
            ),
            const SizedBox(
              height: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "หักGPรวม",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Text(
                  global.formatNumber(salesumary.gpAmount * -1),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                )
              ],
            ),
            const SizedBox(
              height: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "สุทธิประมาณ",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Text(
                  global.formatNumber(salesumary.deliveryAmount - salesumary.gpAmount),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 2,
            ),
            Divider(
              height: 5,
              color: Colors.blue.shade600,
            ),
          ],
        ),
      ),
    ));
    // widgetList.add(Container(
    //     key: keys[0],
    //     margin: const EdgeInsets.only(top: 10, bottom: 0),
    //     child: const Text(
    //       "กราฟเปรียบเทียบยอดชำระหน้าร้านรายวัน",
    //       style: TextStyle(fontSize: 16),
    //     )));
    // widgetList.add(const Divider(
    //   height: 3,
    //   thickness: 1,
    //   color: Colors.grey,
    // ));
    // widgetList.add(const SizedBox(
    //   height: 2,
    // ));

    var series = [
      charts.Series(
        domainFn: (ChartData data, _) => data.label,
        measureFn: (ChartData data, _) => data.value,
        colorFn: (ChartData data, _) => charts.ColorUtil.fromDartColor(data.color),
        labelAccessorFn: (ChartData data, _) => '${data.value}',
        id: 'chartWeeklyData',
        data: chartWeeklyData,
      ),
    ];
    var chart = charts.BarChart(
      series,
      animate: true,
      barRendererDecorator: charts.BarLabelDecorator<String>(outsideLabelStyleSpec: const charts.TextStyleSpec(fontSize: 9), labelPosition: charts.BarLabelPosition.outside),
      domainAxis: const charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelStyle: charts.TextStyleSpec(
            fontSize: 11,
          ),
        ),
      ),
    );

    DateTime firstDayOfWeekGraph = selectedDateGraph.subtract(Duration(days: selectedDateGraph.weekday - 1));
    DateTime lastDayOfWeekGraph = firstDayOfWeekGraph.add(const Duration(days: 6));
    var chartWidget = GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          setState(() {
            selectedDateGraph = selectedDateGraph.subtract(const Duration(days: 7));
            getReportSaleWeek();
          });
        } else if (details.primaryVelocity! < 0) {
          setState(() {
            selectedDateGraph = selectedDateGraph.add(const Duration(days: 7));
            getReportSaleWeek();
          });
        }
      },
      child: Card(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
                margin: const EdgeInsets.only(top: 10, bottom: 0),
                child: const Text(
                  "กราฟแสดงยอดขายตามวัน",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: _selectPreviousWeek,
                  ),
                  Expanded(child: Center(child: Text('${DateFormat('dd/MM/yyyy').format(firstDayOfWeekGraph)} ถึง ${DateFormat('dd/MM/yyyy').format(lastDayOfWeekGraph)}'))),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: _selectNextWeek,
                  ),
                ],
              ),
            ),
            SizedBox(height: 450, child: chart),
          ],
        ),
      )),
    );
    widgetList.add(chartWidget);

    // Widget graphSelectWidget = Padding(
    //   padding: const EdgeInsets.all(2),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       for (int i = 0; i < graphSelect.length; i++)
    //         Container(
    //           margin: const EdgeInsets.all(2),
    //           child: ElevatedButton(
    //             onPressed: () {
    //               setState(() {
    //                 graphSelectedItem = graphSelect[i];
    //               });
    //               getGraphStore();
    //             },
    //             style: ButtonStyle(
    //               backgroundColor: MaterialStateProperty.all<Color>((graphSelectedItem == graphSelect[i]) ? Colors.blue : Colors.white),
    //               foregroundColor: MaterialStateProperty.all<Color>((graphSelectedItem == graphSelect[i]) ? Colors.white : Colors.blue), // This changes the color of the text
    //               side: MaterialStateProperty.all<BorderSide>(const BorderSide(color: Colors.blue, width: 2)),
    //               shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    //                 RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.circular(25),
    //                 ),
    //               ),
    //             ),
    //             child: Text(graphSelect[i]),
    //           ),
    //         ),
    //     ],
    //   ),
    // );

    // Widget graphSelectDeliveryWidget = Padding(
    //   padding: const EdgeInsets.all(2),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       for (int i = 0; i < graphDeliverySelect.length; i++)
    //         Container(
    //           margin: const EdgeInsets.all(2),
    //           child: ElevatedButton(
    //             onPressed: () {
    //               setState(() {
    //                 graphDeliverySelectedItem = graphDeliverySelect[i];
    //               });
    //               getGraphDelivery();
    //             },
    //             style: ButtonStyle(
    //               backgroundColor: MaterialStateProperty.all<Color>((graphDeliverySelectedItem == graphDeliverySelect[i]) ? Colors.blue : Colors.white),
    //               foregroundColor:
    //                   MaterialStateProperty.all<Color>((graphDeliverySelectedItem == graphDeliverySelect[i]) ? Colors.white : Colors.blue), // This changes the color of the text
    //               side: MaterialStateProperty.all<BorderSide>(const BorderSide(color: Colors.blue, width: 2)),
    //               shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    //                 RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.circular(25),
    //                 ),
    //               ),
    //             ),
    //             child: Text(graphDeliverySelect[i]),
    //           ),
    //         ),
    //     ],
    //   ),
    // );

    Map<String, double> dataMap = {"Empty": 0};
    Map<String, String> legendLabels = {"Empty": "Empty"};
    if (chartPOSData.isNotEmpty) {
      dataMap = {};
      legendLabels = {};
      for (var data in chartPOSData) {
        dataMap[data.label] = data.value;
        legendLabels[data.label] = data.label;
      }
    }

    final pieChartGen = PieChart(
      key: const ValueKey(1),
      dataMap: dataMap,
      animationDuration: const Duration(milliseconds: 800),
      chartLegendSpacing: 32,
      chartRadius: 300,
      colorList: colorList,
      initialAngleInDegree: 0,
      chartType: ChartType.disc,
      centerText: null,
      legendLabels: legendLabels,
      legendOptions: const LegendOptions(
        showLegendsInRow: true,
        legendPosition: LegendPosition.bottom,
        showLegends: true,
        legendShape: BoxShape.circle,
        legendTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      chartValuesOptions: const ChartValuesOptions(
        showChartValueBackground: true,
        showChartValues: true,
        showChartValuesInPercentage: true,
        showChartValuesOutside: false,
      ),
      ringStrokeWidth: 32,
      emptyColor: Colors.grey,
      gradientList: gradientList,
      emptyColorGradient: const [
        Color(0xff6c5ce7),
        Colors.blue,
      ],
      baseChartColor: Colors.transparent,
    );

    Map<String, double> dataMapDelivery = {"Empty": 0};
    Map<String, String> legendLabelsDelivery = {"Empty": "Empty"};
    if (chartDeliveryData.isNotEmpty) {
      dataMapDelivery = {};
      legendLabelsDelivery = {};
      for (var data in chartDeliveryData) {
        dataMapDelivery[data.label] = data.value;
        legendLabelsDelivery[data.label] = data.label;
      }
    }

    final pieChartDeliveryGen = PieChart(
      key: const ValueKey(2),
      dataMap: dataMapDelivery,
      animationDuration: const Duration(milliseconds: 800),
      chartLegendSpacing: 32,
      chartRadius: 300,
      colorList: colorList,
      initialAngleInDegree: 0,
      chartType: ChartType.disc,
      centerText: null,
      legendLabels: legendLabelsDelivery,
      legendOptions: const LegendOptions(
        showLegendsInRow: true,
        legendPosition: LegendPosition.bottom,
        showLegends: true,
        legendShape: BoxShape.circle,
        legendTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      chartValuesOptions: const ChartValuesOptions(
        showChartValueBackground: true,
        showChartValues: true,
        showChartValuesInPercentage: true,
        showChartValuesOutside: false,
      ),
      ringStrokeWidth: 32,
      emptyColor: Colors.grey,
      gradientList: gradientList,
      emptyColorGradient: const [
        Color(0xff6c5ce7),
        Colors.blue,
      ],
      baseChartColor: Colors.transparent,
    );

    widgetList.add(Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          const Text(
            "เปรียบเทียบการรับเงินหน้าร้าน",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          // graphSelectWidget,
          (dailyLoad) ? pieChartGen : const SizedBox(height: 300, child: Center(child: CircularProgressIndicator())),
        ]),
      ),
    ));

    widgetList.add(Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          const Text(
            "เปรียบเทียบยอดขายบริการจัดส่งอาหาร",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          // graphSelectDeliveryWidget,
          (dailyLoad) ? pieChartDeliveryGen : const SizedBox(height: 300, child: Center(child: CircularProgressIndicator())),
        ]),
      ),
    ));

    if (dailyLoad) {
      //  widgetList.add(chartWidget);
    } else {
      widgetList.add(const SizedBox(height: 300, child: Center(child: CircularProgressIndicator())));
    }

    widgetList.add(const SizedBox(
      height: 2,
    ));
    List<Widget> bestSellingList = [];
    if (bestSellLoad) {
      for (int i = 0; i < bestSeller.length; i++) {
        var bestseller = bestSeller[i];
        bestSellingList.add(
          Container(
            margin: const EdgeInsets.only(left: 0, right: 5, bottom: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 20, child: Text("${i + 1}.")),
                SizedBox(
                  width: 60,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      image: (bestseller.qty == 0)
                          ? DecorationImage(image: NetworkImage(bestseller.shopid), fit: BoxFit.fill)
                          : const DecorationImage(image: AssetImage('assets/img/noimg.png'), fit: BoxFit.fill),
                    ),
                    child: const SizedBox(
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                    child: Text(
                  global.activeLangName(bestseller.names),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )),
                Expanded(
                    child: Text(
                  "${global.formatNumber(bestseller.qty)} ${(bestseller.unitcode != '' ? bestseller.unitcode : 'ชิ้น')}",
                  textAlign: TextAlign.right,
                ))
              ],
            ),
          ),
        );
      }
    }

    widgetList.add(Container(
      key: keys[11],
      margin: const EdgeInsets.only(top: 10, bottom: 4, right: 8, left: 8),
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.orangeAccent.shade700,
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 0), // changes position of shadow
          ),
        ],
        color: Colors.white,
      ),
      child: Column(children: [
        const Text(
          "10 อันดับสินค้าขายดี",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const Divider(
          height: 3,
          thickness: 1,
          color: Colors.grey,
        ),
        const SizedBox(
          height: 10,
        ),
        if (bestSellingList.isNotEmpty)
          for (int i = 0; i < bestSellingList.length; i++) bestSellingList[i],
        if (bestSellingList.isEmpty) const SizedBox(height: 300, child: Center(child: CircularProgressIndicator())),
      ]),
    ));

    widgetList.add(Container(
      margin: const EdgeInsets.only(top: 10, bottom: 4, right: 8, left: 8),
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.shade600,
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 0), // changes position of shadow
          ),
        ],
        color: Colors.white,
      ),
      child: Column(children: [
        const Text(
          "10 อันดับสินค้าขายดีหน้าร้าน",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const Divider(
          height: 3,
          thickness: 1,
          color: Colors.grey,
        ),
        const SizedBox(
          height: 10,
        ),
        if (bestSellingList.isNotEmpty)
          for (int i = 0; i < bestSellingList.length; i++) bestSellingList[i],
        if (bestSellingList.isEmpty) const SizedBox(height: 300, child: Center(child: CircularProgressIndicator())),
      ]),
    ));
    widgetList.add(Container(
      margin: const EdgeInsets.only(top: 10, bottom: 4, right: 8, left: 8),
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.shade600,
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 0), // changes position of shadow
          ),
        ],
        color: Colors.white,
      ),
      child: Column(children: [
        const Text(
          "10 อันดับสินค้าขายดีบริการจัดส่ง",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const Divider(
          height: 3,
          thickness: 1,
          color: Colors.grey,
        ),
        const SizedBox(
          height: 10,
        ),
        if (bestSellingList.isNotEmpty)
          for (int i = 0; i < bestSellingList.length; i++) bestSellingList[i],
        if (bestSellingList.isEmpty) const SizedBox(height: 300, child: Center(child: CircularProgressIndicator())),
      ]),
    ));

    for (var data in widgetList) {
      loadSuccess.add(false);
    }

    return widgetList;
  }
}
