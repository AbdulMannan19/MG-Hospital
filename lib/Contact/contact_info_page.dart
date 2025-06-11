import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactInfoPage extends StatelessWidget {
  const ContactInfoPage({Key? key}) : super(key: key);

  void _callNumber(String phone) async {
    final Uri url = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Contact Us', style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFe0f7fa), Color(0xFFffffff)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          children: [
            // Address
            _ContactCard(
              icon: Icons.location_on,
              title: 'Address',
              content: const Text(
                'Gate No 1, Janaki Nagar Colony, Tolichowki, Hyderabad.',
                style: TextStyle(fontSize: 16),
              ),
              iconColor: Colors.teal,
            ),
            const SizedBox(height: 18),
            // Email
            _ContactCard(
              icon: Icons.email,
              title: 'Email Us',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('marketing@mghospitals.in',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 4),
                  Text('info@mghospitals.in', style: TextStyle(fontSize: 16)),
                ],
              ),
              iconColor: Colors.teal,
            ),
            const SizedBox(height: 18),
            // Contact Numbers
            _ContactCard(
              icon: Icons.phone,
              title: 'Contact Us',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => _callNumber('9030472480'),
                    child: const Text('9030472480',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            decoration: TextDecoration.underline)),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () => _callNumber('04069654786'),
                    child: const Text('040 6965 4786',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            decoration: TextDecoration.underline)),
                  ),
                ],
              ),
              iconColor: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget content;
  final Color iconColor;
  const _ContactCard(
      {required this.icon,
      required this.title,
      required this.content,
      required this.iconColor,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(32),
              ),
              padding: const EdgeInsets.all(14),
              child: Icon(icon, color: iconColor, size: 32),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 8),
                  content,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
