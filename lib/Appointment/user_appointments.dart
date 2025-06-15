import 'package:flutter/material.dart';

class UserAppointmentsPage extends StatelessWidget {
  const UserAppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Appointments'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          'User Appointments',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
