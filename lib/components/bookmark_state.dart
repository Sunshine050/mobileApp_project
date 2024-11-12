import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pro_mobile/components/message_dialog.dart';
import 'package:pro_mobile/services/student_service.dart';

class BookmarkButton extends StatefulWidget {
  bool isBookmarked;
  Color color = Colors.black;
  Icon icon = const Icon(Icons.bookmark_add_outlined);
  final int roomId;

  BookmarkButton({
    super.key,
    required this.isBookmarked,
    required this.roomId,
  });

  @override
  State<BookmarkButton> createState() => _BookmarkButton();
}

class _BookmarkButton extends State<BookmarkButton> {
  @override
  void initState() {
    super.initState();

    _setBookmarkedState(isBookmarked: widget.isBookmarked);
  }

  Future<void> _bookmark({required int roomId}) async {
    // api
    final http.Response response;
    if (widget.isBookmarked == false) {
      response = await StudentService().bookmarked({"room_id": roomId}).timeout(
        const Duration(seconds: 10),
      );
    } else {
      response =
          await StudentService().unbookmarked({"room_id": roomId}).timeout(
        const Duration(seconds: 10),
      );
    }

    if (response.statusCode == 200) {
      _setBookmarkedState(isBookmarked: !widget.isBookmarked);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return MessageDialog(
              content: response.body.toString(),
              messageType: 'failed',
              onConfirm: () {
                Navigator.pop(context);
              },
            );
          });
    }
  }

  void _setBookmarkedState({required bool isBookmarked}) {
    setState(() {
      widget.isBookmarked = isBookmarked; // Toggle bookmarked state
      widget.color =
          isBookmarked ? const Color.fromARGB(255, 255, 193, 7) : Colors.black;
      widget.icon = isBookmarked
          ? const Icon(Icons.bookmark_added_rounded)
          : const Icon(Icons.bookmark_add_outlined);
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: widget.icon,
      padding: const EdgeInsets.all(0),
      onPressed: () {
        _bookmark(roomId: widget.roomId);
      },
      color: widget.color,
      iconSize: 24.0,
    );
  }
}
