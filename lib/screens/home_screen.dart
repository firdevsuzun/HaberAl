import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/category_list.dart';
import '../widgets/news_list.dart'; // NewsList widget'ı için import ekleyelim

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CustomAppBar(
        showBackButton: false, // null yerine false kullanıyoruz
      ),
      body: Column(
        children: [
          // Kategoriler
          CategoryListLoader(
            selectedCategoryId: _selectedCategoryId,
            onCategorySelected: (categoryId) {
              setState(() {
                _selectedCategoryId = categoryId.isEmpty ? null : categoryId;
              });
            },
          ),
          
          // Haberler listesi
          Expanded(
            child: NewsListLoader(
              categoryId: _selectedCategoryId,
              showFeatured: _selectedCategoryId == null,
            ),
          ),
        ],
      ),
    );
  }
}