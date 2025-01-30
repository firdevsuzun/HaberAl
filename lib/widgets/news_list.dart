import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/api.dart';
import 'news_card.dart';

class NewsList extends StatefulWidget {
  final String? categoryId;
  final bool showFeatured;
  final ScrollController? scrollController;

  const NewsList({
    super.key,
    this.categoryId,
    this.showFeatured = true,
    this.scrollController,
  });

  @override
  State<NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  final _apiService = ApiService();
  final List<News> _news = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  final int _pageSize = 10;

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    _scrollController.addListener(_scrollListener);
    _loadInitialNews();
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreNews();
    }
  }

  Future<void> _loadInitialNews() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final news = widget.categoryId != null
          ? await _apiService.getNewsByCategory(
              widget.categoryId!,
              page: _currentPage,
              limit: _pageSize,
            )
          : await _apiService.getNews(
              page: _currentPage,
              limit: _pageSize,
            );

      setState(() {
        _news.clear();
        _news.addAll(news);
        _isLoading = false;
        _hasMore = news.length == _pageSize;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Haberler yüklenirken hata oluştu: $e')),
        );
      }
    }
  }

  Future<void> _loadMoreNews() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final news = widget.categoryId != null
          ? await _apiService.getNewsByCategory(
              widget.categoryId!,
              page: _currentPage + 1,
              limit: _pageSize,
            )
          : await _apiService.getNews(
              page: _currentPage + 1,
              limit: _pageSize,
            );

      setState(() {
        _news.addAll(news);
        _currentPage++;
        _isLoading = false;
        _hasMore = news.length == _pageSize;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Daha fazla haber yüklenirken hata oluştu: $e')),
        );
      }
    }
  }

  Future<void> _refreshNews() async {
    _currentPage = 1;
    await _loadInitialNews();
  }

  @override
  Widget build(BuildContext context) {
    if (_news.isEmpty && _isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_news.isEmpty && !_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.newspaper,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'Haber bulunamadı',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _refreshNews,
              child: const Text('Yenile'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshNews,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(top: 8),
        itemCount: _news.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _news.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final news = _news[index];
          final bool isFeatured = widget.showFeatured && index == 0;


        },
      ),
    );
  }
}

// Haber listesini yüklemek için kullanılabilecek bir wrapper widget
class NewsListLoader extends StatelessWidget {
  final String? categoryId;
  final bool showFeatured;
  final ScrollController? scrollController;

  const NewsListLoader({
    super.key,
    this.categoryId,
    this.showFeatured = true,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return NewsList(
      categoryId: categoryId,
      showFeatured: showFeatured,
      scrollController: scrollController,
    );
  }
}