class AppConfiguration {
  static double getRowHeightFactor(bool isTablet) {
    if (isTablet) {
      return 1.5;
    } else {
      return 1.2;
    }
  }
}
