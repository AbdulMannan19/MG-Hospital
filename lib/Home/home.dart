import 'package:flutter/material.dart';
import '../Profile/profile.dart';
import '../Appointment/appointment_listing.dart';
import '../Contact/contact_info_page.dart';
import '../Hospital/hospital_branches_page.dart';
import '../About Us/about_us_page.dart';
import '../Specialities/specialities_page.dart';
import '../Our Doctors/our_doctors_page.dart';
import '../Appointment/user_appointments.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black, size: 32),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Center(
          child: Image.asset(
            'assets/images/mghospital-logo.png',
            height: 40,
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          // Adding an empty container to balance the leading icon
          Container(width: 48),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('About Us'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AboutUsPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.people),
                title: const Text('Our Doctors'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const OurDoctorsPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.local_hospital),
                title: const Text('Specialities'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SpecialitiesPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Contact Us'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ContactInfoPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.more_horiz),
                title: const Text('User Appointments'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UserAppointmentsPage()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {},
              ),
              const Spacer(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Green gradient area with main content
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final appBarHeight = kToolbarHeight;
                final bottomNavHeight = 64.0;
                final availableHeight =
                    constraints.maxHeight - appBarHeight - bottomNavHeight;
                return Container(
                  width: double.infinity,
                  height: availableHeight > 0
                      ? availableHeight
                      : constraints.maxHeight,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF13a8b4), Color(0xFF3ed2c0)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Best Multi Speciality Hospital in Tolichowki Hyderabad',
                                style: TextStyle(
                                  color: Color(0xFF13a8b4),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            const Text(
                              'Your Health, Our Passion',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 18),
                            const Text(
                              'Muslim General Hospital Tolichowki consists of a highly trained team of medical experts, advanced facilities and unwavering commitment to the welfare of our patients.',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 28),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[900],
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 16),
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AppointmentListingPage()),
                                );
                              },
                              child: const Text('Book An Appointment'),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Image.asset(
                          'assets/images/main.png',
                          height: 260,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Advertisement card
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Text(
                    'Advertisement',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: const Color(0xFF00a0e0),
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _NavItem(
              imagePath: 'assets/images/book_appointment.png',
              label: 'Book Appt.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AppointmentListingPage()),
                );
              },
            ),
            _NavItem(
              imagePath: 'assets/images/hospitals.png',
              label: 'Hospitals',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HospitalBranchesPage()),
                );
              },
            ),
            _NavItem(
              imagePath: 'assets/images/call_us.png',
              label: 'Call Us',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ContactInfoPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onTap;

  const _NavItem({
    required this.imagePath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            imagePath,
            height: 22,
            width: 22,
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
