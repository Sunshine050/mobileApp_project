import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pro_mobile/components/message_dialog.dart';
import 'package:pro_mobile/components/time_slot_radio.dart';
import 'package:pro_mobile/models/page_index.dart';
import 'package:pro_mobile/page_routes/student.dart';
import 'package:pro_mobile/services/api_service.dart';
import 'package:pro_mobile/services/rooms_service.dart';

class Booking extends StatefulWidget {
  final int roomId;

  const Booking({super.key, required this.roomId});

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  final PageIndex _currentRouteIndex = PageIndex();
  final baseUrl = ApiService().getServerUrl();

  String? _selectedSlot;
  final TextEditingController _reasonController = TextEditingController();
  // dynamic roomData = [];

  @override
  void initState() {
    super.initState();
  }

  Future<dynamic> _getRoomData() async {
    // api get room
    try {
      final response =
          await RoomsService().getRoom(widget.roomId.toString()).timeout(
                const Duration(seconds: 10),
              );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
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

  void submit() {
    if (_selectedSlot == null || _reasonController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return MessageDialog(
            content: 'Please select a time slot and provide a reason.',
            onConfirm: () {
              Navigator.of(context).pop();
            },
            messageType: 'error',
          );
        },
      );
      return;
    }
  }

  // disable radio slot
  bool isAvailable(String slotValue) {
    return slotValue == "free" ? true : false;
  }

  // slot value
  void slotRadio(dynamic value) {
    setState(() {
      _selectedSlot = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 45, 116, 221)),
        useMaterial3: true,
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
          title: const Text("Room Reservation"),
          centerTitle: true,
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          // child: Builder(builder: (BuildContext context) {
          //   debugPrint("hi2");
          //   return SizedBox.shrink();
          // }),
          child: FutureBuilder(
              future: _getRoomData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // roomData = snapshot.data!;
                  // debugPrint("snapdata: ${snapshot.data[0]["room_name"]}");
                  // debugPrint("roomData: ${snapshot.data[0]["room_name"]}");
                  return Column(
                    children: [
                      Expanded(
                          flex: 3,
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24)),
                            ),
                            child: Image.network(
                              "http://$baseUrl/public/rooms/${snapshot.data[0]['image']}",
                              fit: BoxFit.cover,
                            ),
                          )),
                      Expanded(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 8),
                            child: Column(
                              children: [
                                Row(children: [
                                  Text(
                                    snapshot.data[0]["room_name"],
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                ]),
                                Row(children: [
                                  Text(
                                    snapshot.data[0]["desc"],
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ]),
                                const SizedBox(
                                  height: 16,
                                ),
                                // slot radio
                                Wrap(spacing: 4.0, children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: isAvailable(
                                                snapshot.data[0]["slot_1"])
                                            ? () {
                                                setState(() {
                                                  _selectedSlot = "slot_1";
                                                });
                                              }
                                            : null,
                                        child: Row(
                                          children: [
                                            Radio(
                                                value: "slot_1",
                                                groupValue: _selectedSlot,
                                                onChanged: isAvailable(snapshot
                                                        .data[0]["slot_1"])
                                                    ? (value) => setState(() {
                                                          _selectedSlot =
                                                              value as String?;
                                                        })
                                                    : null),
                                            TimeSlotRadio(
                                                time: "08:00 - 10:00",
                                                status: snapshot.data[0]
                                                    ["slot_1"]),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      GestureDetector(
                                        onTap: isAvailable(
                                                snapshot.data[0]["slot_2"])
                                            ? () {
                                                setState(() {
                                                  _selectedSlot = "slot_2";
                                                });
                                              }
                                            : null,
                                        child: Row(
                                          children: [
                                            Radio(
                                                value: "slot_2",
                                                groupValue: _selectedSlot,
                                                onChanged: isAvailable(snapshot
                                                        .data[0]["slot_2"])
                                                    ? (value) => setState(() {
                                                          _selectedSlot =
                                                              value as String?;
                                                        })
                                                    : null),
                                            TimeSlotRadio(
                                                time: "10:00 - 12:00",
                                                status: snapshot.data[0]
                                                    ["slot_2"]),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: isAvailable(
                                                snapshot.data[0]["slot_3"])
                                            ? () {
                                                setState(() {
                                                  _selectedSlot = "slot_3";
                                                });
                                              }
                                            : null,
                                        child: Row(
                                          children: [
                                            Radio(
                                                value: "slot_3",
                                                groupValue: _selectedSlot,
                                                onChanged: isAvailable(snapshot
                                                        .data[0]["slot_3"])
                                                    ? (value) => setState(() {
                                                          _selectedSlot =
                                                              value as String?;
                                                        })
                                                    : null),
                                            TimeSlotRadio(
                                                time: "13:00 - 15:00",
                                                status: snapshot.data[0]
                                                    ["slot_3"]),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      GestureDetector(
                                        onTap: isAvailable(
                                                snapshot.data[0]["slot_4"])
                                            ? () {
                                                setState(() {
                                                  _selectedSlot = "slot_4";
                                                });
                                              }
                                            : null,
                                        child: Row(
                                          children: [
                                            Radio(
                                                value: "slot_4",
                                                groupValue: _selectedSlot,
                                                onChanged: isAvailable(snapshot
                                                        .data[0]["slot_4"])
                                                    ? (value) => setState(() {
                                                          _selectedSlot =
                                                              value as String?;
                                                        })
                                                    : null),
                                            TimeSlotRadio(
                                                time: "15:00 - 17:00",
                                                status: snapshot.data[0]
                                                    ["slot_4"]),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                                const SizedBox(
                                  height: 24,
                                ),
                                Flexible(
                                    child: TextFormField(
                                  controller: _reasonController,
                                  maxLines: null,
                                  minLines: 1,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        _reasonController.clear();
                                      },
                                    ),
                                    labelText: 'Reason',
                                    hintText: 'Please enter your reason',
                                    helperText: 'required',
                                    errorText: _reasonController.text.isEmpty
                                        ? "Please enter your reason"
                                        : null,
                                    border: const OutlineInputBorder(),
                                  ),
                                )),
                              ],
                            ),
                          )),
                      // const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(16, 80, 176, 1.0)),
                            onPressed: _reasonController.text.isEmpty
                                ? null
                                : (() {
                                    // api
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return MessageDialog(
                                          content:
                                              'Your Reservation for ${snapshot.data[0]["room_name"]}\nhas been confirmed',
                                          onConfirm: () {
                                            // change to status page
                                            _currentRouteIndex.setIndex(
                                                index:
                                                    1); // set index to request status page
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            Navigator.pushReplacement<void,
                                                void>(
                                              context,
                                              MaterialPageRoute<void>(
                                                builder:
                                                    (BuildContext context) =>
                                                        const StudentRoute(),
                                              ),
                                            );
                                          },
                                          // no cancel button
                                          onCancel: null,
                                          messageType: 'ok',
                                        );
                                      },
                                    );
                                  }),
                            child: const Text(
                              "Reserve this room",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            )),
                      ),
                      const Spacer()
                    ],
                  );
                } else {
                  return const Text('Something went wrong');
                }
              }),
        )),
      ),
    );
  }
}
