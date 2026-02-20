import 'dart:async';
import 'package:flutter/material.dart';
import 'package:epiflipboard/models/post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:epiflipboard/pages/feed_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController _searchController = TextEditingController();
  late final PageController _pageController;

  List<DetailedPost> _allPosts = [];
  List<DetailedPost> _filteredPosts = [];

  bool _isLoading = true;
  Timer? _debounce;
  double _currentPageValue = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _pageController.addListener(() {
      setState(() {
        _currentPageValue = _pageController.page ?? 0.0;
      });
    });

    _fetchPosts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _fetchPosts() async {
    try {
      final response = await http.get(
        Uri.parse("https://epiflipboard-iau1.onrender.com/allPosts"),
      );

      final data = jsonDecode(response.body);

      final posts = (data["posts"] as List)
          .map((e) => DetailedPost.fromBackendJson(e))
          .toList();

      setState(() {
        _allPosts = posts;
        _filteredPosts = posts;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Explore fetch error: $e");
      setState(() => _isLoading = false);
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      final q = query.toLowerCase();

      setState(() {
        _filteredPosts = _allPosts.where((post) {
          return post.title.toLowerCase().contains(q);
        }).toList();
      });

      if (_pageController.hasClients && _filteredPosts.isNotEmpty) {
        _pageController.jumpToPage(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),   // 🔝 Header
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.red),
                    )
                  : _filteredPosts.isEmpty
                      ? _buildEmptyState()
                      : PageView.builder(
                          controller: _pageController,
                          scrollDirection: Axis.vertical,
                          itemCount: _filteredPosts.length,
                          itemBuilder: (context, index) {
                            return FlipPostCard(
                              post: _filteredPosts[index],
                              currentIndex: index,
                              currentPage: _currentPageValue,
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      color: Colors.black,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.white60),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: _onSearchChanged,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Search articles...",
                  hintStyle: TextStyle(color: Colors.white60),
                  border: InputBorder.none,
                ),
              ),
            ),
            if (_searchController.text.isNotEmpty)
              GestureDetector(
                onTap: () {
                  _searchController.clear();
                  _onSearchChanged("");
                },
                child: const Icon(Icons.close, color: Colors.white60),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        "No results found",
        style: TextStyle(color: Colors.white60, fontSize: 18),
      ),
    );
  }
}
