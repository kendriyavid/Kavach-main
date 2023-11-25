import 'package:flutter/material.dart';
import 'package:papatruecaller/utils/colors.dart';
import '../../screen/pages/calls.dart';
import '../../screen/pages/email.dart';
import '../../screen/pages/messages.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOption = <Widget>[
    calls(),
    messages(),
    email(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle:  true,
        title: Text("Spam Guard"),
      ),
      drawer: Drawer(
        child: Center(
          child: Text("side bar"),
        ),
      ),
      body: Center(
        child: _widgetOption[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        elevation: 10,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: AppColor.selectedbootomiconcolor,
        unselectedItemColor: AppColor.unselectedbootomiconcolor,
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.phone),
            activeIcon: Icon(Icons.phone),
            label: "Phone",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            activeIcon: Icon(Icons.message),
            label: "Messages",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.email),
            activeIcon: Icon(Icons.email),
            label: "Email",
          ),
        ],
      ),
    );
  }
}
