import 'package:flutter/material.dart';
import 'api.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


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

  // Cache maps
  final Map<String, List<Map<String, dynamic>>> _specializationCache = {};
  final Map<String, List<String>> _daysCache = {};
  final Map<String, List<String>> _timesCache = {};
  List<Map<String, dynamic>>? _branchCache;

  final AppointmentApiService apiService = AppointmentApiService();

  @override
  void initState() {
    super.initState();
    fetchBranches();
  }

  Future<void> fetchBranches() async {
    try {
      if (_branchCache != null) {
        branchList = _branchCache!;
        setState(() {});
        return;
      }
      branchList = await apiService.getBranches();
      _branchCache = branchList;
      setState(() {});
    } catch (e) {
      print('Error fetching branches: $e');
    }
  }

  Future<void> fetchSpecializations(String branchName) async {
    try {
      if (_specializationCache.containsKey(branchName)) {
        specializationList = _specializationCache[branchName]!;
        setState(() {});
        return;
      }
      specializationList = await apiService.getSpecializations(branchName);
      _specializationCache[branchName] = specializationList;
      setState(() {});
    } catch (e) {
      specializationList = [];
      setState(() {});
    }
  }

  Future<void> fetchDays(int branchId, int specializationId) async {
    final cacheKey = '$branchId-$specializationId';
    try {
      if (_daysCache.containsKey(cacheKey)) {
        days = _daysCache[cacheKey]!;
        setState(() {});
        return;
      }
      days = await apiService.getDays(branchId, specializationId);
      _daysCache[cacheKey] = days;
      setState(() {});
    } catch (e) {
      days = [];
      setState(() {});
    }
  }

  Future<void> fetchTimes(int branchId, int specializationId, String day) async {
    final cacheKey = '$branchId-$specializationId-$day';
    try {
      if (_timesCache.containsKey(cacheKey)) {
        times = _timesCache[cacheKey]!;
        setState(() {});
        return;
      }
      times = await apiService.getTimeSlots(branchId, specializationId, day);
      _timesCache[cacheKey] = times;
      setState(() {});
    } catch (e) {
      times = [];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Appointment"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Branch Dropdown
            DropdownButtonFormField<int>(
              value: selectedBranchId,
              hint: const Text("Choose a branch"),
              items: branchList.map<DropdownMenuItem<int>>((branch) => DropdownMenuItem<int>(
                value: branch['id'],
                child: Text(branch['name']),
              )).toList(),
              onChanged: (value) {
                final branch = branchList.firstWhere((b) => b['id'] == value);
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
                  fetchSpecializations(branch['name']);
                }
              },
            ),
            // Specialization Dropdown
            DropdownButtonFormField<int>(
              value: selectedSpecializationId,
              hint: const Text("Choose specialization"),
              items: specializationList.map<DropdownMenuItem<int>>((spec) => DropdownMenuItem<int>(
                value: spec['id'],
                child: Text(spec['name']),
              )).toList(),
              onChanged: selectedBranchId == null ? null : (value) {
                final spec = specializationList.firstWhere((s) => s['id'] == value);
                setState(() {
                  selectedSpecializationId = value;
                  selectedSpecializationName = spec['name'];
                  selectedDay = null;
                  selectedDateIndex = -1;
                  selectedTimeIndex = -1;
                  days = [];
                  times = [];
                });
                if (selectedBranchId != null && value != null) {
                  fetchDays(selectedBranchId!, value);
                }
              },
            ),
            // Days Horizontal List
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
                      if (selectedBranchId != null && selectedSpecializationId != null && selectedDay != null) {
                        fetchTimes(selectedBranchId!, selectedSpecializationId!, selectedDay!);
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 70,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: selectedDateIndex == index
                            ? const Color(0xff13a8b4)
                            : const Color.fromARGB(255, 243, 243, 243),
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
            // Time Slots Grid
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
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
                            : const Color.fromARGB(255, 242, 242, 242),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          times[index],
                          style: TextStyle(
                            color: selectedTimeIndex == index
                                ? Colors.white
                                : const Color.fromARGB(255, 0, 0, 0),
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
            // Confirm Button (same as before)
          ],
        ),
      ),
    );
  }
}