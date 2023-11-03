import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NutritionixController {
  static const String apiId = 'c75bf0ea'; 
  static const String apiKey = '410427619a2f2a6b72798b9a66638cc9'; 

  Future<Map<String, dynamic>?> fetchCalorieInfo(String query) async {
    final url = Uri.parse('https://trackapi.nutritionix.com/v2/natural/nutrients');
    final body = {'query': query};

    final headers = {
      'x-app-id': apiId,
      'x-app-key': apiKey,
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(url, headers: headers, body: jsonEncode(body));

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

          return {
            'food_name': foodName,
            'serving_weight_grams': servingWeightGrams,
            'nf_calories': calories,
            'nf_total_fat': totalFat,
            'nf_protein': protein,
            'nf_total_carbohydrate': totalCarbohydrate,
          };
        }
      }
      Fluttertoast.showToast(
          msg: "API Error: ${response.statusCode}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          textColor: Colors.red,
          fontSize: 16.0);
      return null;
    } catch (e) {
      Fluttertoast.showToast(
          msg: "API Catch Error: $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          textColor: Colors.red,
          fontSize: 16.0);
      return null;
    }
  }
}
