import 'package:dedeowner/app_const.dart';

class Environment {
  factory Environment() {
    return _singleton;
  }

  Environment._internal();

  static final Environment _singleton = Environment._internal();

  static const String DEV = 'DEV';
  static const String STAGING = 'STAGING';
  static const String PROD = 'PROD';

  late BaseConfig config;
  late bool isDev;

  initConfig(String environment) {
    config = _getConfig(environment);
    isDev = environment == DEV;
  }

  BaseConfig _getConfig(String environment) {
    switch (environment) {
      case Environment.PROD:
        return ProdConfig();
      case Environment.STAGING:
        return StagingConfig();
      default:
        return DevConfig();
    }
  }
}

abstract class BaseConfig {
  String get serviceApi;
  String get reportApi;
}

class DevConfig extends BaseConfig {
  @override
  String get serviceApi => AppConfig.serviceDevApi;

  @override
  String get reportApi => AppConfig.reportDevApi;
}

class ProdConfig extends BaseConfig {
  @override
  String get serviceApi => AppConfig.servicePrdApi;

  @override
  String get reportApi => AppConfig.reportPrdApi;
}

class StagingConfig extends BaseConfig {
  @override
  String get serviceApi => AppConfig.servicePrdApi;

  @override
  String get reportApi => AppConfig.reportPrdApi;
}
