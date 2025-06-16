import 'package:flutter/material.dart';

class HospitalBranchesPage extends StatelessWidget {
  const HospitalBranchesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Static data for hospital branches
    final branches = [
      {
        'name': 'MG Hospital - Tolichowki',
        'address': 'Tolichowki, Hyderabad',
        'phone': '+919876543210',
        'image': 'assets/images/tolichowki branch.jpg',
      },
      {
        'name': 'MG Hospital - Banjara Hills',
        'address': 'Banjara Hills, Hyderabad',
        'phone': '+919876543211',
        'image': 'assets/images/Banjara hills branch.png',
      },
      {
        'name': 'MG Hospital - Secunderabad',
        'address': 'Secunderabad, Hyderabad',
        'phone': '+919876543212',
        'image': 'assets/images/secunderabad branch.png',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Hospitals'),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: branches.length,
        itemBuilder: (context, index) {
          final branch = branches[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(
                    branch['image']!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.local_hospital,
                              size: 64, color: Colors.grey),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        branch['name']!,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              branch['address']!,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.phone, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text(
                            branch['phone']!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
