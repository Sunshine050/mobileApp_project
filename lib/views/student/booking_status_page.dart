import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pro_mobile/components/message_dialog.dart';
import 'package:pro_mobile/models/page_index.dart';
import 'package:pro_mobile/page_routes/student.dart';
import 'package:pro_mobile/services/student_service.dart';

class BookingStatus extends StatefulWidget {
  const BookingStatus({super.key});

  @override
  _BookingStatusPageState createState() => _BookingStatusPageState();
}

class _BookingStatusPageState extends State<BookingStatus> {
  final PageIndex _currentRouteIndex = PageIndex();
  final studentService = StudentService();

  List<dynamic> _bookingData = [];
  String _status = 'blank';

  Future<dynamic> _getRequest() async {
    try {
      final response = await studentService.getPending();

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // debugPrint(data[0]['id'].toString());
        return data;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(jsonDecode(response.body)['message']),
          ),
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  String _getSlotTime() {
    switch (_bookingData[0]['slot']) {
      case 'slot_1':
        return "08:00 - 10:00";
      case 'slot_2':
        return "10:00 - 12:00";
      case 'slot_3':
        return "13:00 - 15:00";
      case 'slot_4':
        return "15:00 - 17:00";
      default:
        return "error";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
          future: _getRequest(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _bookingData = snapshot.data;
              // debugPrint(_bookingData[0]['id'].toString());
              _bookingData.isNotEmpty ? _status = 'pending' : 'blank';
              // debugPrint(_status);
              return Center(
                child: _status == 'blank'
                    ? _buildBlankStatus()
                    : _buildPendingContent(),
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
    );
  }

  Widget _buildPendingContent() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: Image.network(
              'http://${studentService.getServerUrl()}/public/rooms/${_bookingData[0]['image']}',
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _bookingData[0]['room_name'],
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Image.asset(
                'assets/icon2/hour-glass.png',
                width: 50,
                height: 50,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _bookingData[0]['booking_date'].split('T')[0],
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text('Selected time slot: ${_getSlotTime()}'),
          const SizedBox(height: 8),
          Text(
            'Reason: ${_bookingData[0]['reason']}',
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Text('Status: '),
              Text(
                'Pending',
                style: TextStyle(
                    color: Colors.orange, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () {
                _showCancelConfirmationDialog(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  void _showCancelConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MessageDialog(
          content: "Are you sure you want to cancel this reservation?",
          messageType: 'danger',
          onConfirmText: "YES",
          onConfirm: (() async {
            // api
            try {
              final response =
                  await studentService.cancel(_bookingData[0]['id']);
              if (response.statusCode == 200) {
                // change to status page
                _currentRouteIndex.setIndex(
                    index: 1); // set index to request status page
                Navigator.of(context).pop();
                // Navigator.of(context).pop();
                Navigator.pushReplacement<void, void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const StudentRoute(),
                  ),
                );
              }
            } catch (e) {
              debugPrint(e.toString());
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(e.toString()),
                ),
              );
            }
          }),
          onCancelText: "NO",
          onCancel: (() {
            Navigator.of(context).pop();
          }),
        );
        // return AlertDialog(
        //   shape:
        //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        //   title: Row(
        //     children: [
        //       Icon(Icons.info, color: Colors.black),
        //       SizedBox(width: 8),
        //       Text("Notification"),
        //     ],
        //   ),
        //   content: Column(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       Container(
        //         width: 80,
        //         height: 80,
        //         decoration: BoxDecoration(
        //           shape: BoxShape.circle,
        //           color: const Color.fromARGB(255, 253, 252, 252),
        //         ),
        //         padding: EdgeInsets.all(16),
        //         child: Image.asset(
        //           'assets/icon2/remove.png',
        //           fit: BoxFit.contain,
        //         ),
        //       ),
        //       SizedBox(height: 16),
        //       Text("Are you sure you want to cancel this reservation?"),
        //     ],
        //   ),
        //   actions: [
        //     TextButton(
        //       onPressed: () {
        //         // ปิด dialog และเปลี่ยนสถานะเป็น 'blank'
        //         Navigator.of(context).pop();
        //         setState(() {
        //           _status = 'blank';
        //         });
        //       },
        //       child: Text("confirm", style: TextStyle(color: Colors.red)),
        //     ),
        //   ],
        // );
      },
    );
  }

//------------------------------blank-------------------------//
  Widget _buildBlankStatus() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.edit_off,
          color: Colors.grey,
          size: 80,
        ),
        SizedBox(height: 16),
        Text(
          'No pending requests.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ],
    );
  }
}
