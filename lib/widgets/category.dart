import 'package:flutter/material.dart';
import 'package:project_farm_shop/helper/themes.dart';
import 'package:project_farm_shop/routes/routes.dart';
import 'package:project_farm_shop/views/categories/category.dart';
import 'package:transparent_image/transparent_image.dart';

class CategoryWidget extends StatelessWidget {
  final List<Category> items;

  CategoryWidget({required this.items});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
          children: items.map((item) {
        return InkWell(
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: item.image!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 3),
                                blurRadius: 6,
                                color: Themes.shadow)
                          ]),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(item.name!,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Themes.brown)))
                  ])),
          onTap: () {
            Navigator.pushNamed(context, Routes.products, arguments: item.name);
          },
        );
      }).toList()),
    );
  }
}
