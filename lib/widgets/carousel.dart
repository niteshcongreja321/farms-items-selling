import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:project_farm_shop/helper/themes.dart';
import 'package:transparent_image/transparent_image.dart';

class CarouselWidget extends StatelessWidget {
  final List<String> items;

  CarouselWidget({required this.items});

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    var size = MediaQuery.of(context).size;
    return CarouselSlider(
        options: CarouselOptions(
          height: orientation == Orientation.portrait ? 200 : 300,
          viewportFraction: orientation == Orientation.portrait ? 1 : 0.6,
          aspectRatio: 1.0,
          initialPage: 0,
          enableInfiniteScroll: true,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 3),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
        ),
        items: items.map((e) {
          return Builder(builder: (context) {
            return Container(
                width: orientation == Orientation.portrait
                    ? size.width
                    : size.width / 2,
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: Themes.shadow2,
                      blurRadius: 6,
                      offset: Offset(0, 3))
                ]),
                child: singleImage(orientation, e));
          });
        }).toList());
  }

  singleImage(Orientation orientation, String e) {
    return ClipRRect(
      child: FadeInImage.memoryNetwork(
        placeholder: kTransparentImage,
        image: e,
        fit: BoxFit.fill,
      ),
      borderRadius: BorderRadius.circular(0),
    );
  }
}
