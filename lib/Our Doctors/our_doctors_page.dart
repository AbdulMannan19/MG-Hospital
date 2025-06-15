import 'package:flutter/material.dart';
import '../Appointment/appointment_listing.dart';

class OurDoctorsPage extends StatelessWidget {
  const OurDoctorsPage({super.key});

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
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.75,
                children: [
                  _buildDoctorCard(
                    context,
                    'Dr. Mohammed Ateeq Ur Rahman',
                    'Consultant Neurology & Stroke Specialist',
                    'assets/images/doctors/neurology.png',
                  ),
                  _buildDoctorCard(
                    context,
                    'Dr. Ahmad Abdul Khabeer',
                    'Consultant ENT, Head & Neck, Skull Base Surgeon',
                    'assets/images/doctors/ent.png',
                  ),
                  _buildDoctorCard(
                    context,
                    'Dr. Mohd Naqi Zain',
                    'Consultant General & Laparoscopic Surgeon',
                    'assets/images/doctors/surgery.png',
                  ),
                  _buildDoctorCard(
                    context,
                    'Dr. Muhammad Azhar Hussain',
                    'Consultant Cardiologist',
                    'assets/images/doctors/cardiology.png',
                  ),
                  _buildDoctorCard(
                    context,
                    'Dr. Bushra',
                    'Consultant Paediatrician',
                    'assets/images/doctors/pediatrics.png',
                  ),
                  _buildDoctorCard(
                    context,
                    'Dr. Omar Bilal Siddiqui',
                    'Consultant Pulmonology',
                    'assets/images/doctors/pulmonology.png',
                  ),
                  _buildDoctorCard(
                    context,
                    'Dr. MD. Yousuf Khan',
                    'Consultant Diabetologist',
                    'assets/images/doctors/diabetology.png',
                  ),
                  _buildDoctorCard(
                    context,
                    'Dr. Tahseen Ara Azad',
                    'Consultant Neurocognitive',
                    'assets/images/doctors/neurology.png',
                  ),
                  _buildDoctorCard(
                    context,
                    'Dr. MD Tayyab Shaik',
                    'Consultant Physiotherapist',
                    'assets/images/doctors/physiotherapy.png',
                  ),
                  _buildDoctorCard(
                    context,
                    'Dr. Quanitha Firdous',
                    'Consultant Physiotherpaist',
                    'assets/images/doctors/physiotherapy.png',
                  ),
                  _buildDoctorCard(
                    context,
                    'Dr. G. Hidayathullah',
                    'Consultant Urologist',
                    'assets/images/doctors/urology.png',
                  ),
                  _buildDoctorCard(
                    context,
                    'Dr. R. K. Rajesh',
                    'Consultant Urologist',
                    'assets/images/doctors/urology.png',
                  ),
                  _buildDoctorCard(
                    context,
                    'Dr. Md. Anwar Ahmed',
                    'Consultant Internal Medicine',
                    'assets/images/doctors/general-medicine.png',
                  ),
                  _buildDoctorCard(
                    context,
                    'Dr. Md. Niyaz Ahmed',
                    'Consultant Dermatologist',
                    'assets/images/doctors/dermatology.png',
                  ),
                  _buildDoctorCard(
                    context,
                    'Dr. Vazeer Uddin',
                    'Consultant Senior Trauma Surgeon',
                    'assets/images/doctors/surgery.png',
                  ),
                  _buildDoctorCard(
                    context,
                    'Dr. Ehsan Ahmed Khan',
                    'Consultant Senior Physician',
                    'assets/images/doctors/general-medicine.png',
                  ),
                  _buildDoctorCard(
                    context,
                    'Dr. Mohammed Yaseen',
                    'Consultant Paediatrician & Neonatology',
                    'assets/images/doctors/pediatrics.png',
                  ),
                  _buildDoctorCard(
                    context,
                    'Dr. Saba Samreen',
                    'Consultant Obstetrics & Gynaecologist',
                    'assets/images/doctors/gynecology.png',
                  ),
                  _buildDoctorCard(
                    context,
                    'Dr. Fouzia Jeelani',
                    'Senior Consultant Obstetrics & Gynaecologist',
                    'assets/images/doctors/gynecology.png',
                  ),
                  _buildDoctorCard(
                    context,
                    'Dr. Fatma Mohammed',
                    'Consultant Obstetrician & Gynaecologist',
                    'assets/images/doctors/gynecology.png',
                  ),
                ],
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
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 160,
                  color: const Color(0xFF13a8b4),
                  child: const Icon(
                    Icons.person,
                    size: 80,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF13a8b4),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  specialization,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
