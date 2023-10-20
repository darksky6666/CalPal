// import 'package:flutter/material.dart';

// class MealsViewPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<FoodItem>>(
//       future: FoodDatabaseHelper.instance.getFoods(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           if (snapshot.hasData) {
//             final foods = snapshot.data;
//             return ListView.builder(
//               itemCount: foods.length,
//               itemBuilder: (context, index) {
//                 final food = foods[index];
//                 return Container(
//                   // Your existing container code, replace static data with data from 'food'
//                   child: Column(
//                     children: [
//                       titleText(
//                         text: food.name,
//                         color: Colors.black,
//                       ),
//                       // Replace other parts of your UI with data from 'food'
//                       // You can use 'food.image', 'food.weight', and 'food.calories'
//                     ],
//                   ),
//                 );
//               },
//             );
//           } else {
//             return Text('No data available.');
//           }
//         } else if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator();
//         } else {
//           return Text('Error: ${snapshot.error}');
//         }
//       },
//     );
//   }
// }
