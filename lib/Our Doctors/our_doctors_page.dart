import 'package:flutter/material.dart';
import '../Appointment/appointment_listing.dart';

class OurDoctorsPage extends StatelessWidget {
  const OurDoctorsPage({super.key});

  // Doctor data moved to a list for maintainability
  static final List<Map<String, String>> doctors = [
    {
      'name': 'Dr. Mohammed Ateeq Ur Rahman',
      'specialization': 'Consultant Neurology & Stroke Specialist',
      'imagePath':
          'assets/images/doctor_images/mg-hospital-dr-mohammed-ateeq-ur-rahman (1).jpeg',
    },
    {
      'name': 'Dr. Ahmad Abdul Khabeer',
      'specialization': 'Consultant ENT, Head & Neck, Skull Base Surgeon',
      'imagePath':
          'assets/images/doctor_images/mg-hospital-dr-ahmad-abdul-khabeer (1).jpeg',
    },
    {
      'name': 'Dr. Mohd Naqi Zain',
      'specialization': 'Consultant General & Laparoscopic Surgeon',
      'imagePath':
          'assets/images/doctor_images/mg-hospital-dr-mohd-naqi-zain (1).jpeg',
    },
    {
      'name': 'Dr. Muhammad Azhar Hussain',
      'specialization': 'Consultant Cardiologist',
      'imagePath':
          'assets/images/doctor_images/mg-hospital-dr-muhammad-azhar-hussain.jpeg',
    },
    {
      'name': 'Dr. Bushra',
      'specialization': 'Consultant Paediatrician',
      'imagePath': 'assets/images/doctor_images/mg-hospital-dr-bushra.jpeg',
    },
    {
      'name': 'Dr. Omar Bilal Siddiqui',
      'specialization': 'Consultant Pulmonology',
      'imagePath':
          'assets/images/doctor_images/mg-hospital-dr-omar-bilal-siddiqui.jpeg',
    },
    {
      'name': 'Dr. MD. Yousuf Khan',
      'specialization': 'Consultant Diabetologist',
      'imagePath':
          'assets/images/doctor_images/mg-hospital-dr-md-yousuf-khan.jpeg',
    },
    {
      'name': 'Dr. Tahseen Ara Azad',
      'specialization': 'Consultant Neurocognitive',
      'imagePath':
          'assets/images/doctor_images/mg-hospital-dr-tahseen-ara-azad.jpeg',
    },
    {
      'name': 'Dr. MD Tayyab Shaik',
      'specialization': 'Consultant Physiotherapist',
      'imagePath':
          'assets/images/doctor_images/mg-hospital-dr-mohammed-tayyab-shaik.jpeg',
    },
    {
      'name': 'Dr. Quanitha Firdous',
      'specialization': 'Consultant Physiotherpaist',
      'imagePath':
          'assets/images/doctor_images/mg-hospital-dr-quanitha-firdous.jpeg',
    },
    {
      'name': 'Dr. G. Hidayathullah',
      'specialization': 'Consultant Urologist',
      'imagePath':
          'assets/images/doctor_images/mg-hospital-dr-hidayathullah.jpeg',
    },
    {
      'name': 'Dr. R. K. Rajesh',
      'specialization': 'Consultant Urologist',
      'imagePath': 'assets/images/doctor_images/mg-hospital-dr-r-k-rajesh.jpeg',
    },
    {
      'name': 'Dr. Md. Anwar Ahmed',
      'specialization': 'Consultant Internal Medicine',
      'imagePath':
          'assets/images/doctor_images/mg-hospital-dr-md-anwar-ahmed.jpeg',
    },
    {
      'name': 'Dr. Md. Niyaz Ahmed',
      'specialization': 'Consultant Dermatologist',
      'imagePath':
          'assets/images/doctor_images/mg-hospital-dr-md-niyaz-ahmed.jpeg',
    },
    {
      'name': 'Dr. Vazeer Uddin',
      'specialization': 'Consultant Senior Trauma Surgeon',
      'imagePath':
          'assets/images/doctor_images/mg-hospital-dr-vazeer-uddin.jpeg',
    },
    {
      'name': 'Dr. Ehsan Ahmed Khan',
      'specialization': 'Consultant Senior Physician',
      'imagePath':
          'assets/images/doctor_images/mg-hospital-dr-ehsan-ahmed-khan.jpeg',
    },
    {
      'name': 'Dr. Mohammed Yaseen',
      'specialization': 'Consultant Paediatrician & Neonatology',
      'imagePath':
          'assets/images/doctor_images/mg-hospital-dr-mohammed-yaseen.jpeg',
    },
    {
      'name': 'Dr. Saba Samreen',
      'specialization': 'Consultant Obstetrics & Gynaecologist',
      'imagePath':
          'assets/images/doctor_images/mg-hospital-dr-saba-samreen.jpeg',
    },
    {
      'name': 'Dr. Fouzia Jeelani',
      'specialization': 'Senior Consultant Obstetrics & Gynaecologist',
      'imagePath':
          'assets/images/doctor_images/mg-hospital-dr-fouzia-jeelani.jpeg',
    },
    {
      'name': 'Dr. Fatma Mohammed',
      'specialization': 'Consultant Obstetrician & Gynaecologist',
      'imagePath':
          'assets/images/doctor_images/mg-hospital-dr-fatma-mohammed.jpeg',
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
                      ? 0.55
                      : constraints.maxWidth > 600
                          ? 0.5
                          : 0.45;
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
        mainAxisSize: MainAxisSize.min, // Let the card size to its content
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              color: Colors.grey[100],
            ),
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                imagePath,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 140,
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
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF13a8b4),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  specialization,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
