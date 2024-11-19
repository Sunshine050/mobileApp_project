import 'api_service.dart';

class ApproverService extends ApiService {
  // get pending request
  Future<dynamic> getPendingRequest() async {
    return await getReq(endpoint: "/approver/booking-requests", useToken: true);
  }

  // get pending request
  Future<dynamic> approve(Map<String, dynamic> bookingID) async {
    return await postReq(
        endpoint: "/approver/approve", useToken: true, body: bookingID);
  }

  // get pending request
  Future<dynamic> reject(Map<String, dynamic> bookingID) async {
    return await postReq(
        endpoint: "/approver/reject", useToken: true, body: bookingID);
  }
}
