import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../services/api.dart';
import '../widgets/custom_app_bar.dart';

class NewsDetailScreen extends StatelessWidget {
  final String newsId;
  final _apiService = ApiService();

  NewsDetailScreen({super.key, required this.newsId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(showBackButton: true),
      body: FutureBuilder<NewsDetail>(
        future: _apiService.getNewsDetail(newsId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Hata: ${snapshot.error}'),
            );
          }

          if (snapshot.hasData) {
            final news = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Haber görseli
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      news.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Kategori ve tarih
                        Row(
                          children: [
                            Text(
                              news.categoryName,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '•',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _formatDate(news.publishDate),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Başlık
                        Text(
                          news.title,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 16),

                        // İçerik
                        Html(data: news.content),
                        const SizedBox(height: 16),

                        // Etiketler
                        Wrap(
                          spacing: 8,
                          children: news.tags.map((tag) {
                            return Chip(label: Text(tag));
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}