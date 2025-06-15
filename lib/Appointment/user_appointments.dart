import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: Supabase.instance.client
            .from('appointments')
            .stream(primaryKey: ['id']).order('id', ascending: false),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: \\${snapshot.error}'));
          }
          final appointments = snapshot.data ?? [];
          if (appointments.isEmpty) {
            return const Center(child: Text('No appointments found.'));
          }
          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appt = appointments[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(appt['doctorname'] ?? ''),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Branch: \\${appt['hospitalbranch'] ?? ''}'),
                      Text('Date: \\${appt['appointmentdate'] ?? ''}'),
                      Text('Time: \\${appt['appointmenttime'] ?? ''}'),
                      Text('Email: \\${appt['patientemail'] ?? ''}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          print('Sending mail to \\${appt['patientemail']}');
                          final success = await sendEmailWithSendGrid(
                            toEmail: appt['patientemail'],
                            subject: 'Appointment Confirmed',
                            content:
                                'Your requested appointment with ${appt['doctorname']} on ${appt['appointmentdate']} at ${appt['appointmenttime']} has been accepted.',
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(success
                                  ? 'Confirmation email sent!'
                                  : 'Failed to send email.'),
                              backgroundColor:
                                  success ? Colors.green : Colors.red,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(40, 36),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        child: const Text('Accept'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () async {
                          final success = await sendEmailWithSendGrid(
                            toEmail: appt['patientemail'],
                            subject: 'Appointment Rejected',
                            content:
                                'Your requested appointment with ${appt['doctorname']} on ${appt['appointmentdate']} at ${appt['appointmenttime']} has been rejected.',
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(success
                                  ? 'Rejection email sent!'
                                  : 'Failed to send email.'),
                              backgroundColor:
                                  success ? Colors.green : Colors.red,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(40, 36),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        child: const Text('Reject'),
                      ),
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

  Future<bool> sendEmailWithSendGrid({
    required String toEmail,
    required String subject,
    required String content,
  }) async {
    const sendGridApiKey = 'API_KEY'; // <-- Put your key here
    const fromEmail = 'abdulmannan34695@gmail.com'; // Your verified sender

    final url = Uri.parse('https://api.sendgrid.com/v3/mail/send');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $sendGridApiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'personalizations': [
          {
            'to': [
              {'email': toEmail}
            ],
            'subject': subject,
          }
        ],
        'from': {'email': fromEmail, 'name': 'MG Hospital'},
        'content': [
          {'type': 'text/plain', 'value': content}
        ],
      }),
    );
    return response.statusCode == 202;
  }
}
