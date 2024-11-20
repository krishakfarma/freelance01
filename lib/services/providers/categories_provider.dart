import 'package:flutter/material.dart';

class Category {
  String label;
  String imgUrl;
  Category({
    required this.label,
    required this.imgUrl,
  });
}

class CategoriesProvider extends ChangeNotifier {
  final List<Category> _categories = [
    Category(
        label: "Biography",
        imgUrl: "https://cdn3.iconfinder.com/data/icons/resume-linear-outline/300/213558845Untitled-3-512.png"),
    Category(label: "Computer", imgUrl: "https://i.pinimg.com/736x/e5/ae/a1/e5aea16b2d600c2bdd92b7ce26b3edee.jpg"),
    Category(label: "Thriller", imgUrl: "https://cdn.pixabay.com/photo/2024/01/16/21/03/ai-generated-8513081_1280.jpg"),
    Category(
        label: "Adventure",
        imgUrl:
            "https://www.downunderendeavours.com/wp-content/uploads/2016/05/NZ-family-adventure-900x600-2548-Routeburn-Track-Fiordland-Stewart-Nimmo.jpg"),
    Category(
        label: "Horror",
        imgUrl:
            "https://i0.wp.com/darklongbox.com/wp-content/uploads/2024/01/sub-genres-of-horror.jpg?fit=960%2C768&ssl=1"),
    Category(
        label: "Travel", imgUrl: "https://www.financialexpress.com/wp-content/uploads/2021/09/savaari1200.jpg?w=440"),
    Category(
        label: "Mathematics",
        imgUrl:
            "https://img.freepik.com/free-vector/maths-realistic-chalkboard-background_23-2148159115.jpg?semt=ais_hybrid"),
    Category(
        label: "Science",
        imgUrl: "https://centralnorthlandsciencefair.co.nz/wp-content/uploads/2020/01/SCIENCE-fair-category.png"),
    Category(
        label: "Sports",
        imgUrl:
            "https://media.istockphoto.com/id/1188462138/photo/variety-of-sport-accessories-on-wooden-surface.jpg?s=612x612&w=0&k=20&c=y2l7DYNkxbVteZy-Kx_adCzm-soTRbiEypje4j8ENe0="),
  ];
  List<Category> get categories => _categories;
}
