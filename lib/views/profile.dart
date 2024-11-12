import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pro_mobile/components/message_dialog.dart';
import 'package:pro_mobile/components/room_card_sm.dart';
import 'package:pro_mobile/services/general_service.dart';
import 'package:pro_mobile/services/student_service.dart';
import 'package:pro_mobile/views/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  final String role;
  const Profile({super.key, required this.role});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic> _userData = {"username": "", "email": ""};
  final _generalService = GeneralService();
  final _studentService = StudentService();
  List<dynamic> _bookmarkedRooms = [];

  @override
  void initState() {
    super.initState();

    // api - get user data
    _getUserData();
    // api - get bookmarked rooms
    _getBookmarked();
  }

  Future<dynamic> _getUserData() async {
    try {
      final response = await _generalService.getUserData().timeout(
            const Duration(seconds: 10),
          );
      if (response.statusCode == 200) {
        setState(() {
          _userData = jsonDecode(response.body);
        });
      } else {
        throw Exception(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> _getBookmarked() async {
    try {
      final response = await _studentService.getBookmarks().timeout(
            const Duration(seconds: 10),
          );
      if (response.statusCode == 200) {
        setState(() {
          _bookmarkedRooms = jsonDecode(response.body);
        });
      } else {
        throw Exception(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    debugPrint("token cleared");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //     icon: const Icon(Icons.arrow_back)),
        title: Text("Welcome ${_userData["username"]}!"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton.outlined(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return MessageDialog(
                        content: 'Are you sure?',
                        onConfirm: (() async {
                          await _logout();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => Homepage(),
                              ),
                              (Route<dynamic> route) => false);
                        }),
                        onCancel: () {
                          // close dialog
                          Navigator.of(context).pop();
                        },
                        messageType: 'danger',
                      );
                    },
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: Colors.red,
                    width: 1.5,
                  ),
                ),
                icon: const Icon(
                  Icons.logout_rounded,
                  color: Colors.red,
                )),
          ),
        ],
      ),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 24,
          ),
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(150)),
            ),
            child: Image.asset(
              "assets/rooms/room_1.jpg", // mock up
              fit: BoxFit.cover,
              width: 150,
              height: 150,
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Center(
            child: Text(
              _userData["email"],
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const Spacer(),
          Builder(builder: (context) {
            return (widget.role == "student")
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.bookmark_added_rounded,
                              color: Color.fromARGB(255, 255, 193, 7),
                              size: 36,
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Text(
                              "Your bookmarked rooms",
                              style: Theme.of(context).textTheme.bodyLarge,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: SizedBox(
                            height: 300,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.only(bottom: 24),
                              itemCount: _bookmarkedRooms.length,
                              itemBuilder: (context, index) {
                                final itemData = _bookmarkedRooms[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: RoomCardSm(
                                    key: UniqueKey(),
                                    roomId: itemData?['room_id'],
                                    roomName: itemData?['room_name'],
                                    img: itemData?['image'],
                                    slot_1: itemData?['slot_1'],
                                    slot_2: itemData?['slot_2'],
                                    slot_3: itemData?['slot_3'],
                                    slot_4: itemData?['slot_4'],
                                  ),
                                );
                              },
                            )),
                      ),
                    ],
                  )
                : const SizedBox.shrink();
          }),
          const Spacer()
        ],
      )),
    );
  }
}
