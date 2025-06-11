import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HospitalBranchesPage extends StatelessWidget {
  const HospitalBranchesPage({Key? key}) : super(key: key);

  final List<Map<String, String>> hospitalBranches = const [
    {
      'name': 'MG Hospital Tolichowki',
      'address': 'Gate No 1, Janaki Nagar Colony, Tolichowki, Hyderabad.',
      'phone1': '+919030472480',
      'phone2': '+9104069654786',
      'hours': '24/7 Emergency, OPD: 9:00 AM - 9:00 PM',
    },
    {
      'name': 'MG Hospital Tarnaka',
      'address': 'Street No 10, Tarnaka, Hyderabad.',
      'phone1': '+919123456789',
      'phone2': '+9104012345678',
      'hours': '24/7 Emergency, OPD: 8:00 AM - 8:00 PM',
    },
    {
      'name': 'MG Hospital Gachibowli',
      'address': 'Near Bio Diversity Park, Gachibowli, Hyderabad.',
      'phone1': '+919988776655',
      'phone2': '+9104087654321',
      'hours': '24/7 Emergency, OPD: 9:30 AM - 9:30 PM',
    },
    {
      'name': 'MG Hospital Kondapur',
      'address': 'Kothaguda, Kondapur, Hyderabad.',
      'phone1': '+919876543210',
      'phone2': '+9104023456789',
      'hours': '24/7 Emergency, OPD: 7:00 AM - 7:00 PM',
    },
  ];

  void _callNumber(String phone) async {
    final Uri url = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      // Optionally show an error or a snackbar if the call cannot be launched
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Hospitals'),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: hospitalBranches.length,
        itemBuilder: (context, index) {
          final branch = hospitalBranches[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    branch['name'] ?? 'N/A',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.blueAccent),
                  ),
                  const Divider(height: 20, thickness: 1),
                  _buildInfoRow(Icons.location_on, 'Address:',
                      branch['address'] ?? 'N/A'),
                  const SizedBox(height: 8),
                  _buildPhoneRow(branch['phone1'] ?? ''),
                  if (branch['phone2'] != null && branch['phone2']!.isNotEmpty)
                    _buildPhoneRow(branch['phone2'] ?? ''),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.access_time, 'Operating Hours:',
                      branch['hours'] ?? 'N/A'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[700]),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            '$label $value',
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneRow(String phone) {
    if (phone.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(left: 30.0), // Align with other info
      child: GestureDetector(
        onTap: () => _callNumber(phone),
        child: Row(
          children: [
            const Icon(Icons.phone, size: 20, color: Colors.green),
            const SizedBox(width: 10),
            Text(
              phone,
              style: const TextStyle(
                  fontSize: 15,
                  color: Colors.green,
                  decoration: TextDecoration.underline),
            ),
          ],
        ),
      ),
    );
  }
}
