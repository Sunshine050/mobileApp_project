import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pro_mobile/components/search_btn.dart';
import 'package:pro_mobile/models/booking_model.dart';
import 'package:pro_mobile/services/general_service.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  // int _currentIndex = 2; // Default to History tab
  final TextEditingController _searchController = TextEditingController();
  final GeneralService _generalService = GeneralService();
  final BookingModel reservations = BookingModel();

  @override
  void initState() {
    super.initState();

    _getBooking();
  }

  @override
  void dispose() {
    // reservations.removeListener(() {});
    super.dispose();
  }

  Future<void> _getBooking() async {
    try {
      final response = await _generalService.getUserHistory().timeout(
            const Duration(seconds: 10),
          );
      if (response.statusCode == 200) {
        setState(() {
          reservations.setBookings(bookingList: jsonDecode(response.body));
        });
        // debugPrint(_rooms.length.toString());
      } else {
        throw Exception(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      debugPrint(e.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _onSearch(String searchQuery) async {
    try {
      final response =
          await _generalService.getSearchHistory(searchQuery).timeout(
                const Duration(seconds: 10),
              );
      if (response.statusCode == 200) {
        setState(() {
          reservations.setBookings(bookingList: jsonDecode(response.body));
        });
        // debugPrint(_rooms.length.toString());
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
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text('Reservation History'),
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 16),
              child: SearchButton(
                searchBy: SearchBy.room,
                api: _onSearch,
              ))
        ],
      ),
      body: reservations.getBookings().isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: _searchController.text.isNotEmpty
                      ? Text('No results found for "${_searchController.text}"')
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 100,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'No reservations found',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          ],
                        ),
                ),
              ],
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: reservations.getBookings().length,
                      itemBuilder: (context, index) {
                        final reservation = reservations.getBookings()[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Left Side
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                  ],
                                ),
                                // Right Side
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        reservation['status'] == 'Approved'
                                            ? const Icon(Icons.check_circle,
                                                color: Colors.green)
                                            : reservation['status'] ==
                                                    'Rejected'
                                                ? const Icon(Icons.cancel,
                                                    color: Colors.red)
                                                : const Icon(Icons.cancel,
                                                    color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Text(
                                          reservation['status'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: reservation['status'] ==
                                                    'Approved'
                                                ? Colors.green
                                                : reservation['status'] ==
                                                        'Rejected'
                                                    ? Colors.red
                                                    : Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    // Show the approver only if the status is not 'Canceled'
                                    if (reservation['status'] != 'cancel')
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '${reservation['status'] == 'approved' ? "Approved by:" : "Rejected By:"}  ${reservation['approved_by']}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
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
                            const Divider()
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
