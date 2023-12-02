import 'package:calpal/controllers/food_controller.dart';
import 'package:calpal/screens/components/bottom_navigation.dart';
import 'package:calpal/screens/components/constants.dart';
import 'package:calpal/screens/food/food_detail.dart';
import 'package:calpal/screens/food/food_detector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

class FoodView extends StatefulWidget {
  const FoodView({Key? key}) : super(key: key);

  @override
  State<FoodView> createState() => _FoodViewState();
}

class _FoodViewState extends State<FoodView> {
  final controller = Get.put(FoodController());

  @override
  void initState() {
    super.initState();
    controller.filterSuggestions("");
  }

  @override
  void dispose() {
    controller.searchController.text = "";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 20, left: 5),
          child: Text(
            'Meals',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w800, fontSize: 25),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
        child: Column(
          children: [
            buildSearchBar(),
            const SizedBox(height: 15),
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  // Return circular progress indicator while loading
                  shrinkWrap: true,
                  itemCount: controller.filteredSuggestions.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        buildListItem(
                            context,
                            controller.filteredSuggestions[index].name
                                .toString()),
                        const SizedBox(height: 20),
                      ],
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 2),
    );
  }

  Widget buildSearchBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextField(
            controller: controller.searchController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.withOpacity(0.1),
              hintText: "Search...",
              hintStyle: const TextStyle(
                color: Color.fromRGBO(60, 60, 67, 0.6),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(10),
              prefixIcon: const Icon(Icons.search),
            ),
            onChanged: (query) {
              controller.filterSuggestions(query);
            },
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const FoodDetector();
            }));
          },
          child: const SizedBox(
            width: 40,
            height: 40,
            child: Icon(
              HeroiconsSolid.camera,
              color: primaryColor,
            ),
          ),
        )
      ],
    );
  }

  Widget buildListItem(BuildContext context, String text) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return FoodDetail(foodName: text);
        }));
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                clipBehavior: Clip.none,
                width: MediaQuery.of(context).size.width * 0.6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: text == "Create food"
                            ? Colors.grey.withOpacity(0.1)
                            : Colors.transparent,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: text == "Create food"
                          ? const Icon(
                              HeroiconsSolid.plus,
                              color: primaryColor,
                            )
                          : Image.asset(
                              controller.getFoodImagePath(text),
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(width: 20),
                    if (text == "Create food")
                      SizedBox(
                        width: 100,
                        child: Text(
                          text,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      )
                    else
                      Flexible(
                        child: Text(
                          text,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const Spacer(),
              const Icon(HeroiconsSolid.chevronRight),
            ],
          ),
        ],
      ),
    );
  }
}
