import 'package:calpal/screens/home/home_view.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int selectedIndex = 0;

  final List<Widget> _views = [
    // Define your views here
    HomeView(),
    SearchView(),
    AddView(),
    FavoritesView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: _views,
      ),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.fixedCircle,
        backgroundColor: Color.fromRGBO(241, 246, 249, 1),
        activeColor: Color.fromRGBO(57, 72, 103, 0.96),
        color: Color.fromRGBO(155, 164, 181, 1),
        initialActiveIndex: 0,
        items: [
          TabItem(
              icon: HeroiconsOutline.home,
              activeIcon: HeroiconsSolid.home,
              title: 'Home'),
          TabItem(
              icon: HeroiconsOutline.fire,
              activeIcon: HeroiconsSolid.fire,
              title: 'Analysis'),
          TabItem(
            icon: Image.asset(
              'assets/icons/food_icon.png',
              height: 30,
              width: 30,
            ),
          ),
          TabItem(
              icon: HeroiconsOutline.flag,
              activeIcon: HeroiconsSolid.flag,
              title: 'Goals'),
          TabItem(
              icon: HeroiconsOutline.user,
              activeIcon: HeroiconsSolid.user,
              title: 'Profile'),
        ],
        onTap: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}

// Define your views as separate StatelessWidget classes

class SearchView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Search View'),
    );
  }
}

class AddView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Add View'),
    );
  }
}

class FavoritesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Favorites View'),
    );
  }
}

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Profile View'),
    );
  }
}
