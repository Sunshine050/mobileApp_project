import 'package:flutter/material.dart';

class RoomModel extends ChangeNotifier {
  static final RoomModel _instance = RoomModel._internal();

  factory RoomModel() {
    return _instance;
  }

  RoomModel._internal();

  List<dynamic> _roomList = [];

  void setRooms({required List<dynamic> roomList}) {
    _roomList = roomList;
    notifyListeners();
  }

  List getRooms() {
    return _roomList;
  }
}
