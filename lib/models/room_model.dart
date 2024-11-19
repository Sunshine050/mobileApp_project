class RoomModel {
  static final RoomModel _instance = RoomModel._internal();

  factory RoomModel() {
    return _instance;
  }

  RoomModel._internal();

  List<dynamic> _roomList = [];

  void setRooms({required List<dynamic> roomList}) {
    _roomList = roomList;
  }

  List getRooms() {
    return _roomList;
  }
}
