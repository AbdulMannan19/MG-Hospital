import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      'photo_url': '',
      'available_times': ['10:00', '11:00', '12:00', '15:00', '16:00'],
    },
    {
      'id': 2,
      'name': 'Dr. Ahmad Abdul Khabeer',
      'experience': '12+ Years Experience',
      'qualifications': 'MBBS, MS (ENT), DLO',
      'hospital': 'MG Hospital - Banjara Hills',
      'photo_url': '',
      'available_times': ['10:00', '12:00', '14:00', '16:00'],
    },
    {
      'id': 3,
      'name': 'Dr. Mohd Naqi Zain',
      'experience': '10+ Years Experience',
      'qualifications': 'MBBS, MS (Orthopedics)',
      'hospital': 'MG Hospital - Secunderabad',
      'photo_url': '',
      'available_times': ['09:00', '11:00', '13:00', '15:00'],
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
                        onChanged: (value) {
                          final spec = specializationList
                              .firstWhere((s) => s['id'] == value);
                          setState(() {
                            selectedSpecializationName = spec['name'];
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // Doctor Profile Cards
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: doctorList.length,
                itemBuilder: (context, idx) {
                  return DoctorProfileCard(doctor: doctorList[idx]);
                },
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
                    child:
                        const Icon(Icons.person, size: 48, color: Colors.grey),
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
                        final emailController = TextEditingController();
                        final enteredEmail = await showDialog<String>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Enter Your Email'),
                              content: TextField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(emailController.text.trim());
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                        if (enteredEmail != null && enteredEmail.isNotEmpty) {
                          final response = await Supabase.instance.client
                              .from('appointments')
                              .insert({
                            'patientemail': enteredEmail,
                            'doctorname': doctor['name'],
                            'hospitalbranch': doctor['hospital'],
                            'appointmentdate':
                                selectedDate!.toIso8601String().split('T')[0],
                            'appointmenttime': selectedTime,
                          });
                          if (response.error == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Appointment booked with \\${doctor['name']} on \\${selectedDate!.day}/\\${selectedDate!.month}/\\${selectedDate!.year} at \\$selectedTime'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Failed to book appointment: \\${response.error!.message}'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
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
