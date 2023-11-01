import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String name;
  final double height;
  final double weight;
  final int age;
  final String? biologicalSex;
  final String? medicalCondition;
  // final double targetWeight;
  // final DateTime targetDate;

  const UserModel({
    required this.name,
    required this.height,
    required this.weight,
    required this.age,
    this.biologicalSex,
    this.medicalCondition,
    // required this.targetWeight,
    // required this.targetDate,
  });

  // Convert a User into a Map object
  toJson(){
    return {
      'name': name,
      'height': height,
      'weight': weight,
      'age': age,
      'biologicalSex': biologicalSex,
      'medicalCondition': medicalCondition,
      // 'targetWeight': targetWeight,
      // 'targetDate': targetDate,
    };
  }


  // Get the data from the snapshot
  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data()!;
    return UserModel(
      name: data['name'],
      height: data['height'],
      weight: data['weight'],
      age: data['age'],
      biologicalSex: data['biologicalSex'],
      medicalCondition: data['medicalCondition'],
      // targetWeight: data['targetWeight'],
      // targetDate: data['targetDate'],
    );
  }
}
