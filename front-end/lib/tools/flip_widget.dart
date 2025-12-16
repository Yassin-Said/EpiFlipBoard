import 'package:flutter/material.dart';
import 'package:epiflipboard/models/post.dart';

class FlipPageView extends StatelessWidget {
  final Post post;
  final PageController pageController;
  final int currentIndex;
  final double currentPage;

  const FlipPageView({
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
      child: _buildPostCard(context),
    );
  }

  Widget _buildPostCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      color: Colors.black,
      child: Column(
        children: [
          // Image principale en plein écran
          Expanded(
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
                  )
                else
                  Container(color: Colors.grey[900]),
                
                // Gradient pour le texte
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
                      stops: const [0.0, 0.5, 0.8, 1.0],
                    ),
                  ),
                ),
                
                // Badge catégorie en haut à gauche
                if (!post.isAd)
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
                        "# ${post.category.toUpperCase()}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                
                // Indicateur AD en haut à droite
                if (post.isAd)
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.info_outline, color: Colors.white, size: 12),
                          SizedBox(width: 4),
                          Text(
                            "Ad",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                
                // Contenu en bas
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Titre
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
                        
                        // Source et temps (si pas AD)
                        if (!post.isAd)
                          Text(
                            "${post.source} · ${post.timeAgo} · ${post.category}",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        
                        // Description (si pas AD)
                        if (!post.isAd) ...[
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
                        ],
                        
                        // Pour les ADs, afficher le bouton
                        if (post.isAd) ...[
                          const SizedBox(height: 12),
                          Text(
                            post.description,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                            ),
                          ),
                        ],
                        
                        const SizedBox(height: 20),
                        
                        // Auteur et actions
                        Row(
                          children: [
                            if (!post.isAd) ...[
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.purple,
                                child: Text(
                                  post.authorName?[0] ?? "F",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
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
                                      "flipped into HEALTH",
                                      style: TextStyle(
                                        color: Colors.white60,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ] else ...[
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.green,
                                child: const Icon(Icons.home, color: Colors.white, size: 16),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      post.authorName ?? "Greenkub",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Text(
                                      "Advertisement",
                                      style: TextStyle(
                                        color: Colors.white60,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (post.isAd)
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: const Text(
                                    "Ouvrir",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                            ],
                            IconButton(
                              icon: const Icon(Icons.more_vert, color: Colors.white70),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        
                        // Actions (like, comment, flip, share) si pas AD
                        if (!post.isAd) ...[
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              _buildActionButton(Icons.favorite_border, post.likes.toString()),
                              const SizedBox(width: 30),
                              _buildActionButton(Icons.comment_outlined, post.comments.toString()),
                              const SizedBox(width: 30),
                              _buildActionButton(Icons.add, post.flips.toString()),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.share_outlined, color: Colors.white70),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String count) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 22),
        const SizedBox(width: 6),
        Text(
          count,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }
}