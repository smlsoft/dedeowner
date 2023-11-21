// ignore_for_file: constant_identifier_names, use_build_context_synchronously

import 'dart:io';

import 'dart:async';
import 'package:dedeowner/api/clickhouse/clickhouse_api.dart';
import 'package:dedeowner/global_model.dart';
import 'package:dedeowner/model/theme_model.dart';
import 'package:dedeowner/utils/google_sheet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dedeowner/model/global_model.dart';
import 'package:dedeowner/model/public_color_model.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:developer' as dev;
import 'dart:math' as math;
import 'package:uuid/uuid.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

typedef GuidCallback = void Function({String guid, bool isEdit});

class FieldFocusModel {
  FocusNode focusNode;
  bool isReadOnly;

  FieldFocusModel({required this.focusNode, this.isReadOnly = false});
}

class SearchCodeNameModel {
  String code;
  List<LanguageDataModel> names;
  bool isCancel;
  SearchCodeNameModel({required this.code, required this.names, this.isCancel = false});
}

class SearchGuidCodeNameModel {
  String guid;
  String code;
  List<LanguageDataModel> names;
  bool isCancel;
  SearchGuidCodeNameModel({required this.guid, required this.code, required this.names, this.isCancel = false});
}

enum DateTimeFormatEnum { fullDate, date, dateTime, dateTimeDay, time, dateDay }

enum TransactionTypeEnum { purchase, purchasereturn, sale, salereturn, stocktransfer, stockreceiveproduct, stockpickupproduct, stockreturnproduct, adjust, paid, pay }

enum ReportEnum {
  product,
  saleinvoice,
  debtor,
  creditor,
  bookbank,
  purchase,
  purchasereturn,
  saleinvoicereturn,
  transfer,
  receive,
  pickup,
  returnproduct,
  stockadjustment,
  paid,
  pay
}

enum PosVersionEnum { Pos, Restaurant, Vfgl }

enum LoginEnum { none, google, facebook, apple }

enum ScreenEventEnum { add, edit, list, display }

enum DeviceModeEnum {
  none,
  iphone,
  ipad,
  windowsDesktop,
  macosDesktop,
  linuxDesktop,
  androidPhone,
  androidTablet,
}

// โหมด พัฒนาโปรแกรม
bool developerMode = true;
List<String> googleLanguageCode = [];
String userLanguage = "th";
bool apiConnected = false;
String apiToken = "";
String apiUserName = "maxkorn"; //maxkorn
String apiUserPassword = "maxkorn"; //maxkorn
String apiShopCode = "2Eh6e3pfWvXTp0yV3CyFEhKPjdI"; // "27dcEdktOoaSBYFmnN6G6ett4Jb";
bool isLoginProcess = false;
GetStorage appConfig = GetStorage('AppConfig');
String systemLanguage = "th";
String loginName = "";
String loginEmail = "";
String loginPhotoUrl = "";
DeviceModeEnum deviceMode = DeviceModeEnum.androidPhone;
List<PublicColorModel> publicColors = [];
late List<LanguageSystemModel> languageSystemData;
late List<LanguageSystemCodeModel> languageSystemCode;
int loadDataPerPage = 500;
late PosVersionEnum posVersion;

ThemeModel theme = ThemeModel();

bool isMobileScreen(BuildContext context) {
  return MediaQuery.of(context).size.width < 600;
}

String transactionName(TransactionTypeEnum transactionType) {
  switch (transactionType) {
    case TransactionTypeEnum.purchase:
      return language("transaction_purchase");
    case TransactionTypeEnum.purchasereturn:
      return language("transaction_purchasereturn");
    case TransactionTypeEnum.sale:
      return language("transaction_sale");
    case TransactionTypeEnum.salereturn:
      return language("transaction_salereturn");
    case TransactionTypeEnum.stockpickupproduct:
      return language("transaction_stock_pick_up_product");
    case TransactionTypeEnum.stockreceiveproduct:
      return language("transaction_stock_receive_product");
    case TransactionTypeEnum.stockreturnproduct:
      return language("transaction_stock_return_product");
    case TransactionTypeEnum.stocktransfer:
      return language("transaction_stock_transfer");
    case TransactionTypeEnum.adjust:
      return language("transaction_adjust");
    case TransactionTypeEnum.paid:
      return language("transaction_paid");
    case TransactionTypeEnum.pay:
      return language("transaction_pay");
  }
}

String getreportName(ReportEnum reportType) {
  switch (reportType) {
    case ReportEnum.product:
      return language("report_product");
    case ReportEnum.saleinvoice:
      return language("report_saleinvoice");
    case ReportEnum.debtor:
      return language("report_debtor");
    case ReportEnum.creditor:
      return language("report_creditor");
    case ReportEnum.bookbank:
      return language("report_bookbank");
    case ReportEnum.purchase:
      return language("report_purchase");
    case ReportEnum.purchasereturn:
      return language("report_purchasereturn");
    case ReportEnum.saleinvoicereturn:
      return language("report_saleinvoicereturn");
    case ReportEnum.transfer:
      return language("report_transfer");
    case ReportEnum.receive:
      return language("report_receive");
    case ReportEnum.pickup:
      return language("report_pickup");
    case ReportEnum.returnproduct:
      return language("report_returnproduct");
    case ReportEnum.stockadjustment:
      return language("report_stockadjustment");
    case ReportEnum.paid:
      return language("report_paid");
    case ReportEnum.pay:
      return language("report_pay");
  }
}

String dateTimeBuddhist(DateTime dateTime, {DateTimeFormatEnum format = DateTimeFormatEnum.fullDate}) {
  int day = dateTime.day;
  int month = dateTime.month;
  String dayOfWeek = DateFormat.EEEE('th_TH').format(dateTime);
  String monthYear = DateFormat.MMMM('th_TH').format(dateTime);
  String yearStr = (dateTime.year + 543).toString();
  switch (format) {
    case DateTimeFormatEnum.fullDate:
      return '$dayOfWeek ที่ $day $monthYear $yearStr';
    case DateTimeFormatEnum.date:
      return "${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$yearStr";
    case DateTimeFormatEnum.time:
      return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
    case DateTimeFormatEnum.dateTime:
      if (dateTime.hour == 0 && dateTime.minute == 0) {
        return "${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$yearStr";
      } else {
        return "${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$yearStr ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
      }
    case DateTimeFormatEnum.dateTimeDay:
      if (dateTime.hour == 0 && dateTime.minute == 0) {
        return "${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$yearStr ($dayOfWeek)";
      } else {
        return "${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$yearStr ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} ($dayOfWeek)";
      }
    case DateTimeFormatEnum.dateDay:
      return "${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$yearStr ($dayOfWeek)";
  }
}

void themeSelect(int mode) {
  switch (mode) {
    default:
      theme.backgroundColor = colorFromHex('DFECED');
      theme.appBarColor = colorFromHex("012A4A");
      theme.headTitleColor = Colors.white;
      theme.inputTextBoxForceColor = colorFromHex("8A1606");
      theme.inputTextBoxColor = Colors.black;
      theme.columnHeaderColor = colorFromHex("89C2D9");
      theme.columnHeaderTextColor = Colors.black;
      theme.columnAlternateEvenColor = colorFromHex("F3F7FA");
      theme.columnAlternateOddColor = Colors.white;
      theme.buttonIconBackgroundColor = Colors.white;
      theme.buttonColor = colorFromHex("2A6F97");
      theme.buttonYesColor = colorFromHex("2A6F97");
      theme.buttonNoColor = colorFromHex("A9D6E5");
      theme.toolBarEditModeColor = colorFromHex("2A6F97");
      break;
  }
}

String randomDocNo(String header, DateTime selectedDate) {
  String returnValue = "";
  const uuid = Uuid();
  final formattedDate = DateFormat('yyMMddHHmm').format(selectedDate);
  returnValue = header + formattedDate + uuid.v4().split("-")[1];
  return returnValue.toUpperCase();
}

String packName(List<LanguageDataModel> names) {
  String result = "";
  for (int i = 0; i < names.length; i++) {
    if (names[i].name.isNotEmpty) {
      if (i > 0) {
        if (names[i].name != '') {
          result += ",";
        }
      }
      result += names[i].name;
    }
  }
  return result;
}

class Debouncer {
  final int? milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer(this.milliseconds);

  run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }

    _timer = Timer(Duration(milliseconds: milliseconds!), action);
  }
}

Color colorFromHex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}

void showSnackBar(BuildContext context, Icon icon, String message, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: color,
      duration: const Duration(seconds: 1),
      content: (Row(
        children: [
          icon,
          const SizedBox(width: 10),
          Flexible(child: Text(message, overflow: TextOverflow.ellipsis)),
        ],
      ))));
}

String language(String code) {
  bool found = false;
  code = code.trim().toLowerCase();
  String result = code;
  for (int i = 0; i < languageSystemData.length; i++) {
    if (languageSystemData[i].code == code) {
      result = languageSystemData[i].text;
      found = true;
      break;
    }
  }
  if (!found) {
    dev.log("language not found: $code");
    if (developerMode && code.trim().isNotEmpty && kIsWeb == false) {
      googleMultiLanguageSheetAppendRow(["pos", code]);
    }
  }
  return (result.trim().isEmpty) ? code : result;
}

void languageSelect(String languageCode) {
  languageSystemData = [];
  for (int i = 0; i < languageSystemCode.length; i++) {
    for (int j = 0; j < languageSystemCode[i].langs.length; j++) {
      if (languageSystemCode[i].langs[j].code == userLanguage) {
        languageSystemData.add(LanguageSystemModel(code: languageSystemCode[i].code.trim(), text: languageSystemCode[i].langs[j].text.trim()));
      }
    }
  }
  /*global.languageSystemData.sort((a, b) {
    return a.code.compareTo(b.code);
  });*/
}

class NumberInputFormatter extends TextInputFormatter {
  final int maximumFractionDigits;
  NumberInputFormatter({
    this.maximumFractionDigits = 2,
  }) : assert(maximumFractionDigits >= 0);
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var newText = newValue.text;
    var selectionOffset = newValue.selection.extent.offset;
    bool isNegative = false;
    if (newText.startsWith('-')) {
      newText = newText.substring(1);
      isNegative = true;
    }
    if (newText.isEmpty) {
      return newValue;
    }
    if (newText.indexOf('.') != newText.lastIndexOf('.')) {
      // inputted more than one dot.
      return oldValue;
    }
    if (newText.startsWith('.') && maximumFractionDigits > 0) {
      newText = '0$newText';
      selectionOffset += 1;
    }
    while (newText.length > 1 && !newText.startsWith('0.') && newText.startsWith('0')) {
      newText = newText.substring(1);
      selectionOffset -= 1;
    }
    if (decimalDigitsOf(newText) > maximumFractionDigits) {
      // delete the extra digits.
      newText = newText.substring(0, newText.indexOf('.') + 1 + maximumFractionDigits);
    }
    if (newValue.text.length == oldValue.text.length - 1 && oldValue.text.substring(newValue.selection.extentOffset, newValue.selection.extentOffset + 1) == ',') {
      // in this case, user deleted the thousands separator, we should delete the digit number before the cursor.
      newText = newText.replaceRange(newValue.selection.extentOffset - 1, newValue.selection.extentOffset, '');
      selectionOffset -= 1;
    }
    if (newText.endsWith('.')) {
      // in order to calculate the selection offset correctly, we delete the last decimal point first.
      newText = newText.replaceRange(newText.length - 1, newText.length, '');
    }
    int lengthBeforeFormat = newText.length;
    newText = _removeComma(newText);
    if (double.tryParse(newText) == null) {
      // invalid decimal number
      return oldValue;
    }
    newText = _addComma(newText);
    selectionOffset += newText.length - lengthBeforeFormat; // thousands separator newly added
    if (maximumFractionDigits > 0 && newValue.text.endsWith('.')) {
      // decimal point is at the last digit, we need to append it back.
      newText = '$newText.';
    }
    if (isNegative) {
      newText = '-$newText';
    }
    try {
      return TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: math.min(selectionOffset, newText.length)),
      );
    } catch (e) {
      return oldValue;
    }
  }

  static int decimalDigitsOf(String text) {
    var index = text.indexOf('.');
    return index == -1 ? 0 : text.length - index - 1;
  }

  static String _addComma(String text) {
    StringBuffer sb = StringBuffer();
    var pointIndex = text.indexOf('.');
    String integerPart;
    String decimalPart;
    if (pointIndex >= 0) {
      integerPart = text.substring(0, pointIndex);
      decimalPart = text.substring(pointIndex);
    } else {
      integerPart = text;
      decimalPart = '';
    }
    List<String> parts = [];
    while (integerPart.length > 3) {
      parts.add(integerPart.substring(integerPart.length - 3));
      integerPart = integerPart.substring(0, integerPart.length - 3);
    }
    parts.add(integerPart);
    sb.writeAll(parts.reversed, ',');
    sb.write(decimalPart);
    return sb.toString();
  }

  static String _removeComma(String text) {
    return text.replaceAll(',', '');
  }
}

String getVatName(int number) {
  String returnValue = "";
  if (number == 0) {
    returnValue = language("vat_exclude");
  } else if (number == 1) {
    returnValue = language("vat_include");
  }
  return returnValue;
}

String getInquiryName(int number) {
  String returnValue = "";
  if (number == 0) {
    returnValue = language("credit");
  } else if (number == 1) {
    returnValue = language("cash");
  }
  return returnValue;
}

bool isWideScreen() {
  return (deviceMode == DeviceModeEnum.androidTablet ||
      deviceMode == DeviceModeEnum.ipad ||
      deviceMode == DeviceModeEnum.macosDesktop ||
      deviceMode == DeviceModeEnum.linuxDesktop ||
      deviceMode == DeviceModeEnum.windowsDesktop);
}

Future<void> getDeviceModel(BuildContext context) async {
  final deviceInfo = DeviceInfoPlugin();

  String model = '';

  if (kIsWeb) {
    deviceMode = DeviceModeEnum.windowsDesktop;
    return;
  }

  if (Platform.isAndroid) {
    final androidInfo = await deviceInfo.androidInfo;

    model = androidInfo.model;

    var shortestSide = MediaQuery.of(context).size.shortestSide;

    if (shortestSide > 600) {
      deviceMode = DeviceModeEnum.androidTablet;
    } else {
      deviceMode = DeviceModeEnum.androidPhone;
    }
  } else if (Platform.isIOS) {
    final iosInfo = await deviceInfo.iosInfo;

    model = iosInfo.model;

    model = model.toLowerCase();

    if (model.contains("iphone")) {
      deviceMode = DeviceModeEnum.iphone;
    } else if (model.contains("ipad")) {
      deviceMode = DeviceModeEnum.ipad;
    }
  } else if (Platform.isMacOS) {
    deviceMode = DeviceModeEnum.macosDesktop;
  } else if (Platform.isLinux) {
    deviceMode = DeviceModeEnum.linuxDesktop;
  } else if (Platform.isWindows) {
    deviceMode = DeviceModeEnum.windowsDesktop;
  }
}

String formatNumber(double val) {
  var formatter = NumberFormat('#,###.##');
  return formatter.format(val);
}

Future<void> checkDataClickhouse() async {
  try {
    var shopid = appConfig.read("shopid");
    String selectQuery = "select shopid,code,name1,name2 from dedebi.creditors where shopid='$shopid'";
    var value = await clickHouseSelect(selectQuery);
    if (value.isNotEmpty) {
      ResponseDataModel responseData = ResponseDataModel.fromJson(value);
      // Print
      String code = "";
      bool updateOrder = false;
      for (var order in responseData.data) {
        code = order["code"];
        print(code);
      }
    }
  } catch (e) {
    print(e);
  }
}

String activeLangName(List<LanguageDataModel> names) {
  String res = "";
  for (int i = 0; i < names.length; i++) {
    if (userLanguage == names[i].code) {
      res = names[i].name;
    }
  }
  return res;
}

String branchName() {
  // ชื่อสาขา
  return "สำนักงานใหญ่";
}

String shopType() {
  // ประเภทร้าน
  return "ร้านโซลาว";
}

bool isValidDate(String dateString) {
  try {
    DateFormat('yyyy-MM-dd').parseStrict(dateString);
    return true;
  } catch (e) {
    return false;
  }
}

class DataTableHeader {
  String label;
  String code;
  double width;
  TextAlign textAlign;
  Alignment alignment;

  DataTableHeader({required this.label, required this.code, required this.width, this.textAlign = TextAlign.left, this.alignment = Alignment.centerLeft});
}
