import 'package:flutter/material.dart';
import '../services/api.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/news_list.dart';

class CategoryScreen extends StatelessWidget {
  final String categoryId;
  final String? categoryName;

  const CategoryScreen({
    super.key,
    required this.categoryId,
    this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBackButton: true,
        title: categoryName, // Kategori adını göster
      ),
      body: NewsList(
        categoryId: categoryId,
        showFeatured: false, // Kategori sayfasında featured haber göstermeye gerek yok
      ),
    );
  }
}