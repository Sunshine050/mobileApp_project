class PageIndex {
  static final PageIndex _instance = PageIndex._internal();

  factory PageIndex() {
    return _instance;
  }

  PageIndex._internal();

  int _pageIndex = 0;

  void setIndex({required int index}) {
    _pageIndex = index;
  }

  int getIndex() {
    return _pageIndex;
  }
}
