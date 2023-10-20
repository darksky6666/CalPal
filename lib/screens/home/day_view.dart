import 'package:calpal/screens/home/component/text_styling.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DayViewPage extends StatelessWidget {
  final DateTime date;

  DayViewPage({required this.date});

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          // Text('Content for ${date.toLocal()}'),
          InkWell(
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
        child: Container(
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
                      text: 'Breakfast',
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    child: Row(children: [
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            // color: Colors.black,
                          ),
                          child: Image(
                              image:
                                  AssetImage('assets/icons/calpal_icon.png'))),
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
                                  "Brown Bread",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                            Wrap(
                              children: [
                                Text(
                                  "172" " g - " "440" " Cal",
                                  style: TextStyle(fontWeight: FontWeight.w200),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ]),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
