import 'package:flutter/material.dart';
import 'package:pro_mobile/models/page_index.dart';
import 'package:pro_mobile/views/browse.dart';
import 'package:pro_mobile/views/profile.dart';
import 'package:pro_mobile/views/student/booking_status_page.dart';
import 'package:pro_mobile/views/student/student_history_page.dart';

class StudentRoute extends StatefulWidget {
  const StudentRoute({super.key});

  @override
  State<StudentRoute> createState() => _StudentRouteState();
}

class _StudentRouteState extends State<StudentRoute> {
  final PageIndex _currentPageIndex = PageIndex();

  late final List<Widget> _pagesOptions;

  void _onItemTapped(int index) {
    setState(() {
      _currentPageIndex.setIndex(index: index);
    });
  }

  @override
  void initState() {
    super.initState();
    _pagesOptions = <Widget>[
      const Browse(role: "student"),
      BookingStatus(),
      const History(),
      const Profile(role: "student")
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pagesOptions.elementAt(_currentPageIndex.getIndex()),
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: const Color.fromRGBO(16, 80, 176, 1.0),
          height: 70,
          iconTheme: WidgetStateProperty.resolveWith(
              (Set<WidgetState> states) => states.contains(WidgetState.selected)
                  ? const IconThemeData(color: Color.fromRGBO(16, 80, 176, 1.0))
                  : const IconThemeData(color: Colors.white)),
          labelTextStyle: WidgetStateProperty.resolveWith(
              (Set<WidgetState> states) => states.contains(WidgetState.selected)
                  ? const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.white)
                  : const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.white)),
          // labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          indicatorColor: Colors.white,
          indicatorShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: NavigationBar(
          onDestinationSelected: _onItemTapped,
          selectedIndex: _currentPageIndex.getIndex(),
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(
                Icons.home_rounded,
              ),
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.check_circle),
              icon: Icon(Icons.check_circle_outline_rounded),
              label: 'Status',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.history_rounded),
              icon: Icon(Icons.history_rounded),
              label: 'History',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.person),
              icon: Icon(Icons.person_outline_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
