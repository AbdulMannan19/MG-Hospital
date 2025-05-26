import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppointmentSettingsPage extends StatefulWidget {
  const AppointmentSettingsPage({super.key});

  @override
  State<AppointmentSettingsPage> createState() => _AppointmentSettingsPageState();
}

class _AppointmentSettingsPageState extends State<AppointmentSettingsPage> {
  String? selectedBranch;
  String? selectedSpecialization;
  String? selectedDay;
  List<Map<String, dynamic>> branches = [];
  List<Map<String, dynamic>> specializations = [];
  List<Map<String, dynamic>> schedules = [];
  List<Map<String, dynamic>> timeSlots = [];
  Set<String> slotsToAdd = {};
  Set<String> slotsToRemove = {};
  bool isLoading = true;
  bool hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    setState(() => isLoading = true);
    try {
      final branchResponse = await Supabase.instance.client
          .from('hospitalbranch')
          .select('id, name');
      
      final specializationResponse = await Supabase.instance.client
          .from('specialization')
          .select('id, name');

      setState(() {
        branches = (branchResponse as List<dynamic>).cast<Map<String, dynamic>>();
        specializations = (specializationResponse as List<dynamic>).cast<Map<String, dynamic>>();
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    }
  }

  Future<void> loadSchedules() async {
    if (selectedBranch == null || selectedSpecialization == null) return;
    
    setState(() => isLoading = true);
    try {
      final scheduleResponse = await Supabase.instance.client
          .from('schedule')
          .select('id, day_of_week')
          .eq('hospital_branch_id', selectedBranch)
          .eq('specialization_id', selectedSpecialization);

      setState(() {
        schedules = (scheduleResponse as List<dynamic>).cast<Map<String, dynamic>>();
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading schedules: $e')),
      );
    }
  }

  Future<void> loadTimeSlots() async {
    if (selectedBranch == null || selectedSpecialization == null || selectedDay == null) return;

    final schedule = schedules.firstWhere(
      (schedule) => schedule['day_of_week'] == selectedDay,
      orElse: () => {'id': null, 'day_of_week': ''}, // Return empty map instead of null
    );

    final scheduleId = schedule['id'];
    if (scheduleId != null) {
      setState(() => isLoading = true);
      try {
        final timeslotResponse = await Supabase.instance.client
            .from('timeslot')
            .select('id, start_time')
            .eq('schedule_id', scheduleId);

        setState(() {
          timeSlots = (timeslotResponse as List<dynamic>).cast<Map<String, dynamic>>();
          slotsToAdd.clear();
          slotsToRemove.clear();
          hasUnsavedChanges = false;
          isLoading = false;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading time slots: $e')),
        );
      }
    }
  }

  void toggleTimeSlot(String time, bool isCurrentlyAvailable) {
    setState(() {
      if (isCurrentlyAvailable) {
        if (!slotsToAdd.contains(time)) {
          slotsToRemove.add(time);
        }
        slotsToAdd.remove(time);
      } else {
        if (!slotsToRemove.contains(time)) {
          slotsToAdd.add(time);
        }
        slotsToRemove.remove(time);
      }
      hasUnsavedChanges = slotsToAdd.isNotEmpty || slotsToRemove.isNotEmpty;
    });
  }

  Future<void> saveChanges() async {
    if (!hasUnsavedChanges) return;

    final schedule = schedules.firstWhere(
      (schedule) => schedule['day_of_week'] == selectedDay,
    );
    final scheduleId = schedule['id'].toString();

    setState(() => isLoading = true);
    try {
      // Batch delete slots marked for removal
      if (slotsToRemove.isNotEmpty) {
        await Supabase.instance.client
            .from('timeslot')
            .delete()
            .eq('schedule_id', scheduleId)
            .in_('start_time', slotsToRemove.toList());
      }

      // Batch insert new slots
      if (slotsToAdd.isNotEmpty) {
        final slotsToInsert = slotsToAdd.map((time) => {
          'schedule_id': scheduleId,
          'start_time': time,
        }).toList();

        await Supabase.instance.client
            .from('timeslot')
            .insert(slotsToInsert);
      }

      // Reload time slots to refresh the view
      await loadTimeSlots();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Changes saved successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving changes: $e'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() => isLoading = false);
    }
  }

  bool isSlotAvailable(String time) {
    final existsInDatabase = timeSlots.any((slot) => slot['start_time'] == time);
    return (existsInDatabase && !slotsToRemove.contains(time)) || slotsToAdd.contains(time);
  }

  List<String> generateTimeSlots() {
    return [
      '10:00:00', '10:30:00', '11:00:00', '11:30:00',
      '12:00:00', '12:30:00', '13:00:00', '13:30:00',
      '14:00:00', '14:30:00', '15:00:00', '15:30:00',
      '16:00:00', '16:30:00'
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Appointments'),
        actions: [
          if (hasUnsavedChanges)
            TextButton.icon(
              icon: const Icon(Icons.save, color: Colors.white),
              label: const Text('Save Changes', style: TextStyle(color: Colors.white)),
              onPressed: saveChanges,
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasUnsavedChanges)
                    Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(bottom: 16),
                      color: Colors.yellow.shade100,
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline),
                          const SizedBox(width: 8),
                          const Text('You have unsaved changes'),
                          const Spacer(),
                          TextButton(
                            onPressed: saveChanges,
                            child: const Text('Save Now'),
                          ),
                        ],
                      ),
                    ),

                  // Branch Selection
                  DropdownButtonFormField<String>(
                    value: selectedBranch,
                    decoration: const InputDecoration(
                      labelText: 'Select Branch',
                      border: OutlineInputBorder(),
                    ),
                    items: branches.map((branch) {
                      return DropdownMenuItem<String>(
                        value: branch['id'].toString(),
                        child: Text(branch['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedBranch = value;
                        selectedSpecialization = null;
                        selectedDay = null;
                        schedules.clear();
                        timeSlots.clear();
                        slotsToAdd.clear();
                        slotsToRemove.clear();
                        hasUnsavedChanges = false;
                      });
                      if (value != null) loadSchedules();
                    },
                  ),
                  const SizedBox(height: 16),

                  // Specialization Selection
                  DropdownButtonFormField<String>(
                    value: selectedSpecialization,
                    decoration: const InputDecoration(
                      labelText: 'Select Specialization',
                      border: OutlineInputBorder(),
                    ),
                    items: specializations.map((spec) {
                      return DropdownMenuItem<String>(
                        value: spec['id'].toString(),
                        child: Text(spec['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedSpecialization = value;
                        selectedDay = null;
                        schedules.clear();
                        timeSlots.clear();
                        slotsToAdd.clear();
                        slotsToRemove.clear();
                        hasUnsavedChanges = false;
                      });
                      if (value != null) loadSchedules();
                    },
                  ),
                  const SizedBox(height: 16),

                  // Day Selection
                  if (schedules.isNotEmpty)
                    DropdownButtonFormField<String>(
                      value: selectedDay,
                      decoration: const InputDecoration(
                        labelText: 'Select Day',
                        border: OutlineInputBorder(),
                      ),
                      items: schedules.map((schedule) {
                        return DropdownMenuItem<String>(
                          value: schedule['day_of_week'],
                          child: Text(schedule['day_of_week']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedDay = value;
                          timeSlots.clear();
                          slotsToAdd.clear();
                          slotsToRemove.clear();
                          hasUnsavedChanges = false;
                        });
                        if (value != null) loadTimeSlots();
                      },
                    ),
                  const SizedBox(height: 24),

                  // Time Slots Grid
                  if (selectedDay != null) ...[
                    Text(
                      'Available Time Slots',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 2.5,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: generateTimeSlots().length,
                      itemBuilder: (context, index) {
                        final time = generateTimeSlots()[index];
                        final isAvailable = isSlotAvailable(time);

                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isAvailable ? Colors.green : Colors.grey[300],
                            foregroundColor: isAvailable ? Colors.white : Colors.black,
                          ),
                          onPressed: () => toggleTimeSlot(time, isAvailable),
                          child: Text(
                            time.substring(0, 5),
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
    );
  }
} 