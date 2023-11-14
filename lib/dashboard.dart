// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:math';

import 'package:dedeowner/model/best_product_model.dart';
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
    getReportSaleWeek();
  }

  void _selectNextWeek() {
    setState(() {
      selectedDateGraph = selectedDateGraph.add(const Duration(days: 7));
    });
    getReportSaleWeek();
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
  bool isLoading = false;
  bool productSaleLoad = true;
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
  bool _isLoading = false;
  List<ProductSaleModel> productSaleToday = [];
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

    getAllReport();
    reFreshTimer = Timer.periodic(const Duration(seconds: 60), (timer) async {
      getAllReport();
    });

    super.initState();
  }

  @override
  void dispose() {
    reFreshTimer?.cancel();
    super.dispose();
  }

  void getAllReport() async {
    getReport();
    await Future.delayed(const Duration(seconds: 3));
    getReportProductSale();
    await Future.delayed(const Duration(seconds: 3));
    getReportSaleWeek();
    await Future.delayed(const Duration(seconds: 4));
    getGraphStore();
    await Future.delayed(const Duration(seconds: 4));
    getGraphDelivery();
    await Future.delayed(const Duration(seconds: 4));
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
    setState(() {
      isLoading = true;
    });

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

    salesumary = SalesumaryModel(
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
    ReportRepository reportRepository = ReportRepository();

    ApiResponse result = await reportRepository.getReportSaleSummary(queryFromdate, queryTodate);
    if (result.success) {
      setState(() {
        isLoading = false;
      });
      salesumary = SalesumaryModel.fromJson(result.data);
      calAmount();
      setState(() {
        opacityText = 0.1;
      });

      setState(() {
        opacityText = 1;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getReportProductSale() async {
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

    setState(() {
      productSaleLoad = true;
    });
    productSaleToday = [];
    ApiResponse result = await reportRepository.getProductSales(queryFromdate, queryTodate);
    if (result.success) {
      List<ProductSaleModel> products = (result.data as List).map((product) => ProductSaleModel.fromJson(product)).toList();

      productSaleToday = products;

      setState(() {
        productSaleLoad = false;
      });
    } else {
      setState(() {
        productSaleLoad = false;
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
    setState(() {
      _isLoading = true;
    });
    print("$queryFromdate : $queryTodate");
    ReportRepository reportRepository = ReportRepository();
    chartWeeklyData = [];
    chartWeeklyData.addAll([
      ChartData('Mon', 0, Colors.yellow),
      ChartData('Tue', 0, Colors.pink),
      ChartData('Wed', 0, Colors.green),
      ChartData('Thu', 0, Colors.orange),
      ChartData('Fri', 0, Colors.blue),
      ChartData('Sat', 0, Colors.purple),
      ChartData('Sun', 0, Colors.red),
    ]);
    ApiResponse result = await reportRepository.getReportSaleWeeklySummary(queryFromdate, queryTodate);
    if (result.success) {
      chartWeeklyData = [];
      chartWeeklyData.addAll([
        ChartData('Mon', double.parse(result.data['Mon'].toString()), Colors.yellow),
        ChartData('Tue', double.parse(result.data['Tue'].toString()), Colors.pink),
        ChartData('Wed', double.parse(result.data['Wed'].toString()), Colors.green),
        ChartData('Thu', double.parse(result.data['Thu'].toString()), Colors.orange),
        ChartData('Fri', double.parse(result.data['Fri'].toString()), Colors.blue),
        ChartData('Sat', double.parse(result.data['Sat'].toString()), Colors.purple),
        ChartData('Sun', double.parse(result.data['Sun'].toString()), Colors.red),
      ]);
      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
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
      getReportProductSale();
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
                      padding: const EdgeInsets.all(1),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedItem = dropdownSelect[i];

                            if (selectedItem != 'Custom') {
                              graphSelectedItem = selectedItem;
                              graphDeliverySelectedItem = selectedItem;
                              getReport();
                              getReportProductSale();
                              getGraphStore();
                              getGraphDelivery();
                            }
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>((selectedItem == dropdownSelect[i]) ? Colors.white : Colors.white),
                          foregroundColor: MaterialStateProperty.all<Color>((selectedItem == dropdownSelect[i]) ? Colors.orange.shade900 : Colors.grey.shade700),
                          side: MaterialStateProperty.all<BorderSide>(BorderSide(color: (selectedItem == dropdownSelect[i]) ? Colors.orange.shade700 : Colors.white, width: 2)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
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
      Container(
        height: 75,
        padding: const EdgeInsets.only(top: 10, left: 10, bottom: 5, right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: TextField(
          readOnly: true,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              border: const OutlineInputBorder(),
              labelText: "จากวันที่",
              suffixIcon: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    color: Colors.orange.shade700,
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
    );
    widgetList.add(Container(
      height: 75,
      padding: const EdgeInsets.only(top: 3, left: 10, bottom: 0, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: TextField(
        readOnly: true,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            border: const OutlineInputBorder(),
            labelText: "ถึงวันที่",
            suffixIcon: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  color: Colors.orange.shade700,
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
    ));

    widgetList.add(const SizedBox(height: 10));

    widgetList.add(
      Center(
        child: Container(
          height: 220,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.orange.shade700,
                spreadRadius: 0,
                blurRadius: 3,
                offset: const Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
          alignment: Alignment.center,
          child: InkWell(
            onTap: () {
              getReport();
            },
            child: Opacity(
              opacity: opacityText,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  (isLoading)
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Text(
                          global.formatNumber(salesumary.cashierAmount + salesumary.deliveryAmount),
                          style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: Colors.indigo.shade800),
                        ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    "รวมยอดขาย",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                  ),
                ],
              ),
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
          showShopDetailDialog();
          setState(() {});
        },
        child: Container(
          margin: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.shade700,
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
                Text(
                  "ขายหน้าร้าน",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                ),
                const SizedBox(
                  height: 2,
                ),
                (isLoading)
                    ? const CircularProgressIndicator()
                    : Text(
                        global.formatNumber(salesumary.cashierAmount),
                        style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: Colors.indigo.shade800),
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
          showSalechanelDialog();
          setState(() {});
        },
        child: Container(
          margin: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.shade700,
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
                Text(
                  "บริการจัดส่งอาหาร",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                ),
                const SizedBox(
                  height: 2,
                ),
                (isLoading)
                    ? const CircularProgressIndicator()
                    : Text(
                        global.formatNumber(salesumary.deliveryAmount),
                        style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: Colors.indigo.shade800),
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
    Map<String, double> summary = {};
    for (var sale in productSaleToday) {
      summary[sale.owner] = (summary[sale.owner] ?? 0) + sale.sumamount;
    }

    List<Widget> summaryList = [];
    if (productSaleToday.isNotEmpty) {
      summaryList = summary.entries.map((entry) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  (entry.key.isEmpty) ? appConfig.read("name") : entry.key,
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo.shade800),
                ),
                Text(
                  global.formatNumber(entry.value),
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo.shade800),
                ),
              ],
            ),
            Divider(color: Colors.orange.shade300)
          ],
        );
      }).toList();
    }

    widgetList.add(
      Container(
        width: double.infinity,
        margin: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.shade700,
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
              Center(
                child: Text(
                  "ยอดขายแยกตามผู้ผลิต",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              (productSaleLoad)
                  ? const Center(child: CircularProgressIndicator())
                  : summaryList.isNotEmpty
                      ? Column(
                          children: summaryList,
                        )
                      : const Center(
                          child: Text(""),
                        ),
            ],
          ),
        ),
      ),
    );

    // widgetList.add(
    //   Column(
    //     children: [
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           const Text(
    //             "เงินสด",
    //             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
    //           ),
    //           Opacity(
    //             opacity: opacityText,
    //             child: Text(
    //               global.formatNumber(salesumary.cash),
    //               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
    //             ),
    //           )
    //         ],
    //       ),
    //       Divider(height: 5, color: Colors.orange.shade600),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           const Text(
    //             "สั่งกลับบ้าน",
    //             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
    //           ),
    //           Opacity(
    //             opacity: opacityText,
    //             child: Text(
    //               global.formatNumber(salesumary.takeAway),
    //               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
    //             ),
    //           )
    //         ],
    //       ),
    //       Divider(height: 5, color: Colors.orange.shade600),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           const Text(
    //             "QR code",
    //             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
    //           ),
    //           Opacity(
    //             opacity: opacityText,
    //             child: Text(
    //               global.formatNumber(salesumary.qrcodeAmount),
    //               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
    //             ),
    //           )
    //         ],
    //       ),
    //       for (var data in salesumary.qrcode)
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           children: [
    //             Text(
    //               " - ${data.name}",
    //               style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
    //             ),
    //             Text(
    //               global.formatNumber(data.amount),
    //               style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
    //             )
    //           ],
    //         ),
    //       Divider(height: 5, color: Colors.orange.shade600),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           const Text(
    //             "Wallet",
    //             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
    //           ),
    //           Opacity(
    //             opacity: opacityText,
    //             child: Text(
    //               global.formatNumber(salesumary.walletAmount),
    //               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
    //             ),
    //           )
    //         ],
    //       ),
    //       for (var data in salesumary.wallet)
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           children: [
    //             Text(
    //               " - ${data.name}",
    //               style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
    //             ),
    //             Text(
    //               global.formatNumber(data.amount),
    //               style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
    //             )
    //           ],
    //         ),
    //     ],
    //   ),
    // );

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
            fontSize: 12,
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
      child: Container(
        margin: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.shade700,
              spreadRadius: 0,
              blurRadius: 3,
              offset: const Offset(0, 0),
            ),
          ],
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Container(
                margin: const EdgeInsets.only(top: 10, bottom: 0),
                child: Text(
                  "กราฟแสดงยอดขายตามวัน",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
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
            SizedBox(
                height: 450,
                child: Stack(children: [
                  Opacity(opacity: _isLoading ? 0 : 1, child: chart),
                  if (_isLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                ])),
          ],
        ),
      ),
    );

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

    // widgetList.add(Card(
    //   child: Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: Column(children: [
    //       const Text(
    //         "เปรียบเทียบการรับเงินหน้าร้าน",
    //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
    //       ),
    //       // graphSelectWidget,
    //       (dailyLoad) ? pieChartGen : const SizedBox(height: 300, child: Center(child: CircularProgressIndicator())),
    //     ]),
    //   ),
    // ));

    // widgetList.add(Card(
    //   child: Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: Column(children: [
    //       const Text(
    //         "เปรียบเทียบยอดขายบริการจัดส่งอาหาร",
    //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
    //       ),
    //       // graphSelectDeliveryWidget,
    //       (dailyLoad) ? pieChartDeliveryGen : const SizedBox(height: 300, child: Center(child: CircularProgressIndicator())),
    //     ]),
    //   ),
    // ));

    if (dailyLoad) {
      //  widgetList.add(chartWidget);
    } else {
      widgetList.add(const SizedBox(height: 300, child: Center(child: CircularProgressIndicator())));
    }

    widgetList.add(const SizedBox(
      height: 2,
    ));
    List<Widget> bestSellingList = [];
    bestSellingList.add(
      Container(
        margin: const EdgeInsets.only(left: 0, right: 5, bottom: 3),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 20, child: Text("#")),
            SizedBox(
              width: 60,
              child: SizedBox(
                width: 50,
                height: 50,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
                child: Text(
              "ชื่อ",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )),
            Expanded(
                child: Text(
              "จำนวน",
              textAlign: TextAlign.right,
            )),
            Expanded(
                child: Text(
              "มูลค่า",
              textAlign: TextAlign.right,
            ))
          ],
        ),
      ),
    );
    if (bestSellLoad) {
      for (int i = 0; i < bestSeller.length; i++) {
        var bestseller = bestSeller[i];
        bestSellingList.addAll([
          Container(
            margin: const EdgeInsets.only(left: 0, right: 5, bottom: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 20, child: Text("${i + 1}.")),
                // SizedBox(
                //   width: 60,
                //   child: DecoratedBox(
                //     decoration: BoxDecoration(
                //       image: (bestseller.qty == 0)
                //           ? DecorationImage(image: NetworkImage(bestseller.shopid), fit: BoxFit.fill)
                //           : const DecorationImage(image: AssetImage('assets/img/noimg.png'), fit: BoxFit.fill),
                //     ),
                //     child: const SizedBox(
                //       width: 50,
                //       height: 50,
                //     ),
                //   ),
                // ),

                Expanded(
                    child: Text(
                  "${global.activeLangName(bestseller.names)}@${bestseller.price}",
                )),
                Expanded(
                    child: Text(
                  global.formatNumber(bestseller.qty),
                  textAlign: TextAlign.right,
                )),
                Expanded(
                    child: Text(
                  global.formatNumber(bestseller.sumamount),
                  textAlign: TextAlign.right,
                ))
              ],
            ),
          ),
          const Divider()
        ]);
      }
    }
    List<Widget> productSaleTodayList = [];
    productSaleTodayList.add(
      Container(
        margin: const EdgeInsets.only(left: 0, right: 5, bottom: 3),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 20, child: Text("#")),
            SizedBox(
              width: 60,
              child: SizedBox(
                width: 50,
                height: 50,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
                child: Text(
              "ชื่อ",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )),
            Expanded(
                child: Text(
              "จำนวน",
              textAlign: TextAlign.right,
            )),
            Expanded(
                child: Text(
              "มูลค่า",
              textAlign: TextAlign.right,
            ))
          ],
        ),
      ),
    );
    for (int i = 0; i < productSaleToday.length; i++) {
      var productSale = productSaleToday[i];

      productSaleTodayList.addAll([
        Container(
          margin: const EdgeInsets.only(left: 0, right: 5, bottom: 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 35, child: Text("${i + 1}.")),
              // SizedBox(
              //   width: 60,
              //   child: DecoratedBox(
              //     decoration: BoxDecoration(
              //       image: (productSale.qty == 0)
              //           ? const DecorationImage(image: AssetImage('assets/img/noimg.png'), fit: BoxFit.fill)
              //           : const DecorationImage(image: AssetImage('assets/img/noimg.png'), fit: BoxFit.fill),
              //     ),
              //     child: const SizedBox(
              //       width: 50,
              //       height: 50,
              //     ),
              //   ),
              // ),

              Expanded(
                  flex: 2,
                  child: Text(
                    "${global.activeLangName(productSale.names)}@${productSale.price}",
                  )),
              Expanded(
                  flex: 1,
                  child: Text(
                    "${global.formatNumber(productSale.qty)} ",
                    textAlign: TextAlign.right,
                  )),
              Expanded(
                  flex: 1,
                  child: Text(
                    global.formatNumber(productSale.sumamount),
                    textAlign: TextAlign.right,
                  ))
            ],
          ),
        ),
        const Divider()
      ]);
    }

    widgetList.add(Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 0, bottom: 5, right: 8, left: 8),
        child: ElevatedButton.icon(
          style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.orange.shade700)),
          onPressed: () {
            if (isSaleShop) {
              isSaleShop = false;
            } else {
              isSaleShop = true;
            }
            setState(() {});
          },
          icon: Icon((!isSaleShop) ? Icons.add : Icons.remove),
          label: Text((!isSaleShop) ? "แสดงรายละเอียดการรับเงิน" : "ซ่อนรายละเอียดการรับเงิน"),
        )));

    widgetList.add(
      Visibility(
        visible: isSaleShop,
        child: Container(
          margin: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 5),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.shade700,
                spreadRadius: 0,
                blurRadius: 4,
                offset: const Offset(0, 0),
              ),
            ],
            color: Colors.white,
          ),
          child: Column(
            children: [
              Text(
                "รายละเอียดยอดขายหน้าร้าน",
                style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Divider(height: 5, color: Colors.orange.shade600),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "เงินสด",
                    style: TextStyle(color: Colors.black),
                  ),
                  Opacity(
                    opacity: opacityText,
                    child: Text(
                      global.formatNumber(salesumary.cash),
                      style: const TextStyle(color: Colors.black),
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
                    style: TextStyle(color: Colors.black),
                  ),
                  Opacity(
                    opacity: opacityText,
                    child: Text(
                      global.formatNumber(salesumary.takeAway),
                      style: const TextStyle(color: Colors.black),
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
                    style: TextStyle(color: Colors.black),
                  ),
                  Opacity(
                    opacity: opacityText,
                    child: Text(
                      global.formatNumber(salesumary.qrcodeAmount),
                      style: const TextStyle(color: Colors.black),
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
                      style: const TextStyle(color: Colors.black),
                    ),
                    Text(
                      global.formatNumber(data.amount),
                      style: const TextStyle(color: Colors.black),
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
                    style: TextStyle(color: Colors.black),
                  ),
                  Opacity(
                    opacity: opacityText,
                    child: Text(
                      global.formatNumber(salesumary.walletAmount),
                      style: const TextStyle(color: Colors.black),
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
                      style: const TextStyle(color: Colors.black),
                    ),
                    Text(
                      global.formatNumber(data.amount),
                      style: const TextStyle(color: Colors.black),
                    )
                  ],
                ),
            ],
          ),
        ),
      ),
    );

    widgetList.add(Visibility(
      visible: isSaleShop,
      child: Container(
        margin: const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.shade700,
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
          color: Colors.white,
        ),
        child: Column(
          children: [
            Text(
              "รายละเอียดบริการจัดส่ง",
              style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Divider(height: 5, color: Colors.orange.shade700),
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
                          style: const TextStyle(color: Colors.black),
                        ),
                        Text(
                          global.formatNumber(data.amount),
                          style: const TextStyle(color: Colors.black),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "GP ${data.gpPercent}%",
                          style: const TextStyle(color: Colors.black),
                        ),
                        Text(
                          global.formatNumber(data.gpAmount * -1),
                          style: const TextStyle(color: Colors.black),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "รวม",
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          global.formatNumber((data.amount - data.gpAmount)),
                          style: const TextStyle(color: Colors.black),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Divider(
                      height: 2,
                      color: Colors.orange.shade700,
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
                  style: TextStyle(color: Colors.black),
                ),
                Text(
                  global.formatNumber(salesumary.deliveryAmount),
                  style: const TextStyle(color: Colors.black),
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
                  style: TextStyle(color: Colors.black),
                ),
                Text(
                  global.formatNumber(salesumary.gpAmount * -1),
                  style: const TextStyle(color: Colors.black),
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
                  style: TextStyle(color: Colors.black),
                ),
                Text(
                  global.formatNumber(salesumary.deliveryAmount - salesumary.gpAmount),
                  style: const TextStyle(
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
              color: Colors.orange.shade700,
            ),
          ],
        ),
      ),
    ));

    widgetList.add(Container(
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
        Text(
          "รายการขายสินค้า",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
        ),
        Divider(
          height: 3,
          thickness: 1,
          color: Colors.orange.shade100,
        ),
        const SizedBox(
          height: 10,
        ),
        if (productSaleTodayList.isNotEmpty)
          for (int i = 0; i < productSaleTodayList.length; i++) productSaleTodayList[i],
        if (productSaleLoad) const SizedBox(height: 300, child: Center(child: CircularProgressIndicator())),
      ]),
    ));

    widgetList.add(chartWidget);

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
        Text(
          "10 อันดับสินค้าขายดี",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
        ),
        Divider(
          height: 3,
          thickness: 1,
          color: Colors.orange.shade100,
        ),
        const SizedBox(
          height: 10,
        ),
        if (bestSellingList.isNotEmpty)
          for (int i = 0; i < bestSellingList.length; i++) bestSellingList[i],
        if (bestSellingList.isEmpty) const SizedBox(height: 300, child: Center(child: CircularProgressIndicator())),
      ]),
    ));

    // widgetList.add(Container(
    //   margin: const EdgeInsets.only(top: 10, bottom: 4, right: 8, left: 8),
    //   padding: const EdgeInsets.all(12),
    //   width: double.infinity,
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(5),
    //     boxShadow: [
    //       BoxShadow(
    //         color: Colors.orangeAccent.shade700,
    //         spreadRadius: 0,
    //         blurRadius: 4,
    //         offset: const Offset(0, 0), // changes position of shadow
    //       ),
    //     ],
    //     color: Colors.white,
    //   ),
    //   child: Column(children: [
    //     Text(
    //       "10 อันดับสินค้าขายดีหน้าร้าน",
    //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
    //     ),
    //     Divider(
    //       height: 3,
    //       thickness: 1,
    //       color: Colors.orange.shade100,
    //     ),
    //     const SizedBox(
    //       height: 10,
    //     ),
    //     if (bestSellingList.isNotEmpty)
    //       for (int i = 0; i < bestSellingList.length; i++) bestSellingList[i],
    //     if (bestSellingList.isEmpty) const SizedBox(height: 300, child: Center(child: CircularProgressIndicator())),
    //   ]),
    // ));
    // widgetList.add(Container(
    //   margin: const EdgeInsets.only(top: 10, bottom: 4, right: 8, left: 8),
    //   padding: const EdgeInsets.all(12),
    //   width: double.infinity,
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(5),
    //     boxShadow: [
    //       BoxShadow(
    //         color: Colors.orangeAccent.shade700,
    //         spreadRadius: 0,
    //         blurRadius: 4,
    //         offset: const Offset(0, 0), // changes position of shadow
    //       ),
    //     ],
    //     color: Colors.white,
    //   ),
    //   child: Column(children: [
    //     Text(
    //       "10 อันดับสินค้าขายดีบริการจัดส่ง",
    //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
    //     ),
    //     Divider(
    //       height: 3,
    //       thickness: 1,
    //       color: Colors.orange.shade100,
    //     ),
    //     const SizedBox(
    //       height: 10,
    //     ),
    //     if (bestSellingList.isNotEmpty)
    //       for (int i = 0; i < bestSellingList.length; i++) bestSellingList[i],
    //     if (bestSellingList.isEmpty) const SizedBox(height: 300, child: Center(child: CircularProgressIndicator())),
    //   ]),
    // ));

    for (var data in widgetList) {
      loadSuccess.add(false);
    }

    return widgetList;
  }

  void showShopDetailDialog() {
    final double _height = MediaQuery.of(context).size.height * 0.65;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('รายละเอียดยอดขายหน้าร้าน'),
          content: Container(
            constraints: BoxConstraints(maxHeight: _height),
            child: SingleChildScrollView(
              child: Column(
                children: [
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
                  Divider(height: 5, color: Colors.orange.shade600),
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
                  Divider(height: 5, color: Colors.orange.shade600),
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
                  Divider(height: 5, color: Colors.orange.shade600),
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
          actions: <Widget>[
            TextButton(
              child: const Text('ปิด'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showSalechanelDialog() {
    final double _height = MediaQuery.of(context).size.height * 0.65;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('รายละเอียดบริการจัดส่ง'),
          content: Container(
            constraints: BoxConstraints(maxHeight: _height),
            child: SingleChildScrollView(
              child: Column(
                children: [
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
                            color: Colors.orange.shade700,
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
                  Divider(height: 5, color: Colors.orange.shade700),
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
                  Divider(height: 5, color: Colors.orange.shade700),
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
                    color: Colors.orange.shade700,
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ปิด'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
