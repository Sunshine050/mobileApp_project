import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pro_mobile/services/approver_service.dart';

class ApproveRequestPage extends StatefulWidget {
  const ApproveRequestPage({super.key});

  @override
  State<ApproveRequestPage> createState() => _ApproveRequestPageState();
}

class _ApproveRequestPageState extends State<ApproveRequestPage> {
  final ApproverService _approverService = ApproverService();

  List<dynamic> reservations = [];

  get actioned => null;

  @override
  void initState() {
    super.initState();

    _getPendingReservations();
  }

  void _showConfirmationDialog(
      BuildContext context, String action, int bookingID) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm $action'),
          content: Text('Are you sure you want to $action this request?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                debugPrint(bookingID.toString());
                _approveRequest(bookingID, status: action);
                Navigator.of(context).pop(); // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$action successfully!'),
                  ),
                );
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _approveRequest(int bookingID, {required String status}) async {
    try {
      final response;
      if (status == "approve") {
        response =
            await _approverService.approve({"bookingId": bookingID}).timeout(
          const Duration(seconds: 10),
        );
      } else {
        response =
            await _approverService.reject({"bookingId": bookingID}).timeout(
          const Duration(seconds: 10),
        );
      }

      if (response.statusCode == 200) {
        _getPendingReservations();
        debugPrint(reservations.length.toString());
      } else {
        throw Exception(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      debugPrint(e.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _getPendingReservations() async {
    try {
      final response = await _approverService.getPendingRequest().timeout(
            const Duration(seconds: 10),
          );
      if (response.statusCode == 200) {
        setState(() {
          reservations = jsonDecode(response.body);
        });
        debugPrint(reservations.length.toString());
      } else {
        throw Exception(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      debugPrint(e.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  String mapSlotValue(slot) {
    final String temp;
    switch (slot) {
      case "slot_1":
        temp = "08:00 - 10:00";
        break;
      case "slot_2":
        temp = "10:00 - 12:00";
        break;
      case "slot_3":
        temp = "13:00 - 15:00";
        break;
      default:
        temp = "15:00 - 17:00";
        break;
    }
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservation Status'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _getPendingReservations, // Refresh button
          ),
        ],
      ),
      body: reservations.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.edit_note,
                    size: 100,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No reservations awaiting approval.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: reservations.length,
                      itemBuilder: (context, index) {
                        final reservation = reservations[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Left Side
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        reservation['room_name'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        maxLines: 1,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Slot: ${mapSlotValue(reservation['slot'])}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        'Date: ${reservation['booking_date'].split("T")[0]}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        'Req By: ${reservation['username']}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Right Side
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          _showConfirmationDialog(context,
                                              'approve', reservation['id']);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                        ),
                                        child: const Row(
                                          // mainAxisAlignment:
                                          //     MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.check,
                                              color: Colors.white,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              'Approve',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      ElevatedButton(
                                        onPressed: () {
                                          _showConfirmationDialog(context,
                                              'reject', reservation['id']);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                        child: const Row(
                                          // mainAxisAlignment:
                                          //     MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.close,
                                              color: Colors.white,
                                            ),
                                            SizedBox(width: 4),
                                            Text('Reject',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            // Add Reason section
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Request reason: ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    // color: Colors.grey,
                                  ),
                                ),
                                // const SizedBox(height: 2),
                                Text(
                                  '${reservation['reason']}',
                                  softWrap: true,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Divider(),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
