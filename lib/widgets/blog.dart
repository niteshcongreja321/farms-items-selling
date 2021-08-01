import 'package:flutter/material.dart';
import 'package:project_farm_shop/helper/themes.dart';
import 'package:project_farm_shop/views/blog/blog.dart';
import 'package:transparent_image/transparent_image.dart';

class BlogWidget extends StatelessWidget {
  final Blog item;
  const BlogWidget({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: Column(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage, image: item.image!),
        ),
        Padding(
            padding: EdgeInsets.all(12),
            child: Text(item.title ?? '',
                style: TextStyle(color: Themes.textColor, fontSize: 16)))
      ]),
    );
  }
}
