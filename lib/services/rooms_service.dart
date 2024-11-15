import 'package:http/http.dart' as http;
import 'package:pro_mobile/services/api_service.dart';

class RoomsService extends ApiService {
  // get all rooms
  Future<http.Response> getRooms() async {
    final response = await getReq(endpoint: "/room/all", useToken: true);
    return response;
  }

  // get a room
  Future<http.Response> getRoom(String roomId) async {
    final response = await getReq(endpoint: "/room/$roomId", useToken: true);
    return response;
  }

  // search by room name
  Future<http.Response> searchRoom(String roomName) async {
    final response =
        await getReq(endpoint: "/room/search/$roomName", useToken: true);
    return response;
  }

  // filter by available slots
  Future<http.Response> filterRoom(Map<String, dynamic> filterOptions) async {
    final response = await postReq(
        endpoint: '/room/filter', body: filterOptions, useToken: true);
    return response;
  }
}
