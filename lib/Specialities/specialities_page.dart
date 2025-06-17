import 'package:flutter/material.dart';

class SpecialitiesPage extends StatelessWidget {
  const SpecialitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Specialities'),
        backgroundColor: const Color(0xFF13a8b4),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF13a8b4), Color(0xFF3ed2c0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'A Best in Care at one place',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Comprehensive healthcare services under one roof',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.85,
                children: [
                  _buildSpecialityCard(
                    'Gynaecology & Obstetrics',
                    'Gynecology is a subspecialty of medicine concerned with the condition of the female reproductive system.',
                    'assets/images/gynecology.png',
                  ),
                  _buildSpecialityCard(
                    'Paediatrics',
                    'At MG Hospital we are dedicated to providing exceptional care for infants, children, and adolescents.',
                    'assets/images/pediatrics.png',
                  ),
                  _buildSpecialityCard(
                    'General Medicine',
                    'The practice of general or internal medicine involves treating patients holistically for all of their medical problems.',
                    'assets/images/general-medicine.png',
                  ),
                  _buildSpecialityCard(
                    'General Surgery',
                    'General surgery is a surgical specialty, which focuses on alimentary canal and abdominal contents including stomach.',
                    'assets/images/general-surgery.png',
                  ),
                  _buildSpecialityCard(
                    'Neurology',
                    'Our Department of Neurology is dedicated to providing comprehensive care for neurological disorders.',
                    'assets/images/neurology.png',
                  ),
                  _buildSpecialityCard(
                    'Cardiology',
                    'MG Hospital has best cardiologists and cardiothoracic surgeons in Hyderabad, specializing in holistic treatment.',
                    'assets/images/cardiology.png',
                  ),
                  _buildSpecialityCard(
                    'Orthopaedics',
                    'The Department of Orthopedics provides treatment for all Orthopedic disorders including knee, hip, spine, and joint problems.',
                    'assets/images/orthopaedics.png',
                  ),
                  _buildSpecialityCard(
                    'Physiotherapy',
                    'Physiotherapy focuses on maximizing physical potential and human movement through specialized treatment.',
                    'assets/images/physiotherapy.png',
                  ),
                  _buildSpecialityCard(
                    'Pulmonology',
                    'Our specialists manage a spectrum of pulmonary diseases, from asthma to lung cancer and Cystic Fibrosis.',
                    'assets/images/pulmonology.png',
                  ),
                  _buildSpecialityCard(
                    'ENT',
                    'We have highly qualified and experienced ENT specialists for all kinds of disorders related to ears, nose, and throat.',
                    'assets/images/ent.png',
                  ),
                  _buildSpecialityCard(
                    'Urology',
                    'A urologist specializes in diseases of urogenital tracts and male reproductive systems.',
                    'assets/images/urology.png',
                  ),
                  _buildSpecialityCard(
                    'Gastroenterology',
                    'Gastroenterology helps with diagnosis and treatment of issues related to the digestive system.',
                    'assets/images/gastroenterology.png',
                  ),
                  _buildSpecialityCard(
                    'Dermatology',
                    'The Department of Dermatology provides treatment for all Skin, Hair, Nail and Mucosal disorders.',
                    'assets/images/dermatology.png',
                  ),
                  _buildSpecialityCard(
                    'Critical Care',
                    'The Critical Care Unit provides specialized and sophisticated Intensive Care Units for critically ill patients.',
                    'assets/images/emergency.png',
                  ),
                  _buildSpecialityCard(
                    'Neonatology',
                    'Our neonatology team provides specialized care for newborns, including premature infants.',
                    'assets/images/neonatology.png',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialityCard(
      String title, String description, String imagePath) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
  padding: const EdgeInsets.only(top: 12),
  child: Center(
    child: SizedBox(
      height: 60, // 👈 Decrease this value to make the image frame smaller
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 60,
            color: const Color(0xFF13a8b4),
            child: const Icon(
              Icons.medical_services,
              size: 20,
              color: Colors.white,
            ),
          );
        },
      ),
    ),
  ),
),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF13a8b4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Read More',
                        style: TextStyle(
                          color: Color(0xFF13a8b4),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
