import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:ionicons/ionicons.dart';

class BottomNav extends StatefulWidget {
  final int currentIndex;

  BottomNav({super.key, required this.currentIndex});

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Color.fromRGBO(241, 246, 249, 1),
      selectedItemColor: Color.fromRGBO(57, 72, 103, 0.96),
      unselectedItemColor: Color.fromRGBO(155, 164, 181, 1),
      currentIndex: widget.currentIndex,
      items: [
        BottomNavigationBarItem(
            icon: Icon(HeroiconsOutline.home),
            activeIcon: Icon(HeroiconsSolid.home),
            label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(HeroiconsOutline.fire),
            activeIcon: Icon(HeroiconsSolid.fire),
            label: 'Analysis'),
        BottomNavigationBarItem(
          icon: Icon(Ionicons.fast_food_outline),
          activeIcon: Icon(Ionicons.fast_food),
          label: 'Add Meal',
        ),
        BottomNavigationBarItem(
            icon: Icon(HeroiconsOutline.flag),
            activeIcon: Icon(HeroiconsSolid.flag),
            label: 'Goals'),
        BottomNavigationBarItem(
            icon: Icon(HeroiconsOutline.user),
            activeIcon: Icon(HeroiconsSolid.user),
            label: 'Profile'),
      ],
      onTap: (int index) {
        if (widget.currentIndex == index) {
          return;
        } else {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/analysis');
              break;
            case 2:
              Navigator.pushNamed(context, '/food');
              break;
            case 3:
              Navigator.pushNamed(context, '/goal');
              break;
            case 4:
              Navigator.pushNamed(context, '/profile');
              break;
            default:
              Navigator.popAndPushNamed(context, '/');
              break;
          }
        }
      },
    );
  }
}
