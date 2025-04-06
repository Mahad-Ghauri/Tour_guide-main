import 'package:flutter/material.dart';

class LocationEntryScreen extends StatefulWidget {
  const LocationEntryScreen({Key? key}) : super(key: key);

  @override
  _LocationEntryScreenState createState() => _LocationEntryScreenState();
}

class _LocationEntryScreenState extends State<LocationEntryScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> recentPlaces = [
    {
      'name': 'Al-Jannat Homes',
      'address': 'Babar Colony, Multan',
      'isOpen': null,
    },
    {
      'name': 'Multan International Airport',
      'address': 'Multan International Airport, Multan',
      'isOpen': null,
    },
    {
      'name': 'Nishtar Hospital Emergency Department',
      'address': 'Accident and Emergency Department, Multan',
      'isOpen': 'Open 24 hours',
    },
    {
      'name': 'KFC',
      'address': 'Railway Club, Kaswar Gardezi Road, Multan',
      'isOpen': 'Open · Closes 3:30 am',
    },
  ];

  Widget _buildLocationButton({
    required IconData icon,
    required String label,
    required String? sublabel,
    required bool isSelected,
    bool showIcon = false,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? Colors.blue.shade100
                            : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    icon,
                    size: 16,
                    color: isSelected ? Colors.blue : Colors.black54,
                  ),
                ),
                if (showIcon) const SizedBox() else const SizedBox(width: 8),
                if (!showIcon)
                  Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? Colors.blue : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
            if (sublabel != null && !showIcon)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 30),
                child: Text(
                  sublabel,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            if (showIcon)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  label,
                  style: TextStyle(color: Colors.black87, fontSize: 14),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentLocationItem(Map<String, dynamic> place) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.access_time, color: Colors.black54, size: 20),
      ),
      title: Text(
        place['name'],
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            place['address'],
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
          if (place['isOpen'] != null)
            Text(
              place['isOpen'],
              style: TextStyle(color: Colors.green[700], fontSize: 13),
            ),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      onTap: () {
        // Return the selected location to the map screen
        Navigator.pop(context, place);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Search here',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.mic), onPressed: () {}),
                ],
              ),
            ),

            const Divider(height: 1),

            // Home, Work, More buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  _buildLocationButton(
                    icon: Icons.home,
                    label: 'Home',
                    sublabel: '30.22014...',
                    isSelected: true,
                  ),
                  const SizedBox(width: 8),
                  _buildLocationButton(
                    icon: Icons.work,
                    label: 'Work',
                    sublabel: 'Set locat...',
                    isSelected: false,
                  ),
                  const SizedBox(width: 8),
                  _buildLocationButton(
                    icon: Icons.more_horiz,
                    label: 'More',
                    sublabel: null,
                    isSelected: false,
                    showIcon: true,
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Recent header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  IconButton(
                    icon: const Icon(Icons.info_outline, size: 20),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Recent places list
            Expanded(
              child: ListView.separated(
                itemCount: recentPlaces.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  return _buildRecentLocationItem(recentPlaces[index]);
                },
              ),
            ),

            // More from recent history button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: TextButton(
                  child: Text(
                    'More from recent history',
                    style: TextStyle(
                      color: Colors.teal[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
