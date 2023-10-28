import 'package:calpal/controllers/user_controller.dart';
import 'package:calpal/models/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class UserFormWidget extends StatefulWidget {
  const UserFormWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<UserFormWidget> createState() => _UserFormWidgetState();
}

class _UserFormWidgetState extends State<UserFormWidget> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final controller = Get.put(UserController());
    final uid = FirebaseAuth.instance.currentUser!.uid.toString().trim();

    return Scaffold(
      appBar: AppBar(
        title: Text('User Form'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Text(uid, style: TextStyle(fontSize: 20)),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: controller.nameController,
                        decoration: const InputDecoration(label: Text('Name')),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: controller.heightController,
                        decoration:
                            const InputDecoration(label: Text('Height')),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: controller.weightController,
                        decoration:
                            const InputDecoration(label: Text('Weight')),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: controller.ageController,
                        decoration: const InputDecoration(label: Text('Age')),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              final user = UserModel(
                                  uid: uid,
                                  name: controller.nameController.text.trim(),
                                  height: double.parse(
                                      controller.heightController.text.trim()),
                                  weight: double.parse(
                                      controller.weightController.text.trim()),
                                  age: int.parse(
                                      controller.ageController.text.trim()));
                              UserController.instance.createUserInfo(user);
                              Fluttertoast.showToast(
                                  msg: "User created successfully",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor:
                                      Colors.green.withOpacity(0.1),
                                  textColor: Colors.green,
                                  fontSize: 16.0);
                            }
                          },
                          child: Text('Submit'))
                    ],
                  )),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: FutureBuilder<List<UserModel>>(
                future: UserController.instance.getAllUserData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              ListTile(
                                iconColor: Colors.lightBlue,
                                tileColor: Colors.red.withOpacity(0.1),
                                title:
                                    Text("Name: ${snapshot.data![index].name}"),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Height: ${snapshot.data![index].height}"),
                                    Text(
                                        "Weight: ${snapshot.data![index].weight}"),
                                    Text("Age: ${snapshot.data![index].age}"),
                                  ],
                                ),
                              ),
                            ],
                          );
                        });
                  } else {
                    return Container(
                        child: Text('No data',
                            style: TextStyle(fontSize: 20, color: Colors.red)));
                  }
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text("=============End of the page======="),
            Container(
              height: 300,
              color: Colors.red,
            )
          ],
        ),
      ),
    );
  }
}
