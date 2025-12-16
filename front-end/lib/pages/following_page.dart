import 'package:flutter/material.dart';

class FollowingPage extends StatefulWidget {
  const FollowingPage({super.key});

  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  final List<String> tags = [
    "NEWS",
    "SCIENCE",
    "TECHNOLOGY",
    "INSIDE FLIPBOARD",
  ];

  String selectedTag = "NEWS";

  final List<Map<String, String>> articles = [
    {
      "tag": "NEWS",
      "title": "Trump sues BBC for \$10 billion, claims defamation",
      "image": "https://picsum.photos/400/600?1",
    },
    {
      "tag": "SCIENCE",
      "title": "Scientists finally sequence the vampire squid's huge genome",
      "image": "https://picsum.photos/400/600?2",
    },
    {
      "tag": "TECHNOLOGY",
      "title": "Smart Money Moves: Earn More, Save Better",
      "image": "https://picsum.photos/400/600?3",
    },
    {
      "tag": "INSIDE FLIPBOARD",
      "title": "Preparing for Google Zero? Flipboard Is the Paid Solution",
      "image": "https://picsum.photos/400/600?4",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredArticles =
        articles.where((a) => a["tag"] == selectedTag).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildTags(),
          Expanded(child: _buildGrid(filteredArticles)),
        ],
      ),
    );
  }

  // 🔝 APP BAR
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      title: const Text(
        "FOLLOWING",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {},
        ),
      ],
    );
  }

  // 🔍 SEARCH BAR
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Search Following",
          hintStyle: const TextStyle(color: Colors.white54),
          prefixIcon: const Icon(Icons.search, color: Colors.white54),
          filled: true,
          fillColor: Colors.grey.shade900,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // 🏷️ TAGS DYNAMIQUES
  Widget _buildTags() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: tags.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final tag = tags[index];
          final isSelected = tag == selectedTag;

          return GestureDetector(
            onTap: () => setState(() => selectedTag = tag),
            child: Text(
              "#$tag",
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white54,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          );
        },
      ),
    );
  }

  // 🧩 GRID
  Widget _buildGrid(List<Map<String, String>> data) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];

        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                item["image"]!,
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "#${item["tag"]}",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item["title"]!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
