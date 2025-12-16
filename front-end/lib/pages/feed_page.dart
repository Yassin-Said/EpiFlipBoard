import 'package:flutter/material.dart';
import 'package:epiflipboard/models/post.dart';
import 'package:epiflipboard/tools/flip_widget.dart';

// ============================================
// PAGE FEED PRINCIPALE
// ============================================
class FeedPage extends StatefulWidget {
  final List<Post>? posts;

  const FeedPage({super.key, this.posts});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> with TickerProviderStateMixin {
  late PageController _pageController;
  late List<Post> _posts;
  int _currentPage = 0;
  
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

  List<Post> _getDefaultPosts() {
    return [
      Post(
        title: "Nobody Actually Dies From Old Age? Autopsy Studies Reveal What Really Kills Us",
        source: "studyfinds.org",
        category: "LIFE SCIENCES",
        timeAgo: "15h",
        imageUrl: "https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=800",
        description: "The 'Hallmarks of Aging' Framework Has A Major Problem That Nobody Talked About Until Now In A Nutshell Nobody dies of \"old age\": Autopsy studies across species reveal that specific diseases (heart...",
        likes: 41,
        comments: 1,
        flips: 108,
        authorName: "Donnie",
        authorAvatar: null,
      ),
      Post(
        title: "Maison bois livrée et montée",
        source: "Greenkub",
        category: "Advertisement",
        timeAgo: "Sponsored",
        imageUrl: "https://images.unsplash.com/photo-1518780664697-55e3ad937233?w=800",
        description: "Maison en bois livrée et montée par nos experts, sans surcoûts cachés.",
        likes: 0,
        comments: 0,
        flips: 0,
        authorName: "Greenkub",
        authorAvatar: null,
        isAd: true,
      ),
      Post(
        title: "The 50 Best Albums of 2025: Staff Picks",
        source: "billboard.com",
        category: "Music",
        timeAgo: "4d",
        imageUrl: "https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=800",
        description: "Our staff's favorite albums from the year that was. Eric Church, Evangeline vs. The Machine Eric Church...",
        likes: 32,
        comments: 1,
        flips: 72,
        authorName: "Flipboard",
        authorAvatar: null,
      ),
      Post(
        title: "Very, Very Unmerry",
        source: "Yahoo Lifestyle",
        category: "Lifestyle",
        timeAgo: "1d",
        imageUrl: "https://images.unsplash.com/photo-1512909006721-3d6018887383?w=800",
        description: "A collection of holiday stories that didn't go as planned.",
        likes: 245,
        comments: 45,
        flips: 123,
        authorName: "Yahoo Lifestyle",
        authorAvatar: null,
      ),
      Post(
        title: "The 50 greatest innovations of 2025",
        source: "Popular Science",
        category: "Science",
        timeAgo: "3d",
        imageUrl: "https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800",
        description: "From AI breakthroughs to sustainable tech, the innovations that shaped 2025.",
        likes: 456,
        comments: 78,
        flips: 234,
        authorName: "Popular Science",
        authorAvatar: null,
      ),
    ];
  }

  void _changeCategory(int index) {
    setState(() {
      _selectedCategory = index;
      _currentPage = 0;
    });
    _pageController.jumpToPage(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
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
                    currentPage: _currentPage.toDouble(),
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