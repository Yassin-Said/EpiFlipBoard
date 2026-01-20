import 'package:flutter/material.dart';
import 'package:epiflipboard/models/post.dart';
import 'package:epiflipboard/models/article.dart';
import 'package:epiflipboard/models/topic_categorie.dart';
// import 'package:epiflipboard/tools/flip_widget.dart';

// ============================================
// PAGE PRINCIPALE FOR YOU
// ============================================
class ForYouPage extends StatefulWidget {
  final Map<String, List<FeaturedArticle>>? featuredByCategory;
  final Map<String, List<DetailedPost>>? postsByCategory;
  final List<Topic>? topics;

  const ForYouPage({
    super.key,
    this.featuredByCategory,
    this.postsByCategory,
    this.topics,
  });

  @override
  State<ForYouPage> createState() => _ForYouPageState();
}

class _ForYouPageState extends State<ForYouPage> {
  final List<String> _categories = [
    "FOR YOU",
    "DAILY EDITION",
    "TRENDING",
    "EXPLORE MORE TOPICS"
  ];
  
  int _selectedCategory = 0;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _categoryScrollController = ScrollController();

  late Map<String, List<FeaturedArticle>> _featuredArticles;
  late Map<String, List<DetailedPost>> _detailedPosts;
  late List<Topic> _topics;

  @override
  void initState() {
    super.initState();
    _featuredArticles = widget.featuredByCategory ?? _getDefaultFeatured();
    _detailedPosts = widget.postsByCategory ?? _getDefaultPosts();
    _topics = widget.topics ?? _getDefaultTopics();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _categoryScrollController.dispose();
    super.dispose();
  }

  Map<String, List<FeaturedArticle>> _getDefaultFeatured() {
    return {
      "FOR YOU": [
        FeaturedArticle(
          title: "\"They are much more challenging animals.\" What is a wolf-dog and how are they different to domestic dogs?",
          source: "discoverwildlife.com",
          imageUrl: "https://images.unsplash.com/photo-1589656966895-2f33e7653819?w=800&h=600&fit=crop",
        ),
        FeaturedArticle(
          title: "The internet's biggest food myths debunked",
          source: "The Independent",
          imageUrl: "https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=800&h=600&fit=crop",
        ),
        FeaturedArticle(
          title: "My ultimate Windows keyboard shortcuts guide",
          source: "ZDNET",
          imageUrl: "https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=800&h=600&fit=crop",
        ),
      ],
      "DAILY EDITION": [
        FeaturedArticle(
          title: "Jerome Powell to attend Supreme Court arguments in case on Trump",
          source: "NBC News",
          imageUrl: "https://images.unsplash.com/photo-1589994965851-a8f479c573a9?w=800&h=600&fit=crop",
        ),
        FeaturedArticle(
          title: "100 vehicles pile up in Michigan crash as snowstorm moves across",
          source: "Associated Press",
          imageUrl: "https://images.unsplash.com/photo-1491146179969-d674118945ff?w=800&h=600&fit=crop",
        ),
      ],
      "TRENDING": [
        FeaturedArticle(
          title: "Comfort Food - Foods that will hit the spot",
          source: "Magazine",
          imageUrl: "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800&h=600&fit=crop",
        ),
      ],
    };
  }

  Map<String, List<DetailedPost>> _getDefaultPosts() {
    return {
      "FOR YOU": [
        DetailedPost(
          title: "'We got lazy and complacent': Swedish pensioners explain how abolishing the wealth tax changed their country",
          source: "The Conversation UK",
          category: "SOCIAL JUSTICE",
          timeAgo: "20h",
          imageUrl: "https://images.unsplash.com/photo-1509023464722-18d996393ca8?w=800",
          description: "For much of the 20th century, Sweden enjoyed a justifiable reputation as one of Europe's most egalitarian countries. Yet over the past two decades, it has transformed into what journalist and author...",
          likes: 46,
          comments: 2,
          flips: 72,
          authorName: "Have A Go",
        ),
        DetailedPost(
          title: "Nobody Actually Dies From Old Age? Autopsy Studies Reveal What Really Kills Us",
          source: "studyfinds.org",
          category: "LIFE SCIENCES",
          timeAgo: "15h",
          imageUrl: "https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=800",
          description: "The 'Hallmarks of Aging' Framework Has A Major Problem That Nobody Talked About Until Now",
          likes: 41,
          comments: 1,
          flips: 108,
          authorName: "Donnie",
        ),
      ],
      "DAILY EDITION": [
        DetailedPost(
          title: "Live. Trump doubles down on Greenland annexation as Europe struggles to coordinate a response",
          source: "Euronews",
          category: "POLITICS",
          timeAgo: "Yesterday",
          imageUrl: "https://images.unsplash.com/photo-1551916158-29b41d2cbb66?w=800",
          description: "European leaders are closing ranks in response to Donald Trump's threat of additional tariffs to for...",
          likes: 234,
          comments: 56,
          flips: 189,
          authorName: "Euronews",
        ),
      ],
    };
  }

  List<Topic> _getDefaultTopics() {
    return [
      Topic(
        name: "LIFESTYLE",
        relatedTopics: ["RELATIONSHIPS", "BEAUTY", "PRODUCTIVITY", "SKINCARE", "COOKING", "APPS", "STYLE", "SHOPPING", "GADGETS", "WORKOUTS"],
      ),
    ];
  }

  void _changeCategory(int index) {
    setState(() {
      _selectedCategory = index;
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentCategory = _categories[_selectedCategory];
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildCategoryContent(currentCategory),
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
          // Barre de recherche ou catégories
          if (_isSearching)
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      decoration: const InputDecoration(
                        hintText: "Search",
                        hintStyle: TextStyle(color: Colors.white60),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: _toggleSearch,
                  ),
                ],
              ),
            )
          else
            SizedBox(
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _categoryScrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final isSelected = _selectedCategory == index;
                        return GestureDetector(
                          onTap: () => _changeCategory(index),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _categories[index],
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : Colors.white60,
                                    fontSize: 15,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    letterSpacing: 1.1,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  height: 3,
                                  width: isSelected ? 28 : 0,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: _toggleSearch,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryContent(String category) {
    if (category == "EXPLORE MORE TOPICS") {
      return _buildTopicsView();
    }

    final featured = _featuredArticles[category] ?? [];
    final posts = _detailedPosts[category] ?? [];

    return ListView(
      children: [
        // Featured articles (couvertures)
        if (featured.isNotEmpty) ...[
          const SizedBox(height: 16),
          ...featured.map((article) => _buildFeaturedCard(article, category, posts)),
        ],
      ],
    );
  }

  Widget _buildFeaturedCard(FeaturedArticle article, String category, List<DetailedPost> posts) {
    return GestureDetector(
      onTap: () {
        // Navigation vers la vue détaillée avec effet flip
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailedPostsView(
              posts: posts,
              category: category,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[900],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (article.imageUrl != null)
              Image.network(
                article.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[800],
                    child: const Icon(Icons.broken_image, color: Colors.white30, size: 60),
                  );
                },
              ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.9),
                  ],
                  stops: const [0.3, 0.7, 1.0],
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.source,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicsView() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: _topics.map((topic) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "RELATED",
              style: TextStyle(
                color: Colors.white60,
                fontSize: 12,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              topic.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ...topic.relatedTopics.map((relatedTopic) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  relatedTopic,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }),
          ],
        );
      }).toList(),
    );
  }
}

// ============================================
// VUE DÉTAILLÉE DES POSTS (AVEC FLIP)
// ============================================
class DetailedPostsView extends StatefulWidget {
  final List<DetailedPost> posts;
  final String category;

  const DetailedPostsView({
    super.key,
    required this.posts,
    required this.category,
  });

  @override
  State<DetailedPostsView> createState() => _DetailedPostsViewState();
}

class _DetailedPostsViewState extends State<DetailedPostsView> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (_currentPage != page) {
        setState(() => _currentPage = page);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      widget.category,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Posts avec effet flip
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: widget.posts.length,
                itemBuilder: (context, index) {
                  return _FlipPostCard(
                    post: widget.posts[index],
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
}

// ============================================
// CARTE DE POST AVEC EFFET FLIP
// ============================================
class _FlipPostCard extends StatelessWidget {
  final DetailedPost post;
  final PageController pageController;
  final int currentIndex;
  final double currentPage;

  const _FlipPostCard({
    required this.post,
    required this.pageController,
    required this.currentIndex,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    final double diff = (currentPage - currentIndex);
    final double angle = diff.clamp(-1.0, 1.0);

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.002)
        ..rotateX(-angle * 0.5),
      child: _buildPostContent(context),
    );
  }

  Widget _buildPostContent(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image de fond
          if (post.imageUrl != null)
            Image.network(
              post.imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[900],
                  child: const Icon(Icons.broken_image, color: Colors.white30, size: 80),
                );
              },
            ),

          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.8),
                  Colors.black,
                ],
                stops: const [0.0, 0.5, 0.75, 1.0],
              ),
            ),
          ),

          // Badge catégorie
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                "# ${post.category}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Contenu
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    post.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "${post.source} · ${post.timeAgo}",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    post.description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.purple,
                        child: Text(
                          post.authorName?[0] ?? "F",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.authorName ?? "Flipboard",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              "flipped into MIND SHIFT",
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert, color: Colors.white70),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildActionButton(
                        Icons.favorite_border,
                        post.likes.toString(),
                        onTap: () {
                          debugPrint("LIKE → ${post.title}");
                        },
                      ),
                      const SizedBox(width: 30),
                      _buildActionButton(
                        Icons.comment_outlined,
                        post.comments.toString(),
                        onTap: () {
                          debugPrint("COMMENT → ${post.title}");
                        },
                      ),
                      const SizedBox(width: 30),
                      _buildActionButton(
                        Icons.add,
                        post.flips.toString(),
                        onTap: () {
                          debugPrint("FLIP → ${post.title}");
                        },
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.share_outlined, color: Colors.white70),
                        onPressed: () {
                          debugPrint("SHARE → ${post.title}");
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String count, {
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Row(
          children: [
            Icon(icon, color: Colors.white70, size: 22),
            const SizedBox(width: 6),
            Text(
              count,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}