import 'package:flutter/material.dart';
import 'api.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  int selectedDateIndex = -1;
  int selectedTimeIndex = -1;
  String? selectedBranchName;
  int? selectedBranchId;
  String? selectedSpecializationName;
  int? selectedSpecializationId;
  String? selectedDay;

  List<Map<String, dynamic>> branchList = [];
  List<Map<String, dynamic>> specializationList = [];
  List<String> days = [];
  List<String> times = [];

  bool isLoading = false;
  bool isBooking = false;

  // Cache maps
  final Map<String, List<Map<String, dynamic>>> _specializationCache = {};
  final Map<String, List<String>> _daysCache = {};
  final Map<String, List<String>> _timesCache = {};
  List<Map<String, dynamic>>? _branchCache;

  final AppointmentApiService apiService = AppointmentApiService();

  List<Map<String, dynamic>> doctorList = [
    {
      'id': 1,
      'name': 'Dr Aadithya Rangarajan',
      'experience': '5+ Years Experience',
      'qualifications':
          'MBBS, MS in General Surgery, MCh in Plastic Surgery | Cosmetology & Plastic Surgery',
      'hospital': 'Apollo Adlux Hospital',
      'photo_url': '',
      'available_times': ['10:00', '11:00', '12:00', '15:00', '16:00'],
    },
    {
      'id': 2,
      'name': 'Dr Aakanksha Chawla Jain',
      'experience': '9+ Years Experience',
      'qualifications':
          'MD (Pulmonary Medicine), IDCCM, FCCM (Indian Fellowship in Critical Care Medicine) | Pulmonology',
      'hospital': 'Apollo Hospitals, Bilaspur',
      'photo_url': '',
      'available_times': ['10:00', '12:00', '14:00', '16:00'],
    },
    {
      'id': 3,
      'name': 'Dr Aakash Garg',
      'experience': '1+ Years Experience',
      'qualifications':
          'MBBS, DNB (MED), DNB (GASTRO) | Gastroenterology & Hepatology',
      'hospital': 'Apollo Hospitals, Bilaspur',
      'photo_url': '',
      'available_times': ['09:00', '11:00', '13:00', '15:00'],
    },
  ];

  @override
  void initState() {
    super.initState();
    fetchBranches();
  }

  Future<void> fetchBranches() async {
    setState(() {
      isLoading = true;
    });
    try {
      if (_branchCache != null) {
        branchList = _branchCache!;
        setState(() {
          isLoading = false;
        });
        return;
      }
      branchList = await apiService.getBranches();
      _branchCache = branchList;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching branches: $e');
    }
  }

  Future<void> fetchSpecializations(String branchName) async {
    setState(() {
      isLoading = true;
    });
    try {
      if (_specializationCache.containsKey(branchName)) {
        specializationList = _specializationCache[branchName]!;
        setState(() {
          isLoading = false;
        });
        return;
      }
      specializationList = await apiService.getSpecializations(branchName);
      _specializationCache[branchName] = specializationList;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      specializationList = [];
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchDays(int branchId, int specializationId) async {
    setState(() {
      isLoading = true;
    });
    final cacheKey = '$branchId-$specializationId';
    try {
      if (_daysCache.containsKey(cacheKey)) {
        days = _daysCache[cacheKey]!;
        setState(() {
          isLoading = false;
        });
        return;
      }
      days = await apiService.getDays(branchId, specializationId);
      _daysCache[cacheKey] = days;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      days = [];
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchTimes(
      int branchId, int specializationId, String day) async {
    setState(() {
      isLoading = true;
    });
    final cacheKey = '$branchId-$specializationId-$day';
    try {
      if (_timesCache.containsKey(cacheKey)) {
        times = _timesCache[cacheKey]!;
        setState(() {
          isLoading = false;
        });
        return;
      }
      times = await apiService.getTimeSlots(branchId, specializationId, day);
      _timesCache[cacheKey] = times;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      times = [];
      setState(() {
        isLoading = false;
      });
    }
  }

  void _confirmAppointment() async {
    if (selectedBranchId == null ||
        selectedSpecializationId == null ||
        selectedDay == null ||
        selectedTimeIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select all fields to book an appointment.')),
      );
      return;
    }
    setState(() {
      isBooking = true;
    });
    await Future.delayed(const Duration(seconds: 2)); // Simulate booking
    setState(() {
      isBooking = false;
    });
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Appointment Confirmed'),
        content: Text(
            'Your appointment is booked for $selectedDay at ${times[selectedTimeIndex]}.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Appointment"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
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
                                  value: selectedBranchId,
                                  hint: const Text("Choose a branch"),
                                  items: branchList.isEmpty
                                      ? []
                                      : branchList
                                          .map<DropdownMenuItem<int>>(
                                              (branch) => DropdownMenuItem<int>(
                                                    value: branch['id'],
                                                    child: Row(
                                                      children: [
                                                        const Icon(
                                                            Icons.location_city,
                                                            size: 18),
                                                        const SizedBox(
                                                            width: 8),
                                                        Text(branch['name']),
                                                      ],
                                                    ),
                                                  ))
                                          .toList(),
                                  onChanged: isLoading
                                      ? null
                                      : (value) {
                                          final branch = branchList.firstWhere(
                                              (b) => b['id'] == value);
                                          setState(() {
                                            selectedBranchId = value;
                                            selectedBranchName = branch['name'];
                                            selectedSpecializationId = null;
                                            selectedSpecializationName = null;
                                            selectedDay = null;
                                            selectedDateIndex = -1;
                                            selectedTimeIndex = -1;
                                            specializationList = [];
                                            days = [];
                                            times = [];
                                          });
                                          if (value != null) {
                                            fetchSpecializations(
                                                branch['name']);
                                          }
                                        },
                                ),
                                if (branchList.isEmpty)
                                  const Padding(
                                    padding: EdgeInsets.only(top: 8.0),
                                    child: Text('No branches available.',
                                        style: TextStyle(color: Colors.red)),
                                  ),
                                const SizedBox(height: 16),
                                // Specialization Dropdown
                                DropdownButtonFormField<int>(
                                  value: selectedSpecializationId,
                                  hint: const Text("Choose specialization"),
                                  items: specializationList.isEmpty
                                      ? []
                                      : specializationList
                                          .map<DropdownMenuItem<int>>((spec) =>
                                              DropdownMenuItem<int>(
                                                value: spec['id'],
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                        Icons.medical_services,
                                                        size: 18),
                                                    const SizedBox(width: 8),
                                                    Text(spec['name']),
                                                  ],
                                                ),
                                              ))
                                          .toList(),
                                  onChanged: (selectedBranchId == null ||
                                          isLoading)
                                      ? null
                                      : (value) {
                                          final spec =
                                              specializationList.firstWhere(
                                                  (s) => s['id'] == value);
                                          setState(() {
                                            selectedSpecializationId = value;
                                            selectedSpecializationName =
                                                spec['name'];
                                            selectedDay = null;
                                            selectedDateIndex = -1;
                                            selectedTimeIndex = -1;
                                            days = [];
                                            times = [];
                                          });
                                          if (selectedBranchId != null &&
                                              value != null) {
                                            fetchDays(selectedBranchId!, value);
                                          }
                                        },
                                ),
                                if (specializationList.isEmpty &&
                                    selectedBranchId != null)
                                  const Padding(
                                    padding: EdgeInsets.only(top: 8.0),
                                    child: Text('No specializations available.',
                                        style: TextStyle(color: Colors.red)),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        // Days Horizontal List
                        if (days.isNotEmpty)
                          SizedBox(
                            height: 80,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: days.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedDateIndex = index;
                                      selectedDay = days[index];
                                      selectedTimeIndex = -1;
                                      times = [];
                                    });
                                    if (selectedBranchId != null &&
                                        selectedSpecializationId != null &&
                                        selectedDay != null) {
                                      fetchTimes(
                                          selectedBranchId!,
                                          selectedSpecializationId!,
                                          selectedDay!);
                                    }
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    width: 90,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    decoration: BoxDecoration(
                                      color: selectedDateIndex == index
                                          ? const Color(0xff13a8b4)
                                          : const Color.fromARGB(
                                              255, 243, 243, 243),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Center(
                                      child: Text(
                                        days[index],
                                        style: TextStyle(
                                          color: selectedDateIndex == index
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        if (days.isEmpty && selectedSpecializationId != null)
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text('No days available.',
                                style: TextStyle(color: Colors.red)),
                          ),
                        const SizedBox(height: 16),
                        // Time Slots Grid
                        if (times.isNotEmpty)
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  constraints.maxWidth > 600 ? 4 : 3,
                              childAspectRatio: 2.5,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                            ),
                            itemCount: times.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedTimeIndex = index;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  decoration: BoxDecoration(
                                    color: selectedTimeIndex == index
                                        ? const Color(0xff13a8b4)
                                        : const Color.fromARGB(
                                            255, 242, 242, 242),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Center(
                                    child: Text(
                                      times[index],
                                      style: TextStyle(
                                        color: selectedTimeIndex == index
                                            ? Colors.white
                                            : const Color.fromARGB(
                                                255, 0, 0, 0),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        if (times.isEmpty && selectedDay != null)
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text('No time slots available.',
                                style: TextStyle(color: Colors.red)),
                          ),
                        const SizedBox(height: 24),
                        // Doctor Profile Cards
                        if (selectedSpecializationId != null)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: doctorList.length,
                            itemBuilder: (context, idx) {
                              return DoctorProfileCard(doctor: doctorList[idx]);
                            },
                          ),
                        // Confirm Button
                        Center(
                          child: ElevatedButton.icon(
                            icon: isBooking
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.check),
                            label: const Text('Confirm Appointment'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff13a8b4),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 16),
                              textStyle: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: isBooking ? null : _confirmAppointment,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
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
                  child: doctor['photo_url'] != null &&
                          doctor['photo_url'].toString().isNotEmpty
                      ? Image.network(doctor['photo_url'],
                          width: 72, height: 72, fit: BoxFit.cover)
                      : Container(
                          width: 72,
                          height: 72,
                          color: Colors.grey[200],
                          child: const Icon(Icons.person,
                              size: 48, color: Colors.grey),
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
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.amber, size: 20),
                const SizedBox(width: 6),
                Text(
                  (doctor['available_times'] as List).join('  |  '),
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
                const Spacer(),
                const Text('Mon - Sat',
                    style: TextStyle(fontSize: 13, color: Colors.black54)),
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
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Appointment booked with ${doctor['name']} on ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year} at $selectedTime'),
                            backgroundColor: Colors.green,
                          ),
                        );
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
