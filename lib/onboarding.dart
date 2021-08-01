import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_farm_shop/routes/routes.dart';
import 'package:project_farm_shop/views/onboarding/onboarding-one.dart';
import 'package:project_farm_shop/views/onboarding/onboarding-three.dart';
import 'package:project_farm_shop/views/onboarding/onboarding-two.dart';
import 'package:project_farm_shop/views/onboarding/onboarding-zero.dart';
import 'package:provider/provider.dart';

import 'helper/themes.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  var pageController = PageController();
  var pages = [
    OnBoardingZero(),
    OnBoardingOne(),
    OnBoardingTwo(),
    OnBoardingThree()
  ];

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
  }

  void onPageChanged(int page) {
    Provider.of<OnBoardingModel>(context, listen: false).updatePosition(page);
  }

  @override
  Widget build(BuildContext context) {
    var model = context.watch<OnBoardingModel>();

    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
                child: PageView(
                    children: pages,
                    scrollDirection: Axis.horizontal,
                    controller: pageController,
                    onPageChanged: onPageChanged)),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        primary: Themes.green,
                        minimumSize: Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(36))),
                    onPressed: () {
                      if (model.currentPosition < 3) {
                        onPageChanged(model.currentPosition + 1);
                        pageController.jumpToPage(model.currentPosition);
                      } else {
                        Navigator.pushNamed(context, Routes.signIn);
                      }
                    },
                    icon: Icon(Icons.arrow_forward_rounded),
                    label: Text('NEXT',
                        style: GoogleFonts.lato(fontWeight: FontWeight.bold))))
          ],
        ));
  }
}

class OnBoardingModel extends ChangeNotifier {
  int currentPosition = 0;

  void updatePosition(newPos) {
    currentPosition = newPos;
    print(currentPosition);
    notifyListeners();
  }
}
