import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../data/onboard_model.dart';
import '../theme/app_colors.dart';
import '../theme/custom_app_bar.dart';
import 'navigation_screen.dart';

class OnBoard extends StatefulWidget {
  const OnBoard({Key? key}) : super(key: key);

  @override
  State<OnBoard> createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  int currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  _storeOnBoardInfo() async {
    int isView = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onBoard', isView);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(context, 'Mon budget'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: PageView.builder(
          controller: _pageController,
          itemCount: screens.length,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
          itemBuilder: (context, index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(screens[index].image),
                SizedBox(
                  height: 10.0,
                  child: ListView.builder(
                    itemCount: screens.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3.0),
                            width: currentIndex == index ? 25.0 : 8.0,
                            height: 8.0,
                            decoration: BoxDecoration(
                                color: currentIndex == index
                                    ? Colors.blueAccent
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(10.0)),
                          )
                        ],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        screens[index].text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600, color: Theme.of(context).primaryColor),
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        screens[index].description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18, color: AppColors.grey),
                      ),
                      const SizedBox(height: 20.0),
                      InkWell(
                        onTap: () async {
                          if (index == screens.length - 1) {
                            await _showReviewDialog(context);
                          }
                          _pageController.nextPage(
                              duration: const Duration(microseconds: 300),
                              curve: Curves.bounceIn);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 10.0),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Continuer',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).primaryColor,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      // const SizedBox(height: 10.0),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  _showReviewDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double rating = 0;

        return Center(
          child: Container(
            constraints: const BoxConstraints(
              maxHeight: 300,
            ),
            child: AlertDialog(
              title: const Text('Vous appréciez lapplication?'),
              content: Column(
                children: [
                  const Text('Souhaitez-vous laisser un commentaire?'),
                  const SizedBox(height: 10),
                  RatingBar.builder(
                    initialRating: rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemSize: 40,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (value) {
                      rating = value;
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    await _storeOnBoardInfo();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NavigationScreen()));
                  },
                  child: const Text('Non'),
                ),
                TextButton(
                  onPressed: () async {
                    await _storeOnBoardInfo();
                    saveUserChoice(true);
                    saveUserRating(rating);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NavigationScreen()));
                  },
                  child: const Text('Oui'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void saveUserChoice(bool userWantsToReview) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('userWantsToReview', userWantsToReview);
  }

  void saveUserRating(double rating) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('userRating', rating);
  }
}
