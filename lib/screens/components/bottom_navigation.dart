import 'package:calpal/controllers/login_state.dart';
import 'package:calpal/screens/analysis/analysis_view.dart';
import 'package:calpal/screens/food/food_view.dart';
import 'package:calpal/screens/goal/goal_view.dart';
import 'package:calpal/screens/home/home_view.dart';
import 'package:calpal/screens/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:ionicons/ionicons.dart';

class BottomNav extends StatefulWidget {
  final int currentIndex;

  const BottomNav({super.key, required this.currentIndex});

  @override
  // ignore: library_private_types_in_public_api
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color.fromRGBO(241, 246, 249, 1),
      selectedItemColor: const Color.fromRGBO(57, 72, 103, 0.96),
      unselectedItemColor: const Color.fromRGBO(155, 164, 181, 1),
      currentIndex: widget.currentIndex,
      items: const [
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
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        HomeView(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ));
              break;
            case 1:
              Navigator.pushAndRemoveUntil(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      AnalysisView(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
                ModalRoute.withName('/'),
              );
              break;
            case 2:
              Navigator.pushAndRemoveUntil(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      const FoodView(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
                ModalRoute.withName('/'),
              );
              break;
            case 3:
              Navigator.pushAndRemoveUntil(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      const GoalView(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
                ModalRoute.withName('/'),
              );
              break;
            case 4:
              Navigator.pushAndRemoveUntil(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      const ProfileView(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
                ModalRoute.withName('/'),
              );
              break;
            default:
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        const LoginState(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ));
              break;
          }
        }
      },
    );
  }
}
