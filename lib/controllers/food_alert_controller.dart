class FoodAlertController {
  Map<String, Map<String, String>> foodInformation = {
    "Ayam Goreng": {
      "notSuitable": "heart,diabetes",
      "reason":
          "High in saturated and trans fats due to deep frying, leading to increased cholesterol levels and heart disease risk. The breading often contains refined carbohydrates impacting blood sugar in diabetes."
    },
    "Fried Chicken": {
      "notSuitable": "heart,diabetes",
      "reason":
          "High in saturated and trans fats due to deep frying, leading to increased cholesterol levels and heart disease risk. The breading often contains refined carbohydrates impacting blood sugar in diabetes."
    },
    "French Fries": {
      "notSuitable": "heart,diabetes",
      "reason":
          "Typically fried in unhealthy oils, high in unhealthy fats and excess salt, contributing to elevated blood pressure, heart disease risk, and blood sugar spikes in diabetes."
    },
    "French Toast": {
      "notSuitable": "heart,diabetes",
      "reason":
          "Made with white bread dipped in a mixture of eggs and milk, then fried in butter. White bread can spike blood sugar levels rapidly in diabetes, and saturated fats from butter impact heart health."
    },
    "Fried Fish": {
      "notSuitable": "heart",
      "reason":
          "Frying negates the benefits of omega-3 fatty acids in fish. Added oils and breading can increase cholesterol levels, impacting heart health."
    },
    "Fried Shrimp": {
      "notSuitable": "heart",
      "reason":
          "Frying adds unhealthy fats, increasing cholesterol levels, and posing a risk to heart health."
    },
    "Fried Spring Rolls": {
      "notSuitable": "heart",
      "reason":
          "Deep-fried in oil, high in unhealthy fats, and calories which can contribute to heart issues."
    },
    "Doughnut": {
      "notSuitable": "heart,diabetes",
      "reason":
          "High in trans fats, sugar, and refined carbohydrates, elevating bad cholesterol levels and blood sugar, impacting heart health and diabetes control."
    },
    "Croissant": {
      "notSuitable": "heart",
      "reason":
          "High in saturated fats and often made with refined flour, contributing to increased cholesterol levels and heart disease risk."
    },
    "Cream Puff": {
      "notSuitable": "heart,diabetes",
      "reason":
          "Contains high amounts of trans fats, sugar, and refined carbohydrates, negatively impacting cholesterol levels and blood sugar control."
    },
    "Crullers": {
      "notSuitable": "heart,diabetes",
      "reason":
          "High in trans fats, sugar, and refined carbs, contributing to elevated cholesterol levels and blood sugar spikes in diabetes."
    },
    "Hot Dog": {
      "notSuitable": "heart",
      "reason":
          "Often processed with high levels of saturated fats and sodium, contributing to heart disease risk."
    },
    "Hamburger": {
      "notSuitable": "heart",
      "reason":
          "High-fat content from fatty beef cuts and processed ingredients, increasing saturated fat intake and heart disease risk."
    },
    "Meat Loaf": {
      "notSuitable": "heart",
      "reason":
          "Can contain high-fat meats contributing to elevated cholesterol levels and heart issues."
    },
    "Macaroni Salad": {
      "notSuitable": "heart,diabetes",
      "reason":
          "High in refined carbs, unhealthy fats from mayo, and added sugars, impacting blood sugar control and heart health."
    },
    "Muffin": {
      "notSuitable": "heart,diabetes",
      "reason":
          "Often high in sugar, refined flour, and unhealthy fats, contributing to elevated blood sugar levels and cholesterol."
    },
    "Nachos": {
      "notSuitable": "heart,diabetes",
      "reason":
          "Typically high in unhealthy fats, refined carbs, and excess salt, contributing to heart issues and blood sugar spikes in diabetes."
    },
    "Omelet": {
      "notSuitable": "heart",
      "reason":
          "High in cholesterol from eggs and often cooked with added fats, impacting cholesterol levels and heart health."
    },
    "Pancake": {
      "notSuitable": "heart,diabetes",
      "reason":
          "Typically made with refined flour and topped with sugary syrups, leading to blood sugar spikes and potential heart issues."
    },
    "Pizza": {
      "notSuitable": "heart,diabetes",
      "reason":
          "Contains processed meats, high-fat cheese, and refined carbohydrates, contributing to increased cholesterol levels and potential blood sugar spikes."
    },
    "Popcorn": {
      "notSuitable": "heart,diabetes",
      "reason":
          "Movie theater-style popcorn is often loaded with unhealthy fats and excessive salt, impacting heart health and blood sugar control."
    },
    "Raisin Bread": {
      "notSuitable": "heart,diabetes",
      "reason":
          "While containing raisins which are healthy, many varieties contain added sugars and refined flour, impacting blood sugar levels and heart health."
    },
    "Roll Bread": {
      "notSuitable": "heart,diabetes",
      "reason":
          "Often made with refined flour and may contain added sugars, contributing to blood sugar spikes and potential heart issues."
    },
    "Shortcake": {
      "notSuitable": "heart,diabetes",
      "reason":
          "High in sugar and refined carbohydrates, impacting blood sugar levels and potentially contributing to heart issues."
    },
    "Spam Musubi": {
      "notSuitable": "heart",
      "reason":
          "Processed meat high in sodium and unhealthy fats, contributing to heart disease risk."
    },
    "Steak": {
      "notSuitable": "heart",
      "reason":
          "High in saturated fats, elevating cholesterol levels and potentially impacting heart health."
    },
    "Stew": {
      "notSuitable": "heart",
      "reason":
          "Depending on preparation, can contain high-fat meats contributing to increased cholesterol levels and heart issues."
    },
    "Tiramisu": {
      "notSuitable": "heart,diabetes",
      "reason":
          "High in sugar, saturated fats from cream, and refined carbohydrates, impacting cholesterol levels and blood sugar control."
    },
    "Waffle": {
      "notSuitable": "heart,diabetes",
      "reason":
          "Made with refined flour and often topped with sugary syrups, leading to rapid spikes in blood sugar. The use of butter and unhealthy oils contributes to saturated fat intake, impacting heart health."
    },
  };

  Map<String, String>? getFoodInformation(
      String foodName, String medicalCondition) {
    final foodData = foodInformation[foodName];

    if (foodData != null) {
      final notSuitableFor = foodData["notSuitable"] ?? "";
      final conditions = notSuitableFor.split(",");

      if (conditions.contains(medicalCondition.toLowerCase())) {
        return foodData;
      }
    }
    return null;
  }
}
