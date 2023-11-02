import 'package:calpal/screens/components/bottom_navigation.dart';
import 'package:flutter/material.dart';

class AnalysisView extends StatefulWidget {
  const AnalysisView({super.key});

  @override
  State<AnalysisView> createState() => _AnalysisViewState();
}

class _AnalysisViewState extends State<AnalysisView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 20, left: 5),
          child: Text(
            'Analysis',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w800, fontSize: 25),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Text('Analysis'),
      ),
      bottomNavigationBar: BottomNav(currentIndex: 1),
    );
  }
}
