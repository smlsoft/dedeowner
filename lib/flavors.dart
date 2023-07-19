enum Flavor { DEDEOWNER }

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.DEDEOWNER:
        return 'DEDE Owner';

      default:
        return 'title';
    }
  }
}
