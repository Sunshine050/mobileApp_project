import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'api_service.dart';

class StudentService extends ApiService {
  // book a room
  Future<http.Response> bookRoom(Map<String, dynamic> bookingData) async {
    final response = await postReq(
        endpoint: "/student/book", body: bookingData, useToken: true);
    return response;
  }

  // cancel req
  Future<http.Response> cancel(int bookingID) async {
    final response = await putReq(
        endpoint: "/student/cancel/${bookingID.toString()}", useToken: true);
    return response;
  }

  // get pending req
  Future<http.Response> getPending() async {
    final response =
        await getReq(endpoint: "/student/bookings", useToken: true);
    return response;
  }

  // bookmarked a room
  Future<http.Response> bookmarked(Map<String, dynamic> roomID) async {
    final response = await postReq(
        endpoint: "/student/bookmarked", body: roomID, useToken: true);
    return response;
  }

  // delete bookmarked room
  Future<http.Response> unbookmarked(Map<String, dynamic> roomID) async {
    final response = await deleteReq(
        endpoint: "/student/unBookmarked", body: roomID, useToken: true);
    return response;
  }

  // get all bookmarked rooms
  Future<http.Response> getBookmarks() async {
    final response =
        await getReq(endpoint: "/student/getBookmarked", useToken: true);
    return response;
  }
}
