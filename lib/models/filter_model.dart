import 'package:flutter/material.dart';

class FiltersModel extends ChangeNotifier {
  Set<String> selectedFilters = {};
  Map<String, String> filtersValues = {
    "Any Available": "any",
    "08:00 - 10:00": "slot_1",
    "10:00 - 12:00": "slot_2",
    "13:00 - 15:00": "slot_3",
    "15:00 - 17:00": "slot_4"
  };

  void updateFilter(String newFilter) {
    if (selectedFilters.contains("Any Available")) {
      selectedFilters.remove("Any Available");
    }

    if (selectedFilters.contains(newFilter)) {
      selectedFilters.remove(newFilter);
    } else {
      selectedFilters.add(newFilter);
    }
    notifyListeners();
  }

  void anyFilter(String newFilter) {
    if (selectedFilters.contains(newFilter)) {
      selectedFilters.remove(newFilter);
    } else {
      selectedFilters.clear();
      selectedFilters.add(newFilter);
    }
    notifyListeners();
  }

  bool isSelected(String filter) => selectedFilters.contains(filter);

  Map<String, dynamic> getFilterValues() {
    final options =
        selectedFilters.map((option) => filtersValues[option]).toList();
    return {"slots": options};
  }
}
