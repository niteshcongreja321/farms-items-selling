import 'package:flutter/material.dart';
import 'package:project_farm_shop/helper/themes.dart';

class PaginationDot extends StatelessWidget {
  const PaginationDot({
    Key? key,
    this.isCurrent = false,
  }) : super(key: key);

  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
          color: isCurrent ? Themes.brown : Themes.brownLight,
          borderRadius: BorderRadius.circular(5)),
    );
  }
}
