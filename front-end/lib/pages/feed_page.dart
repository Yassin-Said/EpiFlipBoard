import 'package:flutter/material.dart';
import 'package:epiflipboard/pages/save_magazine_page.dart';
import 'package:epiflipboard/models/post.dart';
import 'package:epiflipboard/models/article.dart';
import 'package:epiflipboard/models/topic_categorie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

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

class PostsResponse {
  final List<DetailedPost> posts;
  final String? nextCursor;

  PostsResponse({required this.posts, this.nextCursor});

  factory PostsResponse.fromJson(Map<String, dynamic> json) {
    return PostsResponse(
      posts: (json["posts"] as List)
          .map((e) => DetailedPost.fromJson(e))
          .toList(),
      nextCursor: json["nextCursor"],
    );
  }
}

class _ForYouPageState extends State<ForYouPage> {
  late final PageController _forYouPageController;
  final List<String> _categories = [
    "FOR YOU",
  ];
  
  int _selectedCategory = 0;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _categoryScrollController = ScrollController();
  
  String? _nextCursor;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  double _currentPageValue = 0.0;

  late Map<String, List<FeaturedArticle>> _featuredArticles;
  late Map<String, List<DetailedPost>> _detailedPosts;
  late List<Topic> _topics;

  @override
  void initState() {
    super.initState();
    _forYouPageController = PageController();
    
    _forYouPageController.addListener(() {
      setState(() {
        _currentPageValue = _forYouPageController.page ?? 0.0;
      });
    });
    
    _featuredArticles = widget.featuredByCategory ?? _getDefaultFeatured();

    _detailedPosts = widget.postsByCategory ?? _getDefaultPosts();
    _topics = widget.topics ?? _getDefaultTopics();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      final postsResponse = await fetchPosts();

      if (!mounted) return;

      setState(() {
        _detailedPosts = {
          "FOR YOU": postsResponse.posts,
        };
        _nextCursor = postsResponse.nextCursor;
        _hasMore = _nextCursor != null;
      });
    } catch (e) {
      print("loadPosts error: $e");
    }
  }

  Future<void> _loadMorePosts() async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;

    try {
      final postsResponse = await fetchPosts(cursor: _nextCursor);

      if (!mounted) return;

      setState(() {
        _detailedPosts["FOR YOU"]!.addAll(postsResponse.posts);
        _nextCursor = postsResponse.nextCursor;
        _hasMore = _nextCursor != null;
      });
    } catch (e) {
      print("loadMorePosts error: $e");
    } finally {
      _isLoadingMore = false;
    }
  }

  @override
  void dispose() {
    _forYouPageController.dispose();
    _searchController.dispose();
    _categoryScrollController.dispose();
    super.dispose();
  }

  Future<Map<String, int>> fetchPostLikes(List<String> postIds) async {
    final response = await http.post(
      Uri.parse("https://epiflipboard-iau1.onrender.com/countPostLikes"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "post_ids": postIds,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Erreur lors du chargement des likes");
    }

    final data = jsonDecode(response.body);

    return Map<String, int>.from(
      data["data"].map((key, value) => MapEntry(key, value as int)),
    );
  }

  Future<PostsResponse> fetchPosts({String? cursor}) async {
    final uri = Uri.parse(
      cursor == null
        ? "https://epiflipboard-iau1.onrender.com/posts"
        : "https://epiflipboard-iau1.onrender.com/posts?cursor=$cursor",
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception("Erreur lors du chargement des posts");
    }
   final Map<String, dynamic> data = jsonDecode(response.body);

  final posts = (data["posts"] as List)
      .map((e) => DetailedPost.fromBackendJson(e))
      .toList();

  final postIds = posts.map((p) => p.id).toList();

  final likesMap = await fetchPostLikes(postIds);

  for (final post in posts) {
    post.likes = likesMap[post.id] ?? 0;
  }

  return PostsResponse(
    posts: posts,
    nextCursor: data["nextCursor"],
  );
}

  Map<String, List<FeaturedArticle>> _getDefaultFeatured() {
    return {
      "DAILY EDITION": [
        FeaturedArticle(
          title: "Jerome Powell to attend Supreme Court arguments in case on Trump",
          source: "NBC News",
          imageUrl: "https://images.unsplash.com/photo-1589994965851-a8f479c573a9?w=800&h=600&fit=crop",
          url: "https://www.nbcnews.com",
        ),
        FeaturedArticle(
          title: "100 vehicles pile up in Michigan crash as snowstorm moves across",
          source: "Associated Press",
          imageUrl: "https://images.unsplash.com/photo-1491146179969-d674118945ff?w=800&h=600&fit=crop",
          url: "https://apnews.com",
        ),
        FeaturedArticle(
          title: "US carries out first known strike on alleged drug boat since Maduro's capture",
          source: "Associated Press",
          imageUrl: "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800&h=600&fit=crop",
          url: "https://apnews.com",
          description: "WASHINGTON (AP) — The U.S. military said Friday that it has carried out a deadly strike on a...",
          timeAgo: "11 hours ago",
        ),
        FeaturedArticle(
          title: "An anti-ICE 'economic blackout' is underway in Minneapolis. What to know",
          source: "yahoo.com",
          imageUrl: "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&h=600&fit=crop",
          url: "https://www.yahoo.com",
          timeAgo: "15 hours ago",
        ),
      ],
      "TRENDING": [
        FeaturedArticle(
          title: "Comfort Food - Foods that will hit the spot",
          source: "Magazine",
          imageUrl: "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800&h=600&fit=crop",
          url: "https://www.example.com",
        ),
      ],
    };
  }

  Map<String, List<DetailedPost>> _getDefaultPosts() {
    return {
      "FOR YOU": [
        DetailedPost(
          id: "qgueygqs",
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
          id: "qgueygqs",
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
        DetailedPost(
          id: "qgueygqs",
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
    if (_selectedCategory == index && _categories[index] == "FOR YOU") {
      _forYouPageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      return;
    }

    setState(() {
      _selectedCategory = index;
    });
  }

  void _toggleSearch() {
    setState(() {
      debugPrint("SEARCH → ");
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
      }
    });
  }

  Future<void> _openUrl(String url) async {
    try {
      debugPrint("Attempting to open URL: $url");
      final Uri uri = Uri.parse(url);
      
      // Essayer de lancer l'URL
      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      
      if (launched) {
        debugPrint("✅ URL opened successfully: $url");
      } else {
        debugPrint("❌ Failed to open URL: $url");
        // Afficher un message à l'utilisateur
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Cannot open link: $url"),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("❌ Error opening URL: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
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
          // if (_isSearching)
          //   Container(
          //     padding: const EdgeInsets.all(16),
          //     child: Row(
          //       children: [
          //         Expanded(
          //           child: TextField(
          //             controller: _searchController,
          //             autofocus: true,
          //             style: const TextStyle(color: Colors.white, fontSize: 18),
          //             decoration: const InputDecoration(
          //               hintText: "Search",
          //               hintStyle: TextStyle(color: Colors.white60),
          //               border: InputBorder.none,
          //             ),
          //           ),
          //         ),
          //         IconButton(
          //           icon: const Icon(Icons.close, color: Colors.white),
          //           onPressed: _toggleSearch,
          //         ),
          //       ],
          //     ),
          //   )
          // else
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
                  // IconButton(
                  //   icon: const Icon(Icons.search, color: Colors.white),
                  //   onPressed: _toggleSearch,
                  // ),
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

    // DAILY EDITION : nouvelle vue liste d'articles
    if (category == "DAILY EDITION") {
      return _buildDailyEditionView();
    }

    final posts = _detailedPosts[category] ?? [];

    if (category == "FOR YOU") {
      return PageView.builder(
        controller: _forYouPageController,
        scrollDirection: Axis.vertical,
        itemCount: posts.length,
        itemBuilder: (context, index) {
          if (!_isLoadingMore && _hasMore && index >= posts.length - 2) {
            _loadMorePosts();
          }
          return _FlipPostCard(
            post: posts[index],
            currentIndex: index,
            currentPage: _currentPageValue,
          );
        },
      );
    }

    final featured = _featuredArticles[category] ?? [];

    return ListView(
      children: [
        if (featured.isNotEmpty) ...[
          const SizedBox(height: 16),
          ...featured.map(
            (article) => _buildFeaturedCard(article, category, posts),
          ),
        ],
      ],
    );
  }

  // NOUVELLE VUE POUR DAILY EDITION
  Widget _buildDailyEditionView() {
    final articles = _featuredArticles["DAILY EDITION"] ?? [];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "LATEST NEWS",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            itemCount: articles.length,
            separatorBuilder: (context, index) => Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              height: 1,
              color: Colors.grey[900],
            ),
            itemBuilder: (context, index) {
              return _buildNewsArticleItem(articles[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNewsArticleItem(FeaturedArticle article) {
    return GestureDetector(
      onTap: () {
        if (article.url != null) {
          _openUrl(article.url!);
        } else {
          debugPrint("No URL for article: ${article.title}");
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        color: Colors.black,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image à gauche
            if (article.imageUrl != null)
              Container(
                width: 120,
                height: 90,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[900],
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  article.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[800],
                      child: const Icon(Icons.broken_image, color: Colors.white30, size: 40),
                    );
                  },
                ),
              ),
            
            // Contenu à droite
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre
                  Text(
                    article.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Description (si disponible)
                  if (article.description != null) ...[
                    Text(
                      article.description!,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 14,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                  ],
                  
                  // Source et temps
                  Row(
                    children: [
                      // Logo circulaire de la source
                      Container(
                        width: 20,
                        height: 20,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: Center(
                          child: Text(
                            article.source[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      
                      // Nom de la source
                      Expanded(
                        child: Text(
                          article.source,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      
                      // Temps (si disponible)
                      if (article.timeAgo != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          article.timeAgo!,
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Boutons d'action
                  Row(
                    children: [
                      _buildSmallActionButton(Icons.share, () {
                        debugPrint("SHARE → ${article.title}");
                      }),
                      const SizedBox(width: 16),
                      _buildSmallActionButton(Icons.comment_outlined, () {
                        debugPrint("COMMENT → ${article.title}");
                      }),
                      const SizedBox(width: 16),
                      _buildSmallActionButton(Icons.add, () {
                        debugPrint("ADD → ${article.title}");
                      }),
                      const SizedBox(width: 16),
                      _buildSmallActionButton(Icons.favorite_border, () {
                        debugPrint("LIKE → ${article.title}");
                      }),
                      const Spacer(),
                      _buildSmallActionButton(Icons.more_horiz, () {
                        debugPrint("MORE → ${article.title}");
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallActionButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(
          icon,
          color: Colors.white60,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildFeaturedCard(FeaturedArticle article, String category, List<DetailedPost> posts) {
    return GestureDetector(
      onTap: () {
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
  double _currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0.0;
      });
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
        child: PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: widget.posts.length,
          itemBuilder: (context, index) {
            return _FlipPostCard(
              post: widget.posts[index],
              currentIndex: index,
              currentPage: _currentPage,
            );
          },
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
  final int currentIndex;
  final double currentPage;

  const _FlipPostCard({
    required this.post,
    required this.currentIndex,
    required this.currentPage,
  });

  Future<void> openLink(String url) async {
    final uri = Uri.parse(url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Impossible d’ouvrir le lien');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double diff = (currentPage - currentIndex);
    final double angle = diff.clamp(-1.0, 1.0);

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateX(-angle * 0.7),
      child: _buildPostContent(context,
        onTap: () {
          openLink(post.source);
        },),
    );
  }

String extractDomain(String url) {
  try {
    final uri = Uri.parse(url);
    return uri.host.replaceFirst('www.', '');
  } catch (_) {
    return url;
  }
}

  Widget _buildPostContent(BuildContext context, {required VoidCallback onTap}) {
  return GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: onTap,
    child: Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
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
                    extractDomain(post.source),
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
                        backgroundImage: (post.authorUrl != null && post.authorUrl!.isNotEmpty)
                            ? NetworkImage(post.authorUrl!)
                            : null,
                        child: (post.authorUrl == null || post.authorUrl!.isEmpty)
                            ? Text(
                                post.authorName?.substring(0, 1).toUpperCase() ?? "F",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
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
                            // const Text(
                            //   "flipped into MIND SHIFT",
                            //   style: TextStyle(
                            //     color: Colors.white60,
                            //     fontSize: 12,
                            //   ),
                            // ),
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
                        "Like",
                        Icons.favorite_border,
                        post.likes.toString(),
                        onTap: () {
                          post.likes += 1;
                          debugPrint("LIKE → ${post.title}");
                        },
                      ),
                      const SizedBox(width: 30),
                      _buildActionButton(
                        "",
                        Icons.comment_outlined,
                        post.comments.toString(),
                        onTap: () {
                          debugPrint("COMMENT → ${post.title}");
                        },
                      ),
                      const SizedBox(width: 30),
                      _buildActionButton(
                        "",
                        Icons.add,
                        post.flips.toString(),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SelectMagazinePage(addedPost: post),
                            ),
                          );
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
    )
    );
  }

  Widget _buildActionButton(
    String name,
    IconData icon,
    String count, {
    required VoidCallback onTap,
  }) {
    var _color;
    if (name == "Like") {
      _color = Colors.red;
    } else {
      _color = Colors.white;
    }
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Row(
          children: [
            Icon(icon, color: _color, size: 22),
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