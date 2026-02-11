import 'package:flutter/material.dart';
import '../../models/person.dart';

class FindPeoplePage extends StatefulWidget {
  final List<Person>? people; // Optionnel, si null on utilise des données d'exemple

  const FindPeoplePage({super.key, this.people});

  @override
  State<FindPeoplePage> createState() => _FindPeoplePageState();
}

class _FindPeoplePageState extends State<FindPeoplePage> {
  late List<Person> _people;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _people = widget.people ?? _getDefaultPeople();
  }

  // Données par défaut si aucune liste n'est fournie
  List<Person> _getDefaultPeople() {
    return [
      Person(
        name: "Marshall Moore",
        description: "Broadcaster and Producer, Financial and Business Reporter/Consultant",
        verified: false,
      ),
      Person(
        name: "Noah Mittman",
        description: "Survivor of the era of Internet Optimism. UXD, IxD, ex-Dev, comics & gaming enthusiast.",
        verified: true,
      ),
      Person(
        name: "SC",
        description: "Dive into More.Magazine for the latest tech updates.",
        verified: false,
      ),
    ];
  }

  // Fonction pour charger depuis une API
  Future<void> loadFromApi() async {
    setState(() => _isLoading = true);
    
    // Simule un appel API
    await Future.delayed(const Duration(seconds: 2));
    
    // Exemple : ici tu ferais ton appel API réel
    // final response = await http.get('https://ton-api.com/people');
    // final data = jsonDecode(response.body);
    // setState(() {
    //   _people = (data as List).map((json) => Person.fromJson(json)).toList();
    // });
    
    setState(() => _isLoading = false);
  }

  void _toggleFollow(int index) {
    setState(() {
      _people[index].isFollowing = !_people[index].isFollowing;
    });
    
    // Ici tu pourrais appeler ton API pour suivre/ne plus suivre
    // await api.followPerson(_people[index].name);
  }

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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: loadFromApi,
          ),
        ],
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

          // Liste
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.red),
                  )
                : _people.isEmpty
                    ? const Center(
                        child: Text(
                          "No people to show",
                          style: TextStyle(color: Colors.white60),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _people.length,
                        itemBuilder: (context, index) {
                          return _buildPersonItem(_people[index], index);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonItem(Person person, int index) {
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
            backgroundImage: person.avatarUrl != null
                ? NetworkImage(person.avatarUrl!)
                : null,
            child: person.avatarUrl == null
                ? Text(
                    person.name[0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        person.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (person.verified) ...[
                      const SizedBox(width: 6),
                      const Icon(Icons.verified, color: Colors.red, size: 18),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  person.description,
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
            onPressed: () => _toggleFollow(index),
            style: ElevatedButton.styleFrom(
              backgroundColor: person.isFollowing ? Colors.grey[800] : Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: Text(
              person.isFollowing ? "Following" : "Follow",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}