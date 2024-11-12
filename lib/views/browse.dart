import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pro_mobile/services/rooms_service.dart';
import 'package:pro_mobile/services/student_service.dart';
import 'package:pro_mobile/views/staff/manage_rooms_page.dart';
import '../components/room_card.dart';
import '../components/search_btn.dart';
import '../models/filter_model.dart';

class Browse extends StatefulWidget {
  final String role;
  const Browse({super.key, required this.role});

  @override
  State<Browse> createState() => _BrowseState();
}

class _BrowseState extends State<Browse> {
  final _filtersModel = FiltersModel();
  final _roomsService = RoomsService();
  final _studentService = StudentService();
  List<dynamic> _rooms = [];
  List<dynamic> _bookmarkedRooms = [];

  final List<String> _filtersList = [
    "08:00 - 10:00",
    "10:00 - 12:00",
    "13:00 - 15:00",
    "15:00 - 17:00"
  ];

  @override
  void initState() {
    super.initState();

    // api get _rooms
    _getBookmarked();
    _getRoom();

    _filtersModel.addListener(() {
      _filterRooms();
    });
  }

  Future<void> _getRoom() async {
    try {
      final response = await _roomsService.getRooms().timeout(
            const Duration(seconds: 10),
          );
      if (response.statusCode == 200) {
        setState(() {
          _rooms = jsonDecode(response.body);
        });
        debugPrint(_rooms.length.toString());
      } else {
        throw Exception(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      debugPrint(e.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _filterRooms() async {
    try {
      final options = _filtersModel.getFilterValues();
      if (options['slots'].isEmpty) {
        _getRoom();
      } else {
        // get _rooms by options
        final response = await _roomsService.filterRoom(options).timeout(
              const Duration(seconds: 10),
            );
        if (response.statusCode == 200) {
          setState(() {
            _rooms = jsonDecode(response.body);
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _getBookmarked() async {
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  bool _setBookmarkState(int currentID) {
    return _bookmarkedRooms.any((room) => room['room_id'] == currentID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Room List"),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 16), child: SearchButton())
        ],
      ),
      body: SafeArea(
        child: Stack(children: [
          Column(
            children: [
              // filter row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child:
                              // Filters(),
                              Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Wrap(
                                spacing: 4.0,
                                children: [
                                  FilterChip(
                                    label: Text(
                                      "Any Available",
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                    labelPadding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    selected: _filtersModel
                                        .isSelected("Any Available"),
                                    onSelected: (bool selected) => setState(() {
                                      _filtersModel.anyFilter("Any Available");
                                    }),
                                  ),
                                  ..._filtersList.map((e) {
                                    return FilterChip(
                                      label: Text(
                                        e,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                      labelPadding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      selected: _filtersModel.isSelected(e),
                                      onSelected: (bool selected) =>
                                          setState(() {
                                        _filtersModel.updateFilter(e);
                                      }),
                                    );
                                  })
                                ],
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
              // list room
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (_rooms.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 24),
                      itemCount: _rooms.length,
                      itemBuilder: (context, index) {
                        final itemData = _rooms[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 24),
                          child: RoomCard(
                            key:
                                UniqueKey(), // force element tree to change when order change by filter
                            role: widget.role,
                            roomId: itemData?['id'],
                            roomName: itemData?['room_name'],
                            desc: itemData?['desc'],
                            img: itemData?['img'],
                            slot_1: itemData?['slot_1'],
                            slot_2: itemData?['slot_2'],
                            slot_3: itemData?['slot_3'],
                            slot_4: itemData?['slot_4'],
                            isBookmarked: _setBookmarkState(itemData?['id']),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          Builder(builder: (context) {
            return (widget.role == "staff")
                ? Positioned(
                    right: 20.0,
                    bottom: 70.0,
                    child: FloatingActionButton(
                      backgroundColor: Colors.white,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ManageRooms(
                                      isAdd: true,
                                    )));
                        null;
                      },
                      child: const Icon(Icons.add),
                    ),
                  )
                : const SizedBox.shrink();
          }),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    _filtersModel.removeListener(() {});
    super.dispose();
  }
}
