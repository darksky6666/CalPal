import 'package:calpal/screens/components/constants.dart';
import 'package:calpal/screens/registration/registration_goal.dart';
import 'package:calpal/screens/registration/registration_personal.dart';
import 'package:calpal/screens/registration/registration_physical.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final PageController _pageController = PageController();
  
  int _currentPageIndex = 0;
  final int _totalPages = 3; // Total number of pages

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10.0),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double indicatorWidth =
                    constraints.maxWidth / _totalPages * 0.95;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    _totalPages,
                    (index) => Container(
                        width: indicatorWidth,
                        height: 6.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                          color: _currentPageIndex == index
                              ? purpleColor
                              : Colors.grey,
                        ),
                      ),
                    ),
                );
              },
            ),
          ),
        ),
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        children: [
          RegistrationPage1(
            pageController: _pageController,
            totalPages: _totalPages,
          ),
          RegistrationPage2(
            pageController: _pageController,
            totalPages: _totalPages,
          ),
          RegistrationPage3(
            pageController: _pageController,
            totalPages: _totalPages,),
        ],
      ),
    );
  }
}
