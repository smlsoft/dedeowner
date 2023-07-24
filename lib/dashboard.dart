// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:math';

import 'package:dedeowner/model/salesumary_model.dart';
import 'package:dedeowner/repositories/client.dart';
import 'package:dedeowner/repositories/report_repository.dart';
import 'package:dedeowner/select_shop_screen.dart';
import 'package:dedeowner/usersystem/login_shop.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:dedeowner/global.dart' as global;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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

  bool weeklyLoad = false;
  bool monthlyLoad = false;
  bool threeMonthlyLoad = false;
  bool yearlyLoad = false;

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
  List<String> dropdownSelect = ['ยอดขายวันนี้', 'ยอดขายสัปดาห์นี้', 'ยอดขายเดือนนี้', 'ยอดขาย3เดือน', 'ยอดขายปีนี้', 'กำหนดเอง'];
  String selectedItem = 'ยอดขายวันนี้';
  bool isSaleShop = false;
  bool isDeliveryShop = false;
  double opacityText = 1;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    getReport();
    // getGraphDaily();
    // getGraphWeekly();
    // getGraphMonthly();
    // getGraphThreeMonthly();
    // getGraphYearly();
  }

  @override
  void initState() {
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

    _scrollController.addListener(() {
      getScrollWidget();
    });

    fromDateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    toDateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());

    getReport();
    getGraphDaily();
    startTimer();

    super.initState();
  }

  void getScrollWidget() {
    final RenderBox renderBoxDaily = widgetKeyDaily.currentContext!.findRenderObject() as RenderBox;
    final positionDaily = renderBoxDaily.localToGlobal(Offset.zero);

    final RenderBox renderBoxDeliveryDaily = widgetKeyDeliveryDaily.currentContext!.findRenderObject() as RenderBox;
    final positionDeliveryDaily = renderBoxDeliveryDaily.localToGlobal(Offset.zero);

    final RenderBox renderBoxWeekly = widgetKeyWeekly.currentContext!.findRenderObject() as RenderBox;
    final positionWeekly = renderBoxWeekly.localToGlobal(Offset.zero);

    final RenderBox renderBoxDeliveryWeekly = widgetKeyDeliveryWeekly.currentContext!.findRenderObject() as RenderBox;
    final positionDeliveryWeekly = renderBoxDeliveryWeekly.localToGlobal(Offset.zero);

    final RenderBox renderBoxMonthly = widgetKeyMonthly.currentContext!.findRenderObject() as RenderBox;
    final positionMonthly = renderBoxMonthly.localToGlobal(Offset.zero);

    final RenderBox renderBoxDeliveryMonthly = widgetKeyDeliveryMonthly.currentContext!.findRenderObject() as RenderBox;
    final positionDeliveryMonthly = renderBoxDeliveryMonthly.localToGlobal(Offset.zero);

    final RenderBox renderBoxThreeMonthly = widgetKeyThreeMonthly.currentContext!.findRenderObject() as RenderBox;
    final positionThreeMonthly = renderBoxThreeMonthly.localToGlobal(Offset.zero);

    final RenderBox renderBoxDeliveryThreeMonthly = widgetKeyDeliveryThreeMonthly.currentContext!.findRenderObject() as RenderBox;
    final positionDeliveryThreeMonthly = renderBoxDeliveryThreeMonthly.localToGlobal(Offset.zero);

    final RenderBox renderBoxYearly = widgetKeyYearly.currentContext!.findRenderObject() as RenderBox;
    final positionYearly = renderBoxYearly.localToGlobal(Offset.zero);

    final RenderBox renderBoxDeliveryYearly = widgetKeyDeliveryYearly.currentContext!.findRenderObject() as RenderBox;
    final positionDeliveryYearly = renderBoxDeliveryYearly.localToGlobal(Offset.zero);
    print("scrollnow " + _scrollController.position.pixels.toString());
    if (_scrollController.position.pixels + positionWeekly.dy >= 1282) {
      setState(() {
        if (!weeklyLoad) {
          weeklyLoad = true;
          getGraphWeekly();
        }
      });
    }
    if (_scrollController.position.pixels + positionMonthly.dy >= 1971) {
      setState(() {
        if (!monthlyLoad) {
          monthlyLoad = true;
          getGraphMonthly();
        }
      });
    }
    if (_scrollController.position.pixels + positionThreeMonthly.dy >= 2660) {
      setState(() {
        if (!threeMonthlyLoad) {
          threeMonthlyLoad = true;
          getGraphThreeMonthly();
        }
      });
    }
    if (_scrollController.position.pixels + positionYearly.dy >= 3349) {
      setState(() {
        if (!yearlyLoad) {
          yearlyLoad = true;
          getGraphYearly();
        }
      });
    }
  }

  bool _isScrolledToBottom() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      return true;
    }
    return false;
  }

  void startTimer() async {
    Timer.periodic(const Duration(seconds: 30), (timer) {
      if (weeklyLoad) {
        getGraphWeekly();
      }
      if (monthlyLoad) {
        getGraphMonthly();
      }
      if (threeMonthlyLoad) {
        getGraphThreeMonthly();
      }
      if (yearlyLoad) {
        getGraphYearly();
      }
    });
  }

  Future<void> getReport() async {
    String queryFromdate = "";
    String queryTodate = "";
    DateTime currentDate = DateTime.now();

    if (selectedItem == 'ยอดขายวันนี้') {
      fromDateController.text = DateFormat('dd/MM/yyyy').format(currentDate);
      toDateController.text = DateFormat('dd/MM/yyyy').format(currentDate);
      queryFromdate = "&fromdate=${DateFormat('yyyy-MM-dd').format(currentDate)}";
      queryTodate = "&todate=${DateFormat('yyyy-MM-dd').format(currentDate)}";
    } else if (selectedItem == 'ยอดขายสัปดาห์นี้') {
      DateTime firstDayOfWeek = currentDate.subtract(Duration(days: currentDate.weekday - 1));
      DateTime lastDayOfWeek = firstDayOfWeek.add(const Duration(days: 6));

      fromDateController.text = DateFormat('dd/MM/yyyy').format(firstDayOfWeek);
      toDateController.text = DateFormat('dd/MM/yyyy').format(lastDayOfWeek);
      queryFromdate = "&fromdate=${DateFormat('yyyy-MM-dd').format(firstDayOfWeek)}";
      queryTodate = "&todate=${DateFormat('yyyy-MM-dd').format(lastDayOfWeek)}";
    } else if (selectedItem == 'ยอดขายเดือนนี้') {
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
    } else if (selectedItem == 'ยอดขายปีนี้') {
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

  Future<void> getGraphDaily() async {
    String queryFromdate = "";
    String queryTodate = "";
    DateTime currentDate = DateTime.now();

    queryFromdate = "&fromdate=${DateFormat('yyyy-MM-dd').format(currentDate)}";
    queryTodate = "&todate=${DateFormat('yyyy-MM-dd').format(currentDate)}";

    ReportRepository reportRepository = ReportRepository();

    ApiResponse result = await reportRepository.getReportSaleSummary(queryFromdate, queryTodate);

    if (result.success) {
      dailysale = SalesumaryModel.fromJson(result.data);
      chartPOSData = [];
      chartDeliveryData = [];

      chartPOSData.addAll([
        ChartData('เงินสด', dailysale.cash, Colors.orangeAccent),
        ChartData('สั่งกลับบ้าน', dailysale.takeAway, Colors.blue),
        ChartData('QRCode', dailysale.qrcodeAmount, Colors.green),
        ChartData('Wallet', dailysale.walletAmount, Colors.red),
      ]);
      for (var delivery in dailysale.delivery) {
        chartDeliveryData.add(ChartData(delivery.name, delivery.amount, getRandomColor()));
      }
      setState(() {});
    }
  }

  Future<void> getGraphWeekly() async {
    String queryFromdate = "";
    String queryTodate = "";
    DateTime currentDate = DateTime.now();
    DateTime firstDayOfWeek = currentDate.subtract(Duration(days: currentDate.weekday - 1));
    DateTime lastDayOfWeek = firstDayOfWeek.add(const Duration(days: 6));

    queryFromdate = "&fromdate=${DateFormat('yyyy-MM-dd').format(firstDayOfWeek)}";
    queryTodate = "&todate=${DateFormat('yyyy-MM-dd').format(lastDayOfWeek)}";

    ReportRepository reportRepository = ReportRepository();

    ApiResponse result = await reportRepository.getReportSaleSummary(queryFromdate, queryTodate);

    if (result.success) {
      SalesumaryModel data = SalesumaryModel.fromJson(result.data);
      chartPOSDataWeekly = [];
      chartDeliveryDataWeekly = [];

      chartPOSDataWeekly.addAll([
        ChartData('เงินสด', data.cash, Colors.orangeAccent),
        ChartData('สั่งกลับบ้าน', data.takeAway, Colors.blue),
        ChartData('QRCode', data.qrcodeAmount, Colors.green),
        ChartData('Wallet', data.walletAmount, Colors.red),
      ]);
      for (var data in weeklysale.delivery) {
        chartDeliveryDataWeekly.add(ChartData(data.name, data.amount, getRandomColor()));
      }
      setState(() {});
    }
  }

  Future<void> getGraphMonthly() async {
    String queryFromdate = "";
    String queryTodate = "";
    DateTime currentDate = DateTime.now();
    DateTime firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
    DateTime lastDayOfMonth = DateTime(currentDate.year, currentDate.month + 1, 0);

    queryFromdate = "&fromdate=${DateFormat('yyyy-MM-dd').format(firstDayOfMonth)}";
    queryTodate = "&todate=${DateFormat('yyyy-MM-dd').format(lastDayOfMonth)}";

    ReportRepository reportRepository = ReportRepository();

    ApiResponse result = await reportRepository.getReportSaleSummary(queryFromdate, queryTodate);

    if (result.success) {
      SalesumaryModel data = SalesumaryModel.fromJson(result.data);
      chartPOSDataMonthly = [];
      chartDeliveryDataMonthly = [];

      chartPOSDataMonthly.addAll([
        ChartData('เงินสด', data.cash, Colors.orangeAccent),
        ChartData('สั่งกลับบ้าน', data.takeAway, Colors.blue),
        ChartData('QRCode', data.qrcodeAmount, Colors.green),
        ChartData('Wallet', data.walletAmount, Colors.red),
      ]);
      for (var data in monthlysale.delivery) {
        chartDeliveryDataMonthly.add(ChartData(data.name, data.amount, getRandomColor()));
      }
      setState(() {});
    }
  }

  Future<void> getGraphThreeMonthly() async {
    String queryFromdate = "";
    String queryTodate = "";
    DateTime currentDate = DateTime.now();
    DateTime firstDayOfLastThreeMonths = DateTime(currentDate.year, currentDate.month - 2, 1);
    DateTime lastDayOfLastThreeMonths = DateTime(currentDate.year, currentDate.month + 1, 0);

    queryFromdate = "&fromdate=${DateFormat('yyyy-MM-dd').format(firstDayOfLastThreeMonths)}";
    queryTodate = "&todate=${DateFormat('yyyy-MM-dd').format(lastDayOfLastThreeMonths)}";

    ReportRepository reportRepository = ReportRepository();

    ApiResponse result = await reportRepository.getReportSaleSummary(queryFromdate, queryTodate);

    if (result.success) {
      SalesumaryModel data = SalesumaryModel.fromJson(result.data);
      chartPOSDataThreeMonthly = [];
      chartDeliveryDataThreeMonthly = [];

      chartPOSDataThreeMonthly.addAll([
        ChartData('เงินสด', data.cash, Colors.orangeAccent),
        ChartData('สั่งกลับบ้าน', data.takeAway, Colors.blue),
        ChartData('QRCode', data.qrcodeAmount, Colors.green),
        ChartData('Wallet', data.walletAmount, Colors.red),
      ]);
      for (var data in threemonthlysale.delivery) {
        chartDeliveryDataThreeMonthly.add(ChartData(data.name, data.amount, getRandomColor()));
      }
      setState(() {});
    }
  }

  Future<void> getGraphYearly() async {
    String queryFromdate = "";
    String queryTodate = "";
    DateTime currentDate = DateTime.now();
    DateTime firstDayOfYear = DateTime(currentDate.year, 1, 1);
    DateTime lastDayOfYear = DateTime(currentDate.year, 12, 31);

    queryFromdate = "&fromdate=${DateFormat('yyyy-MM-dd').format(firstDayOfYear)}";
    queryTodate = "&todate=${DateFormat('yyyy-MM-dd').format(lastDayOfYear)}";

    ReportRepository reportRepository = ReportRepository();

    ApiResponse result = await reportRepository.getReportSaleSummary(queryFromdate, queryTodate);

    if (result.success) {
      SalesumaryModel data = SalesumaryModel.fromJson(result.data);
      chartPOSDataYearly = [];
      chartDeliveryDataYearly = [];

      chartPOSDataYearly.addAll([
        ChartData('เงินสด', data.cash, Colors.orangeAccent),
        ChartData('สั่งกลับบ้าน', data.takeAway, Colors.blue),
        ChartData('QRCode', data.qrcodeAmount, Colors.green),
        ChartData('Wallet', data.walletAmount, Colors.red),
      ]);
      for (var data in yearlysale.delivery) {
        chartDeliveryDataYearly.add(ChartData(data.name, data.amount, getRandomColor()));
      }
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
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Align(
              alignment: Alignment.centerLeft,
              child: Text('รายงานยอดขายสินค้า'),
            ),
            backgroundColor: Colors.orangeAccent.shade700,
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
                  IconButton(
                    icon: const Icon(Icons.swap_vert),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SelectShopScreen()),
                      );
                    },
                  ),
                ],
              )
            ],
          ),
          body: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _handleRefresh,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: buildReport(),
                ),
              ),
            ),
          )),
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
        DateTime? pickDateTimeFormat = DateTime.parse('${DateFormat('yyyy-MM-dd').format(pickedDate)} ${DateFormat('HH:mm:ss.sss').format(DateTime.now())}');
        if (cmd == 'fromdate') {
          fromDateController.text = DateFormat('dd/MM/yyyy').format(pickDateTimeFormat);
        } else {
          toDateController.text = DateFormat('dd/MM/yyyy').format(pickDateTimeFormat);
        }

        getReport();
      });
    }
  }

  List<Widget> buildReport() {
    List<Widget> widgetList = [];

    // widgetList.add(
    //   Container(
    //     margin: const EdgeInsets.only(top: 5),
    //     child: Text(
    //       "ยอดขายวันนี้",
    //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
    //     ),
    //   ),
    // );

    widgetList.add(
      Container(
        margin: const EdgeInsets.only(top: 5),
        width: double.infinity,
        child: DropdownSearch<String>(
          items: dropdownSelect,
          itemAsString: (String? data) {
            if (data == null) return '';
            return data;
          },
          dropdownDecoratorProps: const DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              labelText: "ประเภทรายงาน",
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.only(left: 10, top: 0, bottom: 0, right: 10),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          onChanged: (String? value) {
            setState(() {
              selectedItem = value!;
              if (selectedItem != 'กำหนดเอง') {
                getReport();
              }
            });
          },
          selectedItem: selectedItem,
          popupProps: const PopupPropsMultiSelection.modalBottomSheet(
            showSearchBox: false,
            showSelectedItems: true,
          ),
        ),
      ),
    );

    if (selectedItem == 'กำหนดเอง') {
      widgetList.add(const SizedBox(
        height: 5,
      ));
      widgetList.add(SizedBox(
        width: double.infinity,
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
      ));
      widgetList.add(const SizedBox(
        height: 5,
      ));
      widgetList.add(SizedBox(
        width: double.infinity,
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
      ));
    }

    widgetList.add(const SizedBox(
      height: 5,
    ));

    widgetList.add(
      Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.8),
                spreadRadius: 0,
                blurRadius: 3,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ],
            color: Colors.purple.shade400,
          ),
          height: 100,
          padding: const EdgeInsets.all(12),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                  child: Text(
                    "ยอดขายทั้งหมด",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                Opacity(
                  opacity: opacityText,
                  child: Text(
                    global.formatNumber(salesumary.cashierAmount + salesumary.deliveryAmount),
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
          ])),
    );

    widgetList.add(const SizedBox(
      height: 5,
    ));

    widgetList.add(InkWell(
      onTap: () {
        if (isSaleShop) {
          isSaleShop = false;
        } else {
          isSaleShop = true;
        }

        setState(() {});
      },
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.8),
                spreadRadius: 0,
                blurRadius: 3,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ],
            color: Colors.orange.shade600,
          ),
          height: 100,
          padding: const EdgeInsets.all(12),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ยอดชำระหน้าร้าน",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        "กดเพื่อดูรายละเอียด",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Text(
                  global.formatNumber(salesumary.cashierAmount),
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ])),
    ));

    widgetList.add(const SizedBox(
      height: 4,
    ));

    widgetList.add(
      Visibility(
        visible: isSaleShop,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.8),
                spreadRadius: 0,
                blurRadius: 3,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ],
            color: Colors.orange.shade600,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "เงินสด",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Opacity(
                    opacity: opacityText,
                    child: Text(
                      global.formatNumber(salesumary.cash),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Opacity(
                    opacity: opacityText,
                    child: Text(
                      global.formatNumber(salesumary.takeAway),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Opacity(
                    opacity: opacityText,
                    child: Text(
                      global.formatNumber(salesumary.qrcodeAmount),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
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
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      global.formatNumber(data.amount),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Opacity(
                    opacity: opacityText,
                    child: Text(
                      global.formatNumber(salesumary.walletAmount),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
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
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      global.formatNumber(data.amount),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    )
                  ],
                ),
            ],
          ),
        ),
      ),
    );
    widgetList.add(const SizedBox(
      height: 3,
    ));
    widgetList.add(InkWell(
      onTap: () {
        if (isDeliveryShop) {
          isDeliveryShop = false;
        } else {
          isDeliveryShop = true;
        }

        setState(() {});
      },
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.8),
                spreadRadius: 0,
                blurRadius: 3,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ],
            color: Colors.blue.shade600,
          ),
          height: 100,
          padding: const EdgeInsets.all(12),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "บริการจัดส่ง",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        "กดเพื่อดูรายละเอียด",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Opacity(
                  opacity: opacityText,
                  child: Text(
                    global.formatNumber(salesumary.deliveryAmount),
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
          ])),
    ));

    widgetList.add(const SizedBox(
      height: 6,
    ));
    widgetList.add(Visibility(
      visible: isDeliveryShop,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.8),
              spreadRadius: 0,
              blurRadius: 3,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
          color: Colors.blue.shade600,
        ),
        child: Column(
          children: [
            const Text(
              "รายละเอียด",
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
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
                          "${data.name}",
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          global.formatNumber(data.amount),
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "GP ${data.gpPercent}%",
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          global.formatNumber(data.gpAmount * -1),
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "รวม",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          global.formatNumber((data.amount - data.gpAmount)),
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Divider(
                      height: 2,
                      indent: 2,
                      color: Colors.white,
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  global.formatNumber(salesumary.deliveryAmount),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  global.formatNumber(salesumary.gpAmount * -1),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  global.formatNumber(salesumary.deliveryAmount - salesumary.gpAmount),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 2,
            ),
            const Divider(
              height: 5,
              thickness: 1,
              color: Colors.white,
            ),
          ],
        ),
      ),
    ));
    widgetList.add(Container(
        key: widgetKeyDaily,
        margin: const EdgeInsets.only(top: 10, bottom: 0),
        child: const Text(
          "กราฟเปรียบเทียบยอดชำระหน้าร้านวันนี้",
          style: TextStyle(fontSize: 16),
        )));
    widgetList.add(const Divider(
      height: 3,
      thickness: 1,
      color: Colors.grey,
    ));
    widgetList.add(const SizedBox(
      height: 2,
    ));
    var series = [
      charts.Series(
        domainFn: (ChartData data, _) => data.label,
        measureFn: (ChartData data, _) => data.value,
        colorFn: (ChartData data, _) => charts.ColorUtil.fromDartColor(data.color),
        labelAccessorFn: (ChartData data, _) => '${data.value}',
        id: 'chartPOSMoney',
        data: chartPOSData,
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
    var chartWidget = SizedBox(height: 300, child: chart);
    widgetList.add(chartWidget);

    widgetList.add(Container(
        key: widgetKeyDeliveryDaily,
        margin: const EdgeInsets.only(top: 20, bottom: 0),
        child: const Text(
          "กราฟเปรียบเทียบยอดขายDeliveryวันนี้",
          style: TextStyle(fontSize: 16),
        )));
    widgetList.add(const Divider(
      height: 3,
      thickness: 1,
      color: Colors.grey,
    ));
    widgetList.add(const SizedBox(
      height: 2,
    ));
    var seriesDelivery = [
      charts.Series(
        domainFn: (ChartData data, _) => data.label,
        measureFn: (ChartData data, _) => data.value,
        colorFn: (ChartData data, _) => charts.ColorUtil.fromDartColor(data.color),
        labelAccessorFn: (ChartData data, _) => '${data.value}',
        id: 'chartDelivery',
        data: chartDeliveryData,
      ),
    ];
    var chartdDelivery = charts.BarChart(
      seriesDelivery,
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

    widgetList.add(SizedBox(height: 300, child: chartdDelivery));
    widgetList.add(const SizedBox(
      height: 5,
    ));
    widgetList.add(Container(
        key: widgetKeyWeekly,
        margin: const EdgeInsets.only(top: 10, bottom: 0),
        child: const Text(
          "กราฟเปรียบเทียบยอดชำระหน้าร้านสัปดาห์นี้",
          style: TextStyle(fontSize: 16),
        )));
    widgetList.add(const Divider(
      height: 3,
      thickness: 1,
      color: Colors.grey,
    ));
    widgetList.add(const SizedBox(
      height: 2,
    ));
    var seriesWeek = [
      charts.Series(
        domainFn: (ChartData data, _) => data.label,
        measureFn: (ChartData data, _) => data.value,
        colorFn: (ChartData data, _) => charts.ColorUtil.fromDartColor(data.color),
        labelAccessorFn: (ChartData data, _) => '${data.value}',
        id: 'chartPOSMoneyWeekly',
        data: chartPOSDataWeekly,
      ),
    ];
    var chartWeek = charts.BarChart(
      seriesWeek,
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
    var chartWidgetWeek = SizedBox(height: 300, child: chartWeek);
    widgetList.add(chartWidgetWeek);

    widgetList.add(Container(
        key: widgetKeyDeliveryWeekly,
        margin: const EdgeInsets.only(top: 20, bottom: 0),
        child: const Text(
          "กราฟเปรียบเทียบยอดขายDeliveryสัปดาห์นี้",
          style: TextStyle(fontSize: 16),
        )));
    widgetList.add(const Divider(
      height: 3,
      thickness: 1,
      color: Colors.grey,
    ));
    widgetList.add(const SizedBox(
      height: 2,
    ));
    var seriesDeliveryWeek = [
      charts.Series(
        domainFn: (ChartData data, _) => data.label,
        measureFn: (ChartData data, _) => data.value,
        colorFn: (ChartData data, _) => charts.ColorUtil.fromDartColor(data.color),
        labelAccessorFn: (ChartData data, _) => '${data.value}',
        id: 'chartDeliveryWeekly',
        data: chartDeliveryDataWeekly,
      ),
    ];
    var chartdDeliveryWeek = charts.BarChart(
      seriesDeliveryWeek,
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

    widgetList.add(SizedBox(height: 300, child: chartdDeliveryWeek));
    widgetList.add(const SizedBox(
      height: 5,
    ));
    widgetList.add(Container(
        key: widgetKeyMonthly,
        margin: const EdgeInsets.only(top: 10, bottom: 0),
        child: const Text(
          "กราฟเปรียบเทียบยอดชำระหน้าร้านเดือนนี้",
          style: TextStyle(fontSize: 16),
        )));
    widgetList.add(const Divider(
      height: 3,
      thickness: 1,
      color: Colors.grey,
    ));
    widgetList.add(const SizedBox(
      height: 2,
    ));
    var seriesMonthly = [
      charts.Series(
        domainFn: (ChartData data, _) => data.label,
        measureFn: (ChartData data, _) => data.value,
        colorFn: (ChartData data, _) => charts.ColorUtil.fromDartColor(data.color),
        labelAccessorFn: (ChartData data, _) => '${data.value}',
        id: 'chartPOSMoneyMonthly',
        data: chartPOSDataMonthly,
      ),
    ];
    var chartMonthly = charts.BarChart(
      seriesMonthly,
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
    var chartWidgetMonthly = SizedBox(height: 300, child: chartMonthly);
    widgetList.add(chartWidgetMonthly);

    widgetList.add(Container(
        key: widgetKeyDeliveryMonthly,
        margin: const EdgeInsets.only(top: 20, bottom: 0),
        child: const Text(
          "กราฟเปรียบเทียบยอดขายDeliveryเดือนนี้",
          style: TextStyle(fontSize: 16),
        )));
    widgetList.add(const Divider(
      height: 3,
      thickness: 1,
      color: Colors.grey,
    ));
    widgetList.add(const SizedBox(
      height: 2,
    ));
    var seriesDeliveryMonthly = [
      charts.Series(
        domainFn: (ChartData data, _) => data.label,
        measureFn: (ChartData data, _) => data.value,
        colorFn: (ChartData data, _) => charts.ColorUtil.fromDartColor(data.color),
        labelAccessorFn: (ChartData data, _) => '${data.value}',
        id: 'chartDeliveryMonthly',
        data: chartDeliveryDataMonthly,
      ),
    ];
    var chartdDeliveryMonthly = charts.BarChart(
      seriesDeliveryMonthly,
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

    widgetList.add(SizedBox(height: 300, child: chartdDeliveryMonthly));
    widgetList.add(const SizedBox(
      height: 5,
    ));
    widgetList.add(Container(
        key: widgetKeyThreeMonthly,
        margin: const EdgeInsets.only(top: 10, bottom: 0),
        child: const Text(
          "กราฟเปรียบเทียบยอดชำระหน้าร้าน3เดือน",
          style: TextStyle(fontSize: 16),
        )));
    widgetList.add(const Divider(
      height: 3,
      thickness: 1,
      color: Colors.grey,
    ));
    widgetList.add(const SizedBox(
      height: 2,
    ));
    var seriesThreeMonthly = [
      charts.Series(
        domainFn: (ChartData data, _) => data.label,
        measureFn: (ChartData data, _) => data.value,
        colorFn: (ChartData data, _) => charts.ColorUtil.fromDartColor(data.color),
        labelAccessorFn: (ChartData data, _) => '${data.value}',
        id: 'chartPOSMoneyThreeMonthly',
        data: chartPOSDataThreeMonthly,
      ),
    ];
    var chartThreeMonthly = charts.BarChart(
      seriesThreeMonthly,
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
    var chartWidgetThreeMonthly = SizedBox(height: 300, child: chartThreeMonthly);
    widgetList.add(chartWidgetThreeMonthly);

    widgetList.add(Container(
        key: widgetKeyDeliveryThreeMonthly,
        margin: const EdgeInsets.only(top: 20, bottom: 0),
        child: const Text(
          "กราฟเปรียบเทียบยอดขายDelivery3เดือน",
          style: TextStyle(fontSize: 16),
        )));
    widgetList.add(const Divider(
      height: 3,
      thickness: 1,
      color: Colors.grey,
    ));
    widgetList.add(const SizedBox(
      height: 2,
    ));
    var seriesDeliveryThreeMonthly = [
      charts.Series(
        domainFn: (ChartData data, _) => data.label,
        measureFn: (ChartData data, _) => data.value,
        colorFn: (ChartData data, _) => charts.ColorUtil.fromDartColor(data.color),
        labelAccessorFn: (ChartData data, _) => '${data.value}',
        id: 'chartDeliveryThreeMonthly',
        data: chartDeliveryDataThreeMonthly,
      ),
    ];
    var chartdDeliveryThreeMonthly = charts.BarChart(
      seriesDeliveryThreeMonthly,
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

    widgetList.add(SizedBox(height: 300, child: chartdDeliveryThreeMonthly));

    widgetList.add(const SizedBox(
      height: 5,
    ));
    widgetList.add(Container(
        key: widgetKeyYearly,
        margin: const EdgeInsets.only(top: 10, bottom: 0),
        child: const Text(
          "กราฟเปรียบเทียบยอดชำระหน้าร้านปีนี้",
          style: TextStyle(fontSize: 16),
        )));
    widgetList.add(const Divider(
      height: 3,
      thickness: 1,
      color: Colors.grey,
    ));
    widgetList.add(const SizedBox(
      height: 2,
    ));
    var seriesYearly = [
      charts.Series(
        domainFn: (ChartData data, _) => data.label,
        measureFn: (ChartData data, _) => data.value,
        colorFn: (ChartData data, _) => charts.ColorUtil.fromDartColor(data.color),
        labelAccessorFn: (ChartData data, _) => '${data.value}',
        id: 'chartPOSMoneyYearly',
        data: chartPOSDataYearly,
      ),
    ];
    var chartYearly = charts.BarChart(
      seriesYearly,
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
    var chartWidgetYearly = SizedBox(height: 300, child: chartYearly);
    widgetList.add(chartWidgetYearly);

    widgetList.add(Container(
        key: widgetKeyDeliveryYearly,
        margin: const EdgeInsets.only(top: 20, bottom: 0),
        child: const Text(
          "กราฟเปรียบเทียบยอดขายDelivery3เดือน",
          style: TextStyle(fontSize: 16),
        )));
    widgetList.add(const Divider(
      height: 3,
      thickness: 1,
      color: Colors.grey,
    ));
    widgetList.add(const SizedBox(
      height: 2,
    ));
    var seriesDeliveryYearly = [
      charts.Series(
        domainFn: (ChartData data, _) => data.label,
        measureFn: (ChartData data, _) => data.value,
        colorFn: (ChartData data, _) => charts.ColorUtil.fromDartColor(data.color),
        labelAccessorFn: (ChartData data, _) => '${data.value}',
        id: 'chartDeliveryYearly',
        data: chartDeliveryDataYearly,
      ),
    ];
    var chartdDeliveryYearly = charts.BarChart(
      seriesDeliveryYearly,
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

    widgetList.add(SizedBox(height: 300, child: chartdDeliveryYearly));

    widgetList.add(const SizedBox(
      height: 5,
    ));
    widgetList.add(Container(
        margin: const EdgeInsets.only(top: 10, bottom: 0),
        child: const Text(
          "10 อันดับ สินค้าขายดี ",
          style: TextStyle(fontSize: 16),
        )));
    widgetList.add(const Divider(
      height: 3,
      thickness: 1,
      color: Colors.grey,
    ));
    widgetList.add(const SizedBox(
      height: 5,
    ));
    for (int i = 0; i < salesumary.bestseller.length; i++) {
      var bestseller = salesumary.bestseller[i];
      widgetList.add(
        Container(
          margin: const EdgeInsets.only(left: 10, right: 5, bottom: 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 20, child: Text("${i + 1}.")),
              SizedBox(
                width: 60,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    image: (bestseller.imgUri != '')
                        ? DecorationImage(image: NetworkImage(bestseller.imgUri), fit: BoxFit.fill)
                        : const DecorationImage(image: AssetImage('assets/img/noimg.png'), fit: BoxFit.fill),
                  ),
                  child: const SizedBox(
                    width: 50,
                    height: 50,
                  ),
                ),
              ),
              Expanded(
                  child: Text(
                bestseller.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
              Expanded(
                  child: Text(
                "${global.formatNumber(bestseller.qty)} ${bestseller.unit}",
                textAlign: TextAlign.right,
              ))
            ],
          ),
        ),
      );
    }
    widgetList.add(Container(
        margin: const EdgeInsets.only(top: 10, bottom: 0),
        child: const Text(
          "10 อันดับสินค้าขายดีหน้าร้าน",
          style: TextStyle(fontSize: 16),
        )));
    widgetList.add(const Divider(
      height: 3,
      thickness: 1,
      color: Colors.grey,
    ));
    widgetList.add(const SizedBox(
      height: 5,
    ));
    for (int i = 0; i < salesumary.bestsellershop.length; i++) {
      var bestseller = salesumary.bestsellershop[i];
      widgetList.add(
        Container(
          margin: const EdgeInsets.only(left: 10, right: 5, bottom: 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 20, child: Text("${i + 1}.")),
              SizedBox(
                width: 60,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    image: (bestseller.imgUri != '')
                        ? DecorationImage(image: NetworkImage(bestseller.imgUri), fit: BoxFit.fill)
                        : const DecorationImage(image: AssetImage('assets/img/noimg.png'), fit: BoxFit.fill),
                  ),
                  child: const SizedBox(
                    width: 50,
                    height: 50,
                  ),
                ),
              ),
              Expanded(
                  child: Text(
                bestseller.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
              Expanded(
                  child: Text(
                "${global.formatNumber(bestseller.qty)} ${bestseller.unit}",
                textAlign: TextAlign.right,
              ))
            ],
          ),
        ),
      );
    }

    widgetList.add(Container(
        margin: const EdgeInsets.only(top: 10, bottom: 0),
        child: const Text(
          "10 อันดับสินค้าขายดีDelivery",
          style: TextStyle(fontSize: 16),
        )));
    widgetList.add(const Divider(
      height: 3,
      thickness: 1,
      color: Colors.grey,
    ));
    widgetList.add(const SizedBox(
      height: 5,
    ));
    for (int i = 0; i < salesumary.bestsellerdelivery.length; i++) {
      var bestseller = salesumary.bestsellerdelivery[i];
      widgetList.add(
        Container(
          margin: const EdgeInsets.only(left: 10, right: 5, bottom: 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 20, child: Text("${i + 1}.")),
              SizedBox(
                width: 60,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    image: (bestseller.imgUri != '')
                        ? DecorationImage(image: NetworkImage(bestseller.imgUri), fit: BoxFit.fill)
                        : const DecorationImage(image: AssetImage('assets/img/noimg.png'), fit: BoxFit.fill),
                  ),
                  child: const SizedBox(
                    width: 50,
                    height: 50,
                  ),
                ),
              ),
              Expanded(
                  child: Text(
                bestseller.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
              Expanded(
                  child: Text(
                "${global.formatNumber(bestseller.qty)} ${bestseller.unit}",
                textAlign: TextAlign.right,
              ))
            ],
          ),
        ),
      );
    }

    return widgetList;
  }
}