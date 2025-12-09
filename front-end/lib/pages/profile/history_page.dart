import 'package:flutter/material.dart';

// ============================================
// PAGE HISTORIQUE
// ============================================
class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "HISTORY",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () => print("Rechercher"),
          ),
          TextButton(
            onPressed: () => print("Clear history"),
            child: const Text(
              "Clear",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildHistoryItem(
            title: "The Only Recap You Need Before Now You See Me: Now You Don't",
            source: "Looper",
            date: "October 21",
            thumbnail: "https://via.placeholder.com/150x100",
            duration: "17:01",
          ),
          const Divider(color: Colors.white12, height: 1),
          // Tu peux ajouter d'autres items ici
        ],
      ),
    );
  }

  Widget _buildHistoryItem({
    required String title,
    required String source,
    required String date,
    required String thumbnail,
    String? duration,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.white24,
                          child: Icon(Icons.person, size: 16, color: Colors.white70),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          source,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.play_circle_outline, color: Colors.white, size: 40),
                  ),
                  if (duration != null)
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        color: Colors.black87,
                        child: Text(
                          duration,
                          style: const TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                date,
                style: const TextStyle(color: Colors.white60, fontSize: 14),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white70, size: 20),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.comment_outlined, color: Colors.white70, size: 20),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white70, size: 20),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.favorite_border, color: Colors.white70, size: 20),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white70, size: 20),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}