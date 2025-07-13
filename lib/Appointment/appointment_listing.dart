import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/user_service.dart';

void showSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 80),
          SizedBox(height: 16),
          Text(
            'Thank you!',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Your appointment has been booked successfully.'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

int calculateAge(String dateOfBirth) {
  final dob = DateTime.tryParse(dateOfBirth);
  if (dob == null) return 0;
  final today = DateTime.now();
  int age = today.year - dob.year;
  if (today.month < dob.month ||
      (today.month == dob.month && today.day < dob.day)) {
    age--;
  }
  return age;
}

class AppointmentListingPage extends StatefulWidget {
  const AppointmentListingPage({super.key});

  @override
  _AppointmentListingPageState createState() => _AppointmentListingPageState();
}

class _AppointmentListingPageState extends State<AppointmentListingPage> {
  String? selectedBranchName;
  String? selectedSpecializationName;

  // Hardcoded lists
  final List<Map<String, dynamic>> branchList = [
    {'id': 1, 'name': 'MG Hospital - Tolichowki'},
    {'id': 2, 'name': 'MG Hospital - Banjara Hills'},
    {'id': 3, 'name': 'MG Hospital - Secunderabad'},
  ];

  final List<Map<String, dynamic>> specializationList = [
    {'id': 1, 'name': 'Cardiology'},
    {'id': 2, 'name': 'Neurology'},
    {'id': 3, 'name': 'Orthopedics'},
    {'id': 4, 'name': 'Pediatrics'},
    {'id': 5, 'name': 'Dermatology'},
    {'id': 6, 'name': 'Gynecology'},
  ];

  List<Map<String, dynamic>> doctorList = [
    {
      'id': 1,
      'name': 'Dr. Mohammed Ateeq Ur Rahman',
      'experience': '15+ Years Experience',
      'qualifications': 'MBBS, MD, DM (Cardiology)',
      'hospital': 'MG Hospital - Tolichowki',
      'photo_url': 'assets/images/mg-hospital-dr-mohammed-ateeq-ur-rahman.jpeg',
      'available_times': ['10:00', '11:00', '12:00', '15:00', '16:00'],
      'specialization': 'Cardiology',
    },
    {
      'id': 2,
      'name': 'Dr. Ahmad Abdul Khabeer',
      'experience': '12+ Years Experience',
      'qualifications': 'MBBS, MS (ENT), DLO',
      'hospital': 'MG Hospital - Banjara Hills',
      'photo_url': 'assets/images/mg-hospital-dr-ahmad-abdul-khabeer.jpeg',
      'available_times': ['10:00', '12:00', '14:00', '16:00'],
      'specialization': 'ENT',
    },
    {
      'id': 3,
      'name': 'Dr. Mohd Naqi Zain',
      'experience': '10+ Years Experience',
      'qualifications': 'MBBS, MS (Orthopedics)',
      'hospital': 'MG Hospital - Secunderabad',
      'photo_url': 'assets/images/mg-hospital-dr-mohd-naqi-zain.jpeg',
      'available_times': ['09:00', '11:00', '13:00', '15:00'],
      'specialization': 'Orthopedics',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Appointment"),
        backgroundColor: const Color(0xFF13a8b4),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Branch Dropdown
                      DropdownButtonFormField<int>(
                        value: null,
                        hint: const Text("Choose a branch"),
                        items: branchList.map<DropdownMenuItem<int>>((branch) {
                          return DropdownMenuItem<int>(
                            value: branch['id'],
                            child: Row(
                              children: [
                                const Icon(Icons.location_city, size: 18),
                                const SizedBox(width: 8),
                                Text(branch['name']),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          final branch =
                              branchList.firstWhere((b) => b['id'] == value);
                          setState(() {
                            selectedBranchName = branch['name'];
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      // Specialization Dropdown
                      DropdownButtonFormField<int>(
                        value: null,
                        hint: const Text("Choose specialization"),
                        items: specializationList
                            .map<DropdownMenuItem<int>>((spec) {
                          return DropdownMenuItem<int>(
                            value: spec['id'],
                            child: Row(
                              children: [
                                const Icon(Icons.medical_services, size: 18),
                                const SizedBox(width: 8),
                                Text(spec['name']),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: selectedBranchName == null
                            ? null
                            : (value) {
                                final spec = specializationList
                                    .firstWhere((s) => s['id'] == value);
                                setState(() {
                                  selectedSpecializationName = spec['name'];
                                });
                              },
                        disabledHint: const Text('Select branch first'),
                      ),
                    ],
                  ),
                ),
              ),
              // Doctor Profile Cards
              if (selectedBranchName != null &&
                  selectedSpecializationName != null)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: doctorList.length,
                  itemBuilder: (context, idx) {
                    return DoctorProfileCard(doctor: doctorList[idx]);
                  },
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: Center(
                    child: Text(
                      'Please select both a branch and specialization to see available doctors.',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class DoctorProfileCard extends StatefulWidget {
  final Map<String, dynamic> doctor;
  const DoctorProfileCard({required this.doctor, Key? key}) : super(key: key);

  @override
  State<DoctorProfileCard> createState() => _DoctorProfileCardState();
}

class _DoctorProfileCardState extends State<DoctorProfileCard> {
  DateTime? selectedDate;
  String? selectedTime;

  @override
  Widget build(BuildContext context) {
    final doctor = widget.doctor;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 72,
                    height: 72,
                    color: Colors.grey[200],
                    child: Image.asset(
                      doctor['photo_url'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.person,
                            size: 48, color: Colors.grey);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doctor['name'] ?? '',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17)),
                      const SizedBox(height: 4),
                      Text(doctor['experience'] ?? '',
                          style: const TextStyle(
                              fontSize: 13, color: Colors.teal)),
                      const SizedBox(height: 4),
                      Text(doctor['qualifications'] ?? '',
                          style: const TextStyle(fontSize: 12)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 16, color: Colors.blue),
                          const SizedBox(width: 4),
                          Text(doctor['hospital'] ?? '',
                              style: const TextStyle(fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.calendar_today, size: 18),
                    label: Text(selectedDate == null
                        ? 'Select Date'
                        : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 30)),
                      );
                      if (picked != null) {
                        setState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.access_time, size: 18),
                    label: Text(selectedTime ?? 'Select Time'),
                    onPressed: () async {
                      final times =
                          List<String>.from(doctor['available_times'] ?? []);
                      final time = await showModalBottomSheet<String>(
                        context: context,
                        builder: (context) {
                          return ListView(
                            shrinkWrap: true,
                            children: times
                                .map((t) => ListTile(
                                      title: Text(t),
                                      onTap: () => Navigator.pop(context, t),
                                    ))
                                .toList(),
                          );
                        },
                      );
                      if (time != null) {
                        setState(() {
                          selectedTime = time;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD600),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                onPressed: (selectedDate != null && selectedTime != null)
                    ? () async {
                        final userService = context.read<UserService>();
                        final user = userService.firebaseUser;
                        final profile = userService.profile;

                        if (user == null || profile == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Please login to book an appointment')),
                          );
                          return;
                        }

                        final age = calculateAge(profile.dateOfBirth ?? '');
                        String genderText = '';
                        if (profile.gender == '1' || profile.gender == 1) {
                          genderText = 'Male';
                        } else if (profile.gender == '2' ||
                            profile.gender == 2) {
                          genderText = 'Female';
                        } else {
                          genderText = profile.gender ?? '';
                        }

                        final response = await Supabase.instance.client
                            .from('appointments')
                            .insert({
                          'patient_id': user.uid,
                          'patient_name': profile.name ?? '',
                          'patient_age': age,
                          'patient_gender': genderText,
                          'hospital': doctor['hospital'],
                          'specialization': doctor['specialization'] ?? '',
                          'doctor_name': doctor['name'],
                          'appointment_date':
                              selectedDate!.toIso8601String().split('T')[0],
                          'appointment_time': selectedTime,
                          'status': 'in review',
                        });

                        if (response.error != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Failed to book appointment: \\${response.error!.message}')),
                          );
                        } else {
                          showSuccessDialog(context);
                        }
                      }
                    : null,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('BOOK APPOINTMENT'),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
