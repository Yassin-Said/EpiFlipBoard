import 'package:flutter/material.dart';
import 'package:epiflipboard/models/notification.dart';

class NotificationPage extends StatefulWidget {
  final List<NotificationItem>? notifications;

  const NotificationPage({super.key, this.notifications});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late List<NotificationItem> _notifications;
  String _selectedTab = "NEWS";
  final List<String> _tabs = ["ACTIVITY", "REPLIES", "NEWS"];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _notifications = widget.notifications ?? _getDefaultNotifications();
  }

  List<NotificationItem> _getDefaultNotifications() {
    return [
      NotificationItem(
        type: "news",
        category: "For You in Space Science",
        title: "\"NASA Completes Next-Gen Telescope, And It Could Soon Reveal Whether We're Alone\" from Science Alert",
        source: "Science Alert",
        timeAgo: "3h",
        imageUrl: "https://images.unsplash.com/photo-1446776653964-20c1d3a81b06?w=100",
      ),
      NotificationItem(
        type: "news",
        category: "Latest News",
        title: "White House in damage control after Trump Chief of Staff Susie Wiles vents about her boss and colleagues to Vanity Fair.",
        source: "Vanity Fair",
        timeAgo: "15h",
        imageUrl: "https://images.unsplash.com/photo-1551836022-deb4988cc6c0?w=100",
      ),
      NotificationItem(
        type: "news",
        category: "For You in Natural History",
        title: "\"One of the Most Complete Human Ancestors Ever Found Isn't Who We Thought It Was\" from Gizmodo",
        source: "Gizmodo",
        timeAgo: "15h",
        imageUrl: "https://images.unsplash.com/photo-1564760055775-d63b17a55c44?w=100",
      ),
      NotificationItem(
        type: "news",
        category: "Latest News",
        title: "House Speaker Mike Johnson will not call vote on ACA subsidies, effectively guaranteeing premiums will rise.",
        source: "Associated Press",
        timeAgo: "16h",
        imageUrl: "https://images.unsplash.com/photo-1551836022-d6c5d2e24ff5?w=100",
      ),
      NotificationItem(
        type: "news",
        category: "Latest News",
        title: "Australia has some of the world's toughest gun laws. So how did Bondi Beach still happen?",
        source: "CNN",
        timeAgo: "17h",
        imageUrl: "https://images.unsplash.com/photo-1507608869274-d3177c8bb4c7?w=100",
      ),
      NotificationItem(
        type: "news",
        category: "For You in Neuroscience",
        title: "\"Psilocybin Breaks Depressive Cycles by Rewiring The Brain, Study Suggests\" from Science Alert",
        source: "Science Alert",
        timeAgo: "23h",
        imageUrl: "https://images.unsplash.com/photo-1559757175-5700dde675bc?w=100",
      ),
    ];
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    // Ici tu appelleras ton API
    // final notifications = await fetchNotificationsFromApi(_selectedTab);
    setState(() => _isLoading = false);
  }

  Future<void> _refreshNotifications() async {
    await _loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Text(
                    "NOTIFICATIONS",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: _refreshNotifications,
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () => print("Settings"),
                  ),
                ],
              ),
            ),

            // Tabs
            Container(
              height: 50,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.white12, width: 1),
                ),
              ),
              child: Row(
                children: _tabs.map((tab) {
                  final isSelected = _selectedTab == tab;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _selectedTab = tab);
                        _loadNotifications();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: isSelected ? Colors.red : Colors.transparent,
                              width: 3,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            tab,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.white60,
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Liste de notifications
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.red),
                    )
                  : _notifications.isEmpty
                      ? const Center(
                          child: Text(
                            "No notifications",
                            style: TextStyle(color: Colors.white60, fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _notifications.length,
                          itemBuilder: (context, index) {
                            return _buildNotificationItem(_notifications[index]);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(NotificationItem notification) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: notification.isRead ? Colors.black : Colors.grey[900],
        border: const Border(
          bottom: BorderSide(color: Colors.white12, width: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo Flipboard
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                "F",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Contenu
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Catégorie
                Text(
                  notification.category,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                // Titre
                Text(
                  notification.title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.3,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Temps
                Text(
                  notification.timeAgo,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Image
          if (notification.imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                notification.imageUrl!,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[800],
                    child: const Icon(Icons.broken_image, color: Colors.white30),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}