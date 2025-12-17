import 'package:flutter/material.dart';
import 'package:epiflipboard/models/search.dart';

class ExplorePage extends StatefulWidget {
  final List<ExploreCategory>? categories;
  final String? featuredTitle;
  final String? featuredImageUrl;

  const ExplorePage({
    super.key,
    this.categories,
    this.featuredTitle,
    this.featuredImageUrl,
  });

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late List<ExploreCategory> _categories;
  String _selectedTab = "FEATURED";
  final List<String> _tabs = ["FEATURED", "NEWS", "WATCH", "TECH & SCIENCE"];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _categories = widget.categories ?? _getDefaultCategories();
  }

  List<ExploreCategory> _getDefaultCategories() {
    return [
      ExploreCategory(
        title: "The Latest",
        subtitle: "By Freedom of the Press Foundation",
        imageUrl: "https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=400&h=400&fit=crop",
      ),
      ExploreCategory(
        title: "NFL",
        subtitle: "By The Sports Desk",
        imageUrl: "https://images.unsplash.com/photo-1566577739112-5180d4bf9390?w=400&h=400&fit=crop",
      ),
      ExploreCategory(
        title: "Watch: Editor's Picks",
        subtitle: "By Flipboard TV",
        imageUrl: "https://images.unsplash.com/photo-1522869635100-9f4c5e86aa37?w=400&h=400&fit=crop",
      ),
      ExploreCategory(
        title: "Be Well",
        subtitle: "By Associated Press",
        imageUrl: "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=400&fit=crop",
      ),
    ];
  }

  Future<void> _loadCategories() async {
    setState(() => _isLoading = true);
    // Simule un appel API
    await Future.delayed(const Duration(seconds: 1));
    // Ici tu appelleras ton API
    // final categories = await fetchCategoriesFromApi(_selectedTab);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "EXPLORE",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),

            // Barre de recherche
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.white60),
                    const SizedBox(width: 12),
                    const Text(
                      "Search Flipboard",
                      style: TextStyle(color: Colors.white60, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Tabs
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _tabs.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedTab == _tabs[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedTab = _tabs[index]);
                      _loadCategories();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      margin: const EdgeInsets.only(right: 8),
                      child: Column(
                        children: [
                          Text(
                            _tabs[index],
                            style: TextStyle(
                              color: isSelected ? Colors.red : Colors.white60,
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (isSelected)
                            Container(
                              height: 3,
                              width: 40,
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

            const SizedBox(height: 10),

            // Featured Image
            Container(
              height: 250,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(
                    widget.featuredImageUrl ?? "https://images.unsplash.com/photo-1546519638-68e109498ffc?w=600",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(20),
                alignment: Alignment.bottomLeft,
                child: Text(
                  widget.featuredTitle ?? "NBA Gambling Scandal",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Sélecteur de région
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Text(
                    "United States (English)",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.keyboard_arrow_down, color: Colors.white70, size: 20),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Grille de catégories
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.red),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        return _buildCategoryCard(_categories[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(ExploreCategory category) {
    return GestureDetector(
      onTap: () => print("Category: ${category.title}"),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[900],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image
            if (category.imageUrl != null)
              Image.network(
                category.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[800],
                    child: const Icon(Icons.image_not_supported, color: Colors.white30, size: 40),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[900],
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white30,
                        strokeWidth: 2,
                      ),
                    ),
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
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.9),
                  ],
                  stops: const [0.4, 0.75, 1.0],
                ),
              ),
            ),
            
            // Texte
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    category.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category.subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
