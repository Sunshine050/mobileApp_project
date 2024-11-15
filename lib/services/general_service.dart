import 'package:http/http.dart' as http;
import 'package:pro_mobile/services/api_service.dart';

class GeneralService extends ApiService {
  // get userData for profile
  Future<http.Response> getUserData() async {
    final response = await getReq(endpoint: "/user/userData", useToken: true);
    return response;
  }

  // get history
  Future<http.Response> getUserHistory() async {
    final response = await getReq(endpoint: "/user/history", useToken: true);
    return response;
  }

  // get search history
  Future<http.Response> getSearchHistory(String roomName) async {
    final response =
        await getReq(endpoint: "/user/history/$roomName", useToken: true);
    return response;
  }

  // get summary slot status for dashboard
  Future<http.Response> getSummary() async {
    final response = await getReq(endpoint: "/user/dashboard", useToken: true);
    return response;
  }
}
