import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: const Color(0xFF13a8b4),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Our Hospital',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF13a8b4),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Welcome to our esteemed hospital, a beacon of health and healing for over two decades. We are committed to providing exceptional medical care with a compassionate touch, ensuring the well-being of every patient who walks through our doors.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),
            const Text(
              'Our Mission',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF13a8b4),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'To deliver comprehensive, patient-centered healthcare services with integrity, innovation, and a commitment to excellence. We strive to improve the health and quality of life for our community through advanced medical practices and a nurturing environment.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),
            const Text(
              'Our Vision',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF13a8b4),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'To be the leading healthcare provider in the region, recognized for our outstanding patient outcomes, cutting-edge technology, and a dedicated team of medical professionals. We envision a healthier future for all, achieved through collaborative care and continuous advancement.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),
            const Text(
              'Our Values',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF13a8b4),
              ),
            ),
            const SizedBox(height: 8),
            _buildValueItem(Icons.favorite, 'Compassion',
                'We treat every patient with empathy, respect, and kindness, understanding their unique needs and concerns.'),
            _buildValueItem(Icons.lightbulb, 'Innovation',
                'We embrace cutting-edge medical technologies and practices to provide the most effective treatments available.'),
            _buildValueItem(Icons.shield, 'Integrity',
                'We uphold the highest ethical standards in all our interactions, fostering trust and transparency.'),
            _buildValueItem(Icons.people, 'Collaboration',
                'We believe in teamwork and multidisciplinary approaches to deliver holistic and integrated care.'),
            _buildValueItem(Icons.star, 'Excellence',
                'We are committed to continuous improvement, striving for the highest quality in every aspect of our service.'),
          ],
        ),
      ),
    );
  }

  Widget _buildValueItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF13a8b4), size: 30),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF13a8b4),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 14, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
