import 'package:calpal/screens/components/text_styling.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MealsViewPage extends StatelessWidget {
  // Get meals from parameter
  const MealsViewPage({Key? key, required this.meals}) : super(key: key);

  final String meals;

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          // Text('Content for ${date.toLocal()}'),
          Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // border: Border.all(color: Colors.black, width: 1),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5, bottom: 5, top: 5),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: titleText(
                    text: meals,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),

                // Food item
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 3,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Fluttertoast.showToast(
                            msg: "This is Center Short Toast",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      },
                      child: Row(children: [
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              // color: Colors.black,
                            ),
                            child: Image(
                                image: AssetImage(
                                    'assets/icons/calpal_icon.png'))), // Food image
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                children: [
                                  Text(
                                    "Brown Bread", // Food name
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              Wrap(
                                children: [
                                  Text(
                                    "172"
                                    " g - "
                                    "440"
                                    " Cal", // Food weight and calories
                                    style:
                                        TextStyle(fontWeight: FontWeight.w200),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ]),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
