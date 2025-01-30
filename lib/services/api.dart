import 'dart:convert';
import "package:http/http.dart" as http;
import '../core/storage.dart';

class ApiService {
  static const String baseUrl = 'https://api.example.com/v1'; // API URL'nizi buraya ekleyin

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  Future<Map<String, String>> _getHeaders() async {
    final token = await AppStorage.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // API isteklerinde oluşabilecek hataları yönetmek için
  Future<T> _handleResponse<T>(Future<http.Response> Function() request) async {
    try {
      final response = await request();
      final data = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data as T;
      } else {
        throw ApiException(
          message: data['message'] ?? 'Bir hata oluştu',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException(
        message: 'Bağlantı hatası: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  // Haber listesini getir
  Future<List<News>> getNews({int page = 1, int limit = 10}) async {
    return _handleResponse(() async {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/news?page=$page&limit=$limit'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> newsJson = json.decode(response.body)['data'];
        return newsJson.map((json) => News.fromJson(json)).toList();
      }
      throw ApiException(message: 'Haberler yüklenemedi', statusCode: response.statusCode);
    });
  }

  // Kategori listesini getir
  Future<List<Category>> getCategories() async {
    return _handleResponse(() async {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/categories'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> categoriesJson = json.decode(response.body)['data'];
        return categoriesJson.map((json) => Category.fromJson(json)).toList();
      }
      throw ApiException(message: 'Kategoriler yüklenemedi', statusCode: response.statusCode);
    });
  }

  // Kategori bazlı haber listesi
  Future<List<News>> getNewsByCategory(String categoryId, {int page = 1, int limit = 10}) async {
    return _handleResponse(() async {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/categories/$categoryId/news?page=$page&limit=$limit'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> newsJson = json.decode(response.body)['data'];
        return newsJson.map((json) => News.fromJson(json)).toList();
      }
      throw ApiException(message: 'Kategori haberleri yüklenemedi', statusCode: response.statusCode);
    });
  }

  // Haber detayını getir
  Future<NewsDetail> getNewsDetail(String newsId) async {
    return _handleResponse(() async {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/news/$newsId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> newsJson = json.decode(response.body)['data'];
        return NewsDetail.fromJson(newsJson);
      }
      throw ApiException(message: 'Haber detayı yüklenemedi', statusCode: response.statusCode);
    });
  }

  // Popüler içerikleri getir
  Future<List<News>> getPopularNews({int limit = 10}) async {
    return _handleResponse(() async {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/news/popular?limit=$limit'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> newsJson = json.decode(response.body)['data'];
        return newsJson.map((json) => News.fromJson(json)).toList();
      }
      throw ApiException(message: 'Popüler haberler yüklenemedi', statusCode: response.statusCode);
    });
  }
}

// API Hata sınıfı
class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException({required this.message, required this.statusCode});

  @override
  String toString() => message;
}

// Model sınıfları
class News {
  final String id;
  final String title;
  final String summary;
  final String imageUrl;
  final DateTime publishDate;
  final String categoryId;
  final String categoryName;

  News({
    required this.id,
    required this.title,
    required this.summary,
    required this.imageUrl,
    required this.publishDate,
    required this.categoryId,
    required this.categoryName,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'],
      title: json['title'],
      summary: json['summary'],
      imageUrl: json['image_url'],
      publishDate: DateTime.parse(json['publish_date']),
      categoryId: json['category_id'],
      categoryName: json['category_name'],
    );
  }
}

class NewsDetail extends News {
  final String content;
  final List<String> tags;
  final int viewCount;

  NewsDetail({
    required super.id,
    required super.title,
    required super.summary,
    required super.imageUrl,
    required super.publishDate,
    required super.categoryId,
    required super.categoryName,
    required this.content,
    required this.tags,
    required this.viewCount,
  });

  factory NewsDetail.fromJson(Map<String, dynamic> json) {
    return NewsDetail(
      id: json['id'],
      title: json['title'],
      summary: json['summary'],
      imageUrl: json['image_url'],
      publishDate: DateTime.parse(json['publish_date']),
      categoryId: json['category_id'],
      categoryName: json['category_name'],
      content: json['content'],
      tags: List<String>.from(json['tags']),
      viewCount: json['view_count'],
    );
  }
}

class Category {
  final String id;
  final String name;
  final String? imageUrl;

  Category({
    required this.id,
    required this.name,
    this.imageUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image_url'],
    );
  }
}