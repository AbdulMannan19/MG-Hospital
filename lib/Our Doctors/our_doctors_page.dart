import 'package:flutter/material.dart';
import '../Appointment/appointment_listing.dart';

class OurDoctorsPage extends StatelessWidget {
  const OurDoctorsPage({super.key});

  // Doctor data moved to a list for maintainability
  static final List<Map<String, String>> doctors = [
    {
      'name': 'Dr. Mohammed Ateeq Ur Rahman',
      'specialization': 'Consultant Neurology & Stroke Specialist',
      'imagePath': 'assets/images/doctors/neurology.png',
    },
    {
      'name': 'Dr. Ahmad Abdul Khabeer',
      'specialization': 'Consultant ENT, Head & Neck, Skull Base Surgeon',
      'imagePath': 'assets/images/doctors/ent.png',
    },
    {
      'name': 'Dr. Mohd Naqi Zain',
      'specialization': 'Consultant General & Laparoscopic Surgeon',
      'imagePath': 'assets/images/doctors/surgery.png',
    },
    {
      'name': 'Dr. Muhammad Azhar Hussain',
      'specialization': 'Consultant Cardiologist',
      'imagePath': 'assets/images/doctors/cardiology.png',
    },
    {
      'name': 'Dr. Bushra',
      'specialization': 'Consultant Paediatrician',
      'imagePath': 'assets/images/doctors/pediatrics.png',
    },
    {
      'name': 'Dr. Omar Bilal Siddiqui',
      'specialization': 'Consultant Pulmonology',
      'imagePath': 'assets/images/doctors/pulmonology.png',
    },
    {
      'name': 'Dr. MD. Yousuf Khan',
      'specialization': 'Consultant Diabetologist',
      'imagePath': 'assets/images/doctors/diabetology.png',
    },
    {
      'name': 'Dr. Tahseen Ara Azad',
      'specialization': 'Consultant Neurocognitive',
      'imagePath': 'assets/images/doctors/neurology.png',
    },
    {
      'name': 'Dr. MD Tayyab Shaik',
      'specialization': 'Consultant Physiotherapist',
      'imagePath': 'assets/images/doctors/physiotherapy.png',
    },
    {
      'name': 'Dr. Quanitha Firdous',
      'specialization': 'Consultant Physiotherpaist',
      'imagePath': 'assets/images/doctors/physiotherapy.png',
    },
    {
      'name': 'Dr. G. Hidayathullah',
      'specialization': 'Consultant Urologist',
      'imagePath': 'assets/images/doctors/urology.png',
    },
    {
      'name': 'Dr. R. K. Rajesh',
      'specialization': 'Consultant Urologist',
      'imagePath': 'assets/images/doctors/urology.png',
    },
    {
      'name': 'Dr. Md. Anwar Ahmed',
      'specialization': 'Consultant Internal Medicine',
      'imagePath': 'assets/images/doctors/general-medicine.png',
    },
    {
      'name': 'Dr. Md. Niyaz Ahmed',
      'specialization': 'Consultant Dermatologist',
      'imagePath': 'assets/images/doctors/dermatology.png',
    },
    {
      'name': 'Dr. Vazeer Uddin',
      'specialization': 'Consultant Senior Trauma Surgeon',
      'imagePath': 'assets/images/doctors/surgery.png',
    },
    {
      'name': 'Dr. Ehsan Ahmed Khan',
      'specialization': 'Consultant Senior Physician',
      'imagePath': 'assets/images/doctors/general-medicine.png',
    },
    {
      'name': 'Dr. Mohammed Yaseen',
      'specialization': 'Consultant Paediatrician & Neonatology',
      'imagePath': 'assets/images/doctors/pediatrics.png',
    },
    {
      'name': 'Dr. Saba Samreen',
      'specialization': 'Consultant Obstetrics & Gynaecologist',
      'imagePath': 'assets/images/doctors/gynecology.png',
    },
    {
      'name': 'Dr. Fouzia Jeelani',
      'specialization': 'Senior Consultant Obstetrics & Gynaecologist',
      'imagePath': 'assets/images/doctors/gynecology.png',
    },
    {
      'name': 'Dr. Fatma Mohammed',
      'specialization': 'Consultant Obstetrician & Gynaecologist',
      'imagePath': 'assets/images/doctors/gynecology.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Doctors'),
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
                    'Meet Our Qualified Doctors',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Expert healthcare professionals dedicated to your well-being',
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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = constraints.maxWidth > 900
                      ? 4
                      : constraints.maxWidth > 600
                          ? 3
                          : 2;
                  double childAspectRatio = constraints.maxWidth > 900
                      ? 0.75
                      : constraints.maxWidth > 600
                          ? 0.7
                          : 0.65;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: childAspectRatio,
                    ),
                    itemCount: doctors.length,
                    itemBuilder: (context, index) {
                      final doctor = doctors[index];
                      return _buildDoctorCard(
                        context,
                        doctor['name']!,
                        doctor['specialization']!,
                        doctor['imagePath']!,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorCard(BuildContext context, String name,
      String specialization, String imagePath) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              imagePath,
              height: 110, // Reduced height for better fit
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 110,
                  color: const Color(0xFF13a8b4),
                  child: const Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF13a8b4),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Flexible(
                    child: Text(
                      specialization,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
