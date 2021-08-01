import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_farm_shop/helper/themes.dart';
import 'package:project_farm_shop/services/db.dart';
import 'package:project_farm_shop/widgets/blog.dart';

import 'blog.dart';

class BlogsPage extends StatefulWidget {
  const BlogsPage({Key? key}) : super(key: key);

  @override
  _BlogsPageState createState() => _BlogsPageState();
}

class _BlogsPageState extends State<BlogsPage> {
  @override
  Widget build(BuildContext context) {
    var db = context.watch<DatabaseService>();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          brightness: Brightness.dark,
          title: Text('Blogs', style: GoogleFonts.lato(color: Themes.brown)),
        ),
        body: Container(
            child: FutureBuilder(
                future: db.streamBlogs(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var blogs = snapshot.data as List<Blog>;
                    if (blogs.length > 0) {
                      return ListView(
                          children: blogs
                              .map((item) => BlogWidget(item: item))
                              .toList());
                    }
                  }
                  return SizedBox();
                })));
  }
}
