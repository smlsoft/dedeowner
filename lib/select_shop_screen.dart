import 'package:auto_size_text/auto_size_text.dart';
import 'package:dedeowner/bloc/list_shop/list_shop_bloc.dart';
import 'package:dedeowner/bloc/shop_select/shop_select_bloc.dart';
import 'package:dedeowner/dashboard.dart';
import 'package:dedeowner/homePage.dart';
import 'package:dedeowner/model/shop_model.dart';
import 'package:flutter/material.dart';
import 'package:dedeowner/global.dart' as global;
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectShopScreen extends StatefulWidget {
  const SelectShopScreen({Key? key}) : super(key: key);

  @override
  SelectShopScreenState createState() => SelectShopScreenState();
}

class SelectShopScreenState extends State<SelectShopScreen> {
  List<ShopModel> listData = [];

  @override
  void initState() {
    loadDataList();
    super.initState();
  }

  void loadDataList() {
    context.read<ListShopBloc>().add(ListShopLoad());
  }

  Widget menuWidget({required String label, Color color = Colors.white, icon, required Function callback}) {
    Widget textWidget = Center(child: AutoSizeText(label, maxLines: 3, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)));
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(4),
          foregroundColor: Colors.black,
          backgroundColor: color,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ),
        onPressed: () {
          callback();
        },
        child: (icon == null)
            ? textWidget
            : Stack(
                children: [
                  textWidget,
                  Positioned(right: 4, top: 8, child: Icon(icon as IconData, size: 25)),
                ],
              ));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ListShopBloc, ListShopState>(
          listener: (context, state) {
            if (state is ListShopLoadSuccess) {
              setState(() {
                listData = state.shop;
              });
            }
          },
        ),
        BlocListener<ShopSelectBloc, ShopSelectState>(
          listener: (context, state) {
            if (state is ShopSelectLoadSuccess) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text("เลือกร้านค้า"),
          backgroundColor: global.theme.appBarColor,
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(10),
          child: GridView.builder(
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 150, crossAxisSpacing: 10, mainAxisSpacing: 10),
              itemCount: listData.length,
              itemBuilder: (BuildContext ctx, index) {
                final shop = listData[index];
                return menuWidget(
                    label: shop.name,
                    color: Colors.orange.shade100,
                    icon: Icons.business,
                    callback: () {
                      context.read<ShopSelectBloc>().add(ShopSelect(shop: shop));
                    });
              }),
        )),
      ),
    );
  }
}
