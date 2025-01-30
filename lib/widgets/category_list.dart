import 'package:flutter/material.dart';
import '../services/api.dart';

class CategoryList extends StatelessWidget {
  final List<Category> categories;
  final String? selectedCategoryId;
  final Function(String) onCategorySelected;

  const CategoryList({
    super.key,
    required this.categories,
    required this.onCategorySelected,
    this.selectedCategoryId,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length + 1, // +1 for "Tümü" category
        itemBuilder: (context, index) {
          // "Tümü" kategorisi için özel durum
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CategoryChip(
                label: 'Tümü',
                isSelected: selectedCategoryId == null,
                onTap: () => onCategorySelected(''),
              ),
            );
          }

          final category = categories[index - 1];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CategoryChip(
              label: category.name,
              isSelected: category.id == selectedCategoryId,
              onTap: () => onCategorySelected(category.id),
            ),
          );
        },
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.primaryColor
                : theme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? theme.primaryColor
                  : theme.primaryColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : theme.primaryColor,
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

// Kategorileri yüklemek için kullanılabilecek bir widget
class CategoryListLoader extends StatelessWidget {
  final ApiService _apiService = ApiService();

  CategoryListLoader({
    super.key,
    required this.onCategorySelected,
    this.selectedCategoryId,
  });

  final Function(String) onCategorySelected;
  final String? selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: _apiService.getCategories(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Kategoriler yüklenirken hata oluştu',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const SizedBox(
            height: 40,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return CategoryList(
          categories: snapshot.data!,
          selectedCategoryId: selectedCategoryId,
          onCategorySelected: onCategorySelected,
        );
      },
    );
  }
}