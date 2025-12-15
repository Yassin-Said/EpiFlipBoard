import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import 'package:epiflipboard/models/posts.dart';
import 'package:epiflipboard/tools/flip_widget.dart';

// ============================================
// PAGE FEED PRINCIPALE
// ============================================
class FeedPage extends StatefulWidget {
  final List<Post>? posts; // Optionnel, si null on utilise des données d'exemple

  const FeedPage({super.key, this.posts});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> with TickerProviderStateMixin {
  late PageController _pageController;
  late List<Post> _posts;
  int _currentPage = 0;
  
  // Catégories
  final List<String> _categories = [
    "FOR YOU",
    "DAILY EDITION",
    "TRENDING",
  ];
  int _selectedCategory = 0;

  @override
  void initState() {
    super.initState();
    _posts = widget.posts ?? _getDefaultPosts();
    _pageController = PageController();
    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Posts par défaut
  List<Post> _getDefaultPosts() {
    return [
      Post(
        title: "The 50 Best Albums of 2025: Staff Picks",
        source: "billboard.com",
        category: "Music",
        timeAgo: "4d",
        imageUrl: "https://via.placeholder.com/600x400/FF6B9D/FFFFFF?text=Albums+2025",
        description: "Our staff's favorite albums from the year that was. Eric Church, Evangeline vs. The Machine Eric Church...",
        likes: 32,
        comments: 1,
        flips: 72,
      ),
      Post(
        title: "Voici les cadeaux les plus tendance sur toutes les listes de vœux en...",
        source: "Tech Gadget Trend",
        category: "Tech",
        timeAgo: "2h",
        imageUrl: "https://via.placeholder.com/600x400/4A90E2/FFFFFF?text=Tech+Gadgets",
        description: "Les meilleurs gadgets technologiques de la saison.",
        likes: 156,
        comments: 23,
        flips: 89,
      ),
      Post(
        title: "Very, Very Unmerry",
        source: "Yahoo Lifestyle",
        category: "Lifestyle",
        timeAgo: "1d",
        imageUrl: "https://via.placeholder.com/600x400/7ED321/FFFFFF?text=Holiday+Stories",
        description: "A collection of holiday stories that didn't go as planned.",
        likes: 245,
        comments: 45,
        flips: 123,
      ),
      Post(
        title: "Yes, Chrismukkah Is Real—Here's What to Know",
        source: "rd.com",
        category: "Culture",
        timeAgo: "3d",
        imageUrl: "https://via.placeholder.com/600x400/F5A623/FFFFFF?text=Chrismukkah",
        description: "The celebration that combines Christmas and Hanukkah traditions.",
        likes: 89,
        comments: 12,
        flips: 56,
      ),
      Post(
        title: "The 50 greatest innovations of 2025",
        source: "Popular Science",
        category: "Science",
        timeAgo: "3d",
        imageUrl: "https://via.placeholder.com/600x400/9013FE/FFFFFF?text=Innovations",
        description: "From AI breakthroughs to sustainable tech, the innovations that shaped 2025.",
        likes: 456,
        comments: 78,
        flips: 234,
      ),
    ];
  }

  void _changeCategory(int index) {
    setState(() {
      _selectedCategory = index;
      _currentPage = 0;
    });
    _pageController.jumpToPage(0);
    
    // Ici tu pourras charger les posts de la catégorie depuis ton API
    // await loadPostsByCategory(_categories[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header avec catégories
            _buildHeader(),
            
            // Feed avec effet flip
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: _posts.length,
                itemBuilder: (context, index) {
                  return FlipPageView(
                    post: _posts[index],
                    pageController: _pageController,
                    currentIndex: index,
                    currentPage: _pageController.page ?? 0,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          // Barre de navigation avec catégories
          SizedBox(
            height: 60,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final isSelected = _selectedCategory == index;
                      return GestureDetector(
                        onTap: () => _changeCategory(index),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                          child: Text(
                            _categories[index],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.white60,
                              fontSize: 16,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onPressed: () => print("Menu"),
                ),
              ],
            ),
          ),
          
          // Indicateur de catégorie sélectionnée
          Container(
            height: 3,
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: 1 / _categories.length,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width / _categories.length * _selectedCategory + 40,
                ),
                decoration: const BoxDecoration(
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}