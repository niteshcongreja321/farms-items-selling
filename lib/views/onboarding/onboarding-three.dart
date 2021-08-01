import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project_farm_shop/helper/themes.dart';
import 'package:project_farm_shop/widgets/pagination1.dart';

class OnBoardingThree extends StatelessWidget {
  const OnBoardingThree({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
        child: Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(30),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Themes.shadow, blurRadius: 30, offset: Offset(0, 5))
          ],
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(36))),
      child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        SvgPicture.asset(
          'assets/images/onboarding3.svg',
          fit: BoxFit.fitWidth,
        ),
        SizedBox(height: 50),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 45),
          child: Text('Delivered within 18 hours of Harvest',
              textAlign: TextAlign.center,
              style: TextStyle(color: Themes.brown, fontSize: 20)),
        ),
        SizedBox(height: 75),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PaginationDot(),
            SizedBox(width: 10),
            PaginationDot(),
            SizedBox(width: 10),
            PaginationDot(),
            SizedBox(width: 10),
            PaginationDot(isCurrent: true)
          ],
        )
      ]),
    ));
  }
}
