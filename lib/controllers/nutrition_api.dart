import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NutritionixController {
  static const List<String> apiIds = [
    'c8cd342c',
    'c75bf0ea',
    '2b3c0d8a',
    '10ccf60a',
    'f74b0a57'
  ];
  static const List<String> apiKeys = [
    '01ac7ae9ef485d3c5775669b9f1df3d5',
    '410427619a2f2a6b72798b9a66638cc9',
    '52807ffc89654ade959fdb05229f6d73',
    '488a59682b137e0c479e04c8452abd66',
    '577a8ec8cd2ea4d83917932f15c968c5'
  ];

  Future<Map<String, dynamic>?> fetchCalorieInfo(
      String servingSize, String servingUnit, String foodName) async {
    final url =
        Uri.parse('https://trackapi.nutritionix.com/v2/natural/nutrients');
    if (servingSize == '' || servingUnit == '' || foodName == '') {
      return null;
    } else {
      final String query = '$servingSize $servingUnit of $foodName';
      final body = {'query': query};

      for (int i = 0; i < apiIds.length; i++) {
        final headers = {
          'x-app-id': apiIds[i],
          'x-app-key': apiKeys[i],
          'Content-Type': 'application/json',
        };

        try {
          final response =
              await http.post(url, headers: headers, body: jsonEncode(body));

          if (response.statusCode == 200) {
            final Map<String, dynamic> data = json.decode(response.body);

            // Extract the desired information from the response
            final foods = data['foods'];
            if (foods.isNotEmpty) {
              final foodInfo = foods[0];
              final foodName = foodInfo['food_name'];
              final servingWeightGrams = foodInfo['serving_weight_grams'];
              final calories = foodInfo['nf_calories'];
              final totalFat = foodInfo['nf_total_fat'];
              final protein = foodInfo['nf_protein'];
              final totalCarbohydrate = foodInfo['nf_total_carbohydrate'];
              final saturatedFat = foodInfo['nf_saturated_fat'];
              final cholesterol = foodInfo['nf_cholesterol'];
              final sodium = foodInfo['nf_sodium'];
              final dietaryFiber = foodInfo['nf_dietary_fiber'];
              final sugars = foodInfo['nf_sugars'];
              final potassium = foodInfo['nf_potassium'];

              log(foodName + i.toString());
              return {
                'food_name': foodName,
                'serving_weight_grams': servingWeightGrams,
                'nf_calories': calories,
                'nf_total_fat': totalFat,
                'nf_protein': protein,
                'nf_total_carbohydrate': totalCarbohydrate,
                'nf_saturated_fat': saturatedFat,
                'nf_cholesterol': cholesterol,
                'nf_sodium': sodium,
                'nf_dietary_fiber': dietaryFiber,
                'nf_sugars': sugars,
                'nf_potassium': potassium,
              };
            }
          } else if (response.statusCode == 401 && i < apiIds.length - 1) {
            // If unauthorized (401) and more API keys are available, try the next one
            log('API Key $i unauthorized, trying next one...');
            continue;
          } else if (response.statusCode == 404) {
            // If food not found (404), return null
            log('Food not found');
            Fluttertoast.showToast(
                msg: "Nutrition info not found",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.redAccent.withOpacity(0.1),
                textColor: Colors.red,
                fontSize: 16.0);
            return null;
          } else {
            log('API Error: ${response.statusCode}');
            Fluttertoast.showToast(
                msg: "API Error: ${response.statusCode}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.redAccent.withOpacity(0.1),
                textColor: Colors.red,
                fontSize: 16.0);
          }
        } catch (e) {
          log('API Catch Error: $e');
        }
      }
    }
    return null;
  }
}
