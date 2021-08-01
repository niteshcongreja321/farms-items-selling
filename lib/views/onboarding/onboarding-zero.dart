import 'package:flutter/material.dart';
import 'package:project_farm_shop/helper/themes.dart';
import 'package:project_farm_shop/widgets/pagination1.dart';

class OnBoardingZero extends StatelessWidget {
  const OnBoardingZero({Key? key}) : super(key: key);

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
          Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.fitWidth,
          ),
          SizedBox(height: 90),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 45, vertical: 12),
            child: Text('Welcome to Shatayushi !',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Themes.brown,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
          ),
          Text('Our first step toward healthy lifestyle.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Themes.brown,
                  fontStyle: FontStyle.italic,
                  fontSize: 20)),
          SizedBox(height: 75),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PaginationDot(isCurrent: true),
              SizedBox(width: 10),
              PaginationDot(),
              SizedBox(width: 10),
              PaginationDot(),
              SizedBox(width: 10),
              PaginationDot()
            ],
          )
        ]),
      ),
    );
  }
}
