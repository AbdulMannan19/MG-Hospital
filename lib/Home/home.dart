import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../Profile/profile.dart';
import '../Appointment/appointment.dart';
import '../Appointment/user_appointments.dart';
import '../Admin/appointment_settings.dart';
import '../Contact/contact_info_page.dart';
import '../Hospital/hospital_branches_page.dart';
import '../About/about_us_page.dart';
import '../Specialities/specialities_page.dart';
import '../Doctors/our_doctors_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
  }

  Future<void> _checkAdminStatus() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final response = await Supabase.instance.client
          .from('users')
          .select('is_admin')
          .eq('id', user.id)
          .single();

      if (mounted) {
        setState(() {
          isAdmin = response['is_admin'] ?? false;
        });
      }
    }
  }

  // Modified _pages list
  static final List<Widget> _pages = <Widget>[
    Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/home_bg.jpeg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Centered overlay image
          Center(
            child: Image.asset(
              'assets/images/main.png',
              width: 800, // Adjust size as needed
              fit: BoxFit.contain,
            ),
          ),
          // Centered text (optional, if you want to keep it)
          const Center(
            child: Text(
              'Welcome to MG Hospital Home',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ],
      ),
    ),
    const Center(
        child: Text('Appointments Page', style: TextStyle(fontSize: 20))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() async {
    await Supabase.instance.client.auth.signOut();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Image.asset(
            'assets/images/mghospital-logo.png',
            fit: BoxFit.contain,
            height: 64,
            width: 64,
          ),
        ),
        title: const SizedBox(),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.black, size: 32),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
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
                title: const Text('More'),
                onTap: () {
               
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Manage User Appointments'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserAppointmentsPage(),
                    ),
                  );
                },
              ),
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
              if (isAdmin)
                ListTile(
                  leading: const Icon(Icons.calendar_month),
                  title: const Text('Manage Appointments'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AppointmentSettingsPage(),
                      ),
                    );
                  },
                ),
              const Spacer(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: _logout,
              ),
            ],
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final appBarHeight = kToolbarHeight;
          final bottomNavHeight = 64.0;
          final availableHeight =
              constraints.maxHeight - appBarHeight - bottomNavHeight;
          return Container(
            width: double.infinity,
            height:
                availableHeight > 0 ? availableHeight : constraints.maxHeight,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                                builder: (context) => const AppointmentPage()),
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
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _NavItem(
              icon: Icons.laptop_mac,
              label: 'Book Appt.',
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AppointmentPage()),
                );
              },
            ),
            _NavItem(
              icon: Icons.local_hospital,
              label: 'Hospitals',
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HospitalBranchesPage()),
                );
              },
            ),
            _NavItem(
              icon: Icons.phone,
              label: 'Call Us',
              color: Colors.blue,
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
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 36, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
