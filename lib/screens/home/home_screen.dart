import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// Widget for food containers
Widget FoodContainer(String title) {
  return Container(
    margin: EdgeInsets.only(top: 10),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        FoodItem('Food 1', '200 Calories'),
        FoodItem('Food 2', '300 Calories'),
        // Add more food items here.
      ],
    ),
  );
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<IconData> iconList = [
    Icons.home,
    Icons.fastfood,
    Icons.flag,
    Icons.person,
  ];

  final List<String> titleList = [
    'Home',
    'Food',
    'Activity',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              // Handle signout action.
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor:
                        _selectedIndex == 0 ? Colors.white : Colors.black,
                    backgroundColor:
                        _selectedIndex == 0 ? Colors.grey : Colors.white,
                  ),
                  child: Text('Day'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor:
                        _selectedIndex == 1 ? Colors.white : Colors.black,
                    backgroundColor:
                        _selectedIndex == 1 ? Colors.grey : Colors.white,
                  ),
                  child: Text('Week'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_left),
                  onPressed: () {
                    // Handle previous day action.
                  },
                ),
                Text('Current Day'),
                IconButton(
                  icon: Icon(Icons.arrow_right),
                  onPressed: () {
                    // Handle next day action.
                  },
                ),
              ],
            ),
            Container(
              color: Colors.purple,
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('Total Calories: 2000'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text('Carbs'),
                          Text('20g'),
                        ],
                      ),
                      Column(
                        children: [
                          Text('Fat'),
                          Text('10g'),
                        ],
                      ),
                      Column(
                        children: [
                          Text('Protein'),
                          Text('30g'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  FoodContainer('Breakfast'),
                  FoodContainer('Lunch'),
                  FoodContainer('Dinner'),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle the "Add Food" button action
        },
        child: Icon(Icons.add),
        shape: CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: iconList.length,
        tabBuilder: (int index, bool isActive) {
          final color = isActive ? Colors.purple : Colors.grey;
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconList[index],
                size: 24,
                color: color,
              ),
              const SizedBox(height: 4),
              !isActive
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: AutoSizeText(
                        titleList[index],
                        maxLines: 1,
                        style: TextStyle(color: color),
                        group: AutoSizeGroup(),
                      ),
                    )
            ],
          );
        },
        backgroundColor: Colors.grey[300],
        activeIndex: _selectedIndex,
        notchSmoothness: NotchSmoothness.defaultEdge,
        gapLocation: GapLocation.center,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (index) => setState(() => _selectedIndex = index),
        splashSpeedInMilliseconds: 200,
      ),
    );
  }
}

class FoodItem extends StatelessWidget {
  final String name;
  final String calorie;

  FoodItem(this.name, this.calorie);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.network(
            'https://images.immediate.co.uk/production/volatile/sites/30/2023/06/Ultraprocessed-food-58d54c3.jpg',
            width: 50,
            height: 50),
        SizedBox(width: 10),
        Text(name),
        Spacer(),
        Text(calorie),
      ],
    );
  }
}
