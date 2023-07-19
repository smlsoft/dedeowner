import 'package:dedeowner/environment.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dedeowner/dashboard.dart';
import 'package:dedeowner/select_language_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dedeowner/usersystem/login_shop.dart';
import 'global.dart' as global;

import 'package:dedeowner/imports_repositories.dart';
import 'package:dedeowner/imports_bloc.dart';

void initializeEnvironmentConfig() {
  const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: Environment.DEV,
  );
  Environment().initConfig(environment);
}

void mainApp() async {
  initializeEnvironmentConfig();
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init("dedeowner");
  global.themeSelect(0);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (_) => LoginBloc(userRepository: UserRepository()),
        ),
        BlocProvider<ListShopBloc>(
          create: (_) => ListShopBloc(userRepository: UserRepository()),
        ),
        BlocProvider<ShopSelectBloc>(
          create: (_) => ShopSelectBloc(userRepository: UserRepository()),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('th', 'TH'),
          Locale('en', 'US'),
        ],
        debugShowCheckedModeBanner: false,
        title: 'DEDE MERCHANT',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const LoginShop(),
        routes: <String, WidgetBuilder>{
          '/dashboard': (BuildContext context) => const DashboardScreen(),
          '/selectlanguage': (BuildContext context) => const SelectLanguageScreen(),
        },
      ),
    );
  }
}
