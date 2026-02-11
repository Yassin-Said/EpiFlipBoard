import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FollowingPage extends StatefulWidget {
  const FollowingPage({super.key});

  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
    fetchFollowedTags();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

Future<void> fetchFollowedTags() async {
  final List<String> tagsList = ["Divers", "Tennis", "Politique", "Foot"];

  try {
    List<Map<String, dynamic>> tempFollowedTags = [];

    for (String tagName in tagsList) {
      final response = await http.get(
        Uri.parse(
          "https://epiflipboard-iau1.onrender.com/postsByTags?tags=$tagName",
        ),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        final List<dynamic> posts = decoded["posts"] ?? [];

        tempFollowedTags.add({
          "name": tagName.toUpperCase(),
          "followers": "5", // temporaire
          "coverImage": posts.isNotEmpty ? posts[0]["image_url"] : null,
          "articles": posts.map((article) {
            return {
              "title": article["title"],
              "description": article["summary"],
              "source": article["link"],
              "sourceImage": article["image_url"],
              "timeAgo": article["created_at"], // à formater plus tard
              "imageUrl": article["image_url"],
              "url": article["link"],
            };
          }).toList(),
        });
      } else {
        debugPrint("Erreur API pour $tagName: ${response.statusCode}");
      }
    }

    setState(() {
      followedTags.clear();
      followedTags.addAll(tempFollowedTags);
    });

  } catch (e) {
    debugPrint("Erreur fetchFollowedTags: $e");
  }
}
  // Liste des tags suivis avec leurs informations
  final List<Map<String, dynamic>> followedTags = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildTagsGrid()),
        ],
      ),
    );
  }

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
          onPressed: () {
            debugPrint("Refresh following");
            _searchController.clear();
          },
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search Following",
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white54),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey.shade900,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.tune, color: Colors.white54),
          ),
        ],
      ),
    );
  }

  Widget _buildTagsGrid() {
    // Filtrer les tags en fonction de la recherche
    final filteredTags = followedTags.where((tag) {
      final tagName = tag["name"].toString().toLowerCase();
      return tagName.contains(_searchQuery);
    }).toList();

    // Afficher un message si aucun résultat
    if (filteredTags.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.white30,
            ),
            const SizedBox(height: 16),
            Text(
              "No tags found for \"$_searchQuery\"",
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: filteredTags.length,
      itemBuilder: (context, index) {
        final tag = filteredTags[index];
        return _buildTagCard(tag);
      },
    );
  }

  Widget _buildTagCard(Map<String, dynamic> tag) {
    final articles = tag["articles"] as List<Map<String, dynamic>>;
    final firstArticleImage = articles.isNotEmpty ? articles[0]["imageUrl"] : tag["coverImage"];

    return GestureDetector(
      onTap: () {
        // Navigation vers la page des articles du tag
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TagArticlesPage(
              tagName: tag["name"],
              followers: tag["followers"],
              articles: articles,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[900],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image de couverture (première image du premier article)
            Image.network(
              firstArticleImage,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[800],
                  child: const Icon(Icons.broken_image, color: Colors.white30, size: 60),
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
                    Colors.black.withOpacity(0.95),
                  ],
                  stops: const [0.3, 0.7, 1.0],
                ),
              ),
            ),

            // Contenu
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  // Nom du tag
                  Text(
                    "# ${tag["name"]}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Nombre de followers
                  Text(
                    "${tag["followers"]} Followers",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Titre du premier article (aperçu)
                  if (articles.isNotEmpty)
                    Text(
                      articles[0]["title"],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 8),
                  // Bouton More
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: Container(
                  //     padding: const EdgeInsets.all(4),
                  //     decoration: BoxDecoration(
                  //       color: Colors.white.withOpacity(0.2),
                  //       shape: BoxShape.circle,
                  //     ),
                  //     child: const Icon(
                  //       Icons.more_vert,
                  //       color: Colors.white,
                  //       size: 18,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================
// PAGE DES ARTICLES D'UN TAG
// ============================================
class TagArticlesPage extends StatefulWidget {
  final String tagName;
  final String followers;
  final List<Map<String, dynamic>> articles;

  const TagArticlesPage({
    super.key,
    required this.tagName,
    required this.followers,
    required this.articles,
  });

  @override
  State<TagArticlesPage> createState() => _TagArticlesPageState();
}

class _TagArticlesPageState extends State<TagArticlesPage> {
  final List<String> _subCategories = [
    "ALL STORIES",
    "ISRAEL-HAMAS WAR",
    "UKRAINE",
    "VIDEO"
  ];
  
  int _selectedSubCategory = 0;

  Future<void> _openUrl(String url) async {
    try {
      debugPrint("Attempting to open URL: $url");
      final Uri uri = Uri.parse(url);
      
      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      
      if (launched) {
        debugPrint("✅ URL opened successfully: $url");
      } else {
        debugPrint("❌ Failed to open URL: $url");
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSubCategories(),
            Expanded(
              child: _buildArticlesList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Bouton retour
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          // Bouton Invite
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          //   decoration: BoxDecoration(
          //     color: Colors.red,
          //     borderRadius: BorderRadius.circular(20),
          //   ),
          //   child: const Text(
          //     "Invite",
          //     style: TextStyle(
          //       color: Colors.white,
          //       fontWeight: FontWeight.bold,
          //       fontSize: 14,
          //     ),
          //   ),
          // ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.white),
            onPressed: () {
              debugPrint("Filter options");
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              debugPrint("More options");
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSubCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "# ${widget.tagName}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "${widget.followers} Followers",
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // SizedBox(
        //   height: 45,
        //   child: ListView.builder(
        //     scrollDirection: Axis.horizontal,
        //     padding: const EdgeInsets.symmetric(horizontal: 20),
        //     itemCount: _subCategories.length,
        //     itemBuilder: (context, index) {
        //       final isSelected = _selectedSubCategory == index;
        //       return GestureDetector(
        //         onTap: () {
        //           setState(() {
        //             _selectedSubCategory = index;
        //           });
        //         },
        //         child: Padding(
        //           padding: const EdgeInsets.only(right: 20),
        //           child: Column(
        //             mainAxisSize: MainAxisSize.min,
        //             children: [
        //               Text(
        //                 _subCategories[index],
        //                 style: TextStyle(
        //                   color: isSelected ? Colors.white : Colors.white60,
        //                   fontSize: 14,
        //                   fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        //                   letterSpacing: 0.5,
        //                 ),
        //               ),
        //               const SizedBox(height: 8),
        //               AnimatedContainer(
        //                 duration: const Duration(milliseconds: 250),
        //                 height: 3,
        //                 width: isSelected ? 40 : 0,
        //                 decoration: BoxDecoration(
        //                   color: Colors.red,
        //                   borderRadius: BorderRadius.circular(2),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //       );
        //     },
        //   ),
        // ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildArticlesList() {
    // Trier les articles du plus récent au plus vieux
    final sortedArticles = List<Map<String, dynamic>>.from(widget.articles);
    // Ici on pourrait ajouter un vrai tri par date si on a les timestamps
    
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: sortedArticles.length,
      separatorBuilder: (context, index) => Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        height: 1,
        color: Colors.grey[900],
      ),
      itemBuilder: (context, index) {
        final article = sortedArticles[index];
        return _buildArticleItem(article);
      },
    );
  }

  Widget _buildArticleItem(Map<String, dynamic> article) {
    return GestureDetector(
      onTap: () {
        _openUrl(article["url"]);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image de l'article
            if (article["imageUrl"] != null)
              Container(
                width: double.infinity,
                height: 200,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[900],
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  article["imageUrl"],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[800],
                      child: const Icon(Icons.broken_image, color: Colors.white30, size: 60),
                    );
                  },
                ),
              ),

            // Titre
            Text(
              article["title"],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12),

            // Description
            if (article["description"] != null)
              Text(
                article["description"],
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 16),

            // Source et temps
            Row(
              children: [
                // Logo de la source
                if (article["sourceImage"] != null)
                  Container(
                    width: 36,
                    height: 36,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[800],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      article["sourceImage"],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.red,
                          child: Center(
                            child: Text(
                              article["source"][0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                // Nom de la source
                Expanded(
                  child: Text(
                    article["source"],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Temps écoulé
            Text(
              article["timeAgo"],
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),

            // Boutons d'action
            Row(
              children: [
                _buildActionButton(Icons.share, () {
                  debugPrint("SHARE → ${article["title"]}");
                }),
                const SizedBox(width: 20),
                _buildActionButton(Icons.comment_outlined, () {
                  debugPrint("COMMENT → ${article["title"]}");
                }),
                const SizedBox(width: 20),
                _buildActionButton(Icons.add, () {
                  debugPrint("ADD → ${article["title"]}");
                }),
                const SizedBox(width: 20),
                _buildActionButton(Icons.favorite_border, () {
                  debugPrint("LIKE → ${article["title"]}");
                }),
                const Spacer(),
                _buildActionButton(Icons.more_horiz, () {
                  debugPrint("MORE → ${article["title"]}");
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(
          icon,
          color: Colors.white60,
          size: 22,
        ),
      ),
    );
  }
}