import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pro_mobile/models/booking_model.dart';
import 'package:pro_mobile/models/room_model.dart';
import 'package:pro_mobile/services/general_service.dart';
import 'package:pro_mobile/services/rooms_service.dart';

enum SearchBy { room, booking }

class SearchButton extends StatefulWidget {
  final SearchBy searchBy;
  final TextEditingController controller;
  const SearchButton(
      {super.key, required this.searchBy, required this.controller});

  @override
  _SearchButtonState createState() => _SearchButtonState();
}

class _SearchButtonState extends State<SearchButton> {
  final RoomsService _roomsService = RoomsService();
  final GeneralService _generalService = GeneralService();

  final RoomModel _roomModel = RoomModel();
  final BookingModel _bookingModel = BookingModel();

  bool _isExpanded = false;

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: _isExpanded ? MediaQuery.of(context).size.width * 0.8 : 0,
          height: 45,
          child: TextField(
            onEditingComplete: (() async {
              try {
                // debugPrint(_searchController.text);
                if (widget.searchBy == SearchBy.room) {
                  debugPrint(widget.controller.text);
                  final response =
                      await _roomsService.searchRoom(widget.controller.text);
                  if (response.statusCode == 200) {
                    setState(() {
                      _roomModel.setRooms(roomList: jsonDecode(response.body));
                    });
                  }
                } else {
                  debugPrint(widget.controller.text);
                  final response = await _generalService
                      .getSearchHistory(widget.controller.text);
                  if (response.statusCode == 200) {
                    // final temp = jsonDecode(response.body);
                    // debugPrint(temp[0]['room_name'].toString());
                    setState(() {
                      _bookingModel.setBookings(
                          bookingList: jsonDecode(response.body));
                    });
                  }
                }
              } catch (e) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(e.toString())));
              }
            }),
            controller: widget.controller,
            decoration: InputDecoration(
              hintText: 'Search by room name...',
              border:
                  _isExpanded ? const OutlineInputBorder() : InputBorder.none,
            ),
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
        ),
      ],
    );
  }
}
