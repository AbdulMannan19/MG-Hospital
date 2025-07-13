import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/user_service.dart';

class UserAppointmentsPage extends StatelessWidget {
  const UserAppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = provider.Provider.of<UserService>(context);
    final userId = userService.userId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Appointments'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: userId == null
          ? const Center(child: Text('Please login to view your appointments'))
          : StreamBuilder<List<Map<String, dynamic>>>(
              stream: Supabase.instance.client
                  .from('appointments')
                  .stream(primaryKey: ['appointment_id'])
                  .eq('patient_id', userId)
                  .order('appointment_date', ascending: false),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final appointments = snapshot.data ?? [];
                if (appointments.isEmpty) {
                  return const Center(
                    child: Text(
                      'You have not booked any appointments yet.',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    final appt = appointments[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(appt['doctor_name'] ?? ''),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Hospital: ${appt['hospital'] ?? ''}'),
                            Text(
                                'Specialization: ${appt['specialization'] ?? ''}'),
                            Text('Date: ${appt['appointment_date'] ?? ''}'),
                            Text('Time: ${appt['appointment_time'] ?? ''}'),
                            Text('Status: ${appt['status'] ?? ''}'),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
