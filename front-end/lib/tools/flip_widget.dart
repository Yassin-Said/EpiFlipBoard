import 'package:flutter/material.dart';
import 'package:epiflipboard/models/posts.dart';

// ============================================
// WIDGET FLIP EFFET PAGE
// ============================================
class FlipPageView extends StatelessWidget {
  final Post post;
  final PageController pageController;
  final int currentIndex;
  final double currentPage;

  const FlipPageView({
    super.key,
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
        ..setEntry(3, 2, 0.001)
        ..rotateX(angle * 0.3), // Effet flip sur l'axe X
      child: _buildPostCard(),
    );
  }

  Widget _buildPostCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image principale
          if (post.imageUrl != null)
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  image: DecorationImage(
                    image: NetworkImage(post.imageUrl!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          
          // Contenu du post
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre
                  Text(
                    post.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Source et temps
                  Row(
                    children: [
                      Text(
                        "${post.source} · ${post.timeAgo}",
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 14,
                        ),
                      ),
                      const Text(
                        " · ",
                        style: TextStyle(color: Colors.white60),
                      ),
                      Text(
                        post.category,
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Description
                  Expanded(
                    child: Text(
                      post.description,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Badge Flipboard
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text(
                                  "F",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.add, color: Colors.white, size: 14),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Flipboard",
                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        "flipped into Flipboard Picks",
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.more_vert, color: Colors.white60, size: 20),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  
                  // Actions (like, comment, flip, share)
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
              ),
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