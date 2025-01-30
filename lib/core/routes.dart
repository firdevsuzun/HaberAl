import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/loading_screen.dart';
import '../screens/home_screen.dart';
import '../screens/category_screen.dart';
import '../screens/news_detail_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/loading',
  routes: [
    GoRoute(
      path: '/loading',
      builder: (context, state) => const LoadingScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/category/:categoryId',
      builder: (context, state) => CategoryScreen(
        categoryId: state.pathParameters['categoryId'] ?? '',
        categoryName: state.extra as String?, // Kategori adını extra parametre olarak geçebilirsiniz
      ),
    ),
    GoRoute(
      path: '/news/:id',
      builder: (context, state) => NewsDetailScreen(
        newsId: state.pathParameters['id'] ?? '',
      ),
    ),
  ],
);