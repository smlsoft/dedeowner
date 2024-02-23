import 'package:dedeowner/environment.dart';
import 'package:dedeowner/home_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dedeowner/dashboard.dart';
import 'package:dedeowner/select_language_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dedeowner/usersystem/login_shop.dart';
import 'global.dart' as global;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
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
  if (!kIsWeb) {
    await Firebase.initializeApp();
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
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
          useMaterial3: false,
        ),
        home: const LoginShop(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => const HomePage(),
          '/dashboard': (BuildContext context) => const DashboardScreen(),
          '/selectlanguage': (BuildContext context) => const SelectLanguageScreen(),
        },
      ),
    );
  }
}
