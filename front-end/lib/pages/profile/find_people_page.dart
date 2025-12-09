import 'package:flutter/material.dart';

class FindPeoplePage extends StatelessWidget {
  const FindPeoplePage({super.key});

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
          "Find People to Follow",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          // Onglets
          Container(
            height: 50,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white12, width: 1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.red, width: 3),
                      ),
                    ),
                    child: const Icon(Icons.person, color: Colors.red),
                  ),
                ),
                Expanded(
                  child: const Icon(Icons.travel_explore, color: Colors.white60),
                ),
              ],
            ),
          ),
          
          // Liste de personnes
          Expanded(
            child: ListView(
              children: [
                _buildPersonItem(
                  name: "Marshall Moore",
                  description: "Broadcaster and Producer, Financial and Business Reporter/Consultant",
                  verified: false,
                ),
                _buildPersonItem(
                  name: "Noah Mittman",
                  description: "Survivor of the era of Internet Optimism. UXD, IxD, ex-Dev, comics & gaming enthusiast. I buy a hotdog stand if I'm tryna be frank",
                  verified: true,
                ),
                _buildPersonItem(
                  name: "SC",
                  description: "Dive into More.Magazine for the latest tech updates.",
                  verified: false,
                ),
                _buildPersonItem(
                  name: "Joe Ortiz",
                  description: "Into IT/Marketing, a Culture Vulture by heart and a one-part geek in all-rounders\n\nOther Platforms: http://joeo.bio.link/",
                  verified: false,
                ),
                _buildPersonItem(
                  name: "León Krauze",
                  description: "Journalist. Anchor. @NU34LA. Also on @thisisfusion , @Letras_Libres , @El_Universal_Mx and some other places here and there. Also: Sleep deprived father, tomato grower, pinot obsessive and huge soccer nut.",
                  verified: false,
                ),
                _buildPersonItem(
                  name: "Cohl Media",
                  description: "Smart media • curated to inspire.",
                  verified: false,
                ),
                _buildPersonItem(
                  name: "Fareed Zakaria",
                  description: "Editor at TIME. Host of CNN's GPS: Sunday. Blogger at CNN.com/GPS",
                  verified: true,
                ),
                _buildPersonItem(
                  name: "Market Gladiators",
                  description: "Conquering the Competition.",
                  verified: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonItem({
    required String name,
    required String description,
    required bool verified,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white12, width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.grey[800],
            child: Text(
              name[0],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (verified) ...[
                      const SizedBox(width: 6),
                      const Icon(Icons.verified, color: Colors.red, size: 18),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Text(
              "Follow",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}