import 'package:flutter/material.dart';
import 'main.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar(BuildContext context, {super.key, });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}
  int _currentIndex = 0;
  final List<Widget> myWidgets = [
    MainScreen(),
  ];
class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
          backgroundColor: szary,
          unselectedItemColor: bialy,
          selectedItemColor: niebieski,
          currentIndex: _currentIndex,

          
          onTap: (int newIndex) {
            setState(() {
              _currentIndex = newIndex;
             // Navigator.push(context, MaterialPageRoute(builder: (context)=> myWidgets[newIndex]));
            });
          },
        items: const[
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home)
          ),
          BottomNavigationBarItem(
            label: "Workout",
            icon: Icon(Icons.fitness_center)
          ),
          BottomNavigationBarItem(
            label: "Stats",
            icon: Icon(Icons.person)         
          )
        ],
        );
  }
}