import 'package:flutter/material.dart';

enum SearchBy { room, booking }

class SearchButton extends StatefulWidget {
  final SearchBy searchBy;
  final Function api;
  const SearchButton({super.key, required this.searchBy, required this.api});

  @override
  State<SearchButton> createState() => _SearchButtonState();
}

class _SearchButtonState extends State<SearchButton> {
  final TextEditingController _controller = TextEditingController();

  bool _isExpanded = false;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
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
            onEditingComplete: () {
              widget.api(_controller.text);
            },
            controller: _controller,
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
