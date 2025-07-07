import 'package:flutter/material.dart';
import '../widgets/bottom_navigation.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final user = await AuthService.getUser();
    setState(() {
      _user = user ?? {
        'name': 'Ghazi',
        'email': 'ghazi@email.com',
        'weight': 70,
        'height': 180,
        'birth_date': '17/08/2000',
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              SizedBox(height: 32),
              
              // Header
              Text(
                'Profil',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              SizedBox(height: 32),
              
              // Profile Avatar and Info
              Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    _user?['name'] ?? 'Loading...',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _user?['email'] ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 48),
              
              // Health Data Section
              _buildSection(
                'Data Kesehatan',
                [
                  _buildHealthItem(
                    Icons.monitor_weight_outlined,
                    'Berat Badan',
                    '${_user?['weight'] ?? 70} kg',
                  ),
                  _buildHealthItem(
                    Icons.height,
                    'Tinggi Badan',
                    '${_user?['height'] ?? 180} cm',
                  ),
                  _buildHealthItem(
                    Icons.calendar_today,
                    'Tanggal Lahir',
                    _user?['birth_date'] ?? '17/08/2000',
                  ),
                ],
              ),
              
              SizedBox(height: 32),
              
              // Settings Section
              _buildSection(
                'Pengaturan',
                [
                  _buildSettingItem(
                    Icons.track_changes,
                    'Target & Tujuan',
                    () {
                      // Navigate to target settings
                    },
                  ),
                  _buildSettingItem(
                    Icons.info_outline,
                    'Tentang Aplikasi',
                    () {
                      _showAboutDialog();
                    },
                  ),
                ],
              ),
              
              SizedBox(height: 48),
              
              // Logout Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _handleLogout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Keluar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 100), // Space for bottom navigation
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(currentIndex: 2),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildHealthItem(IconData icon, String title, String value) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[100]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Color(0xFFFF6B35).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              size: 16,
              color: Color(0xFFFF6B35),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[100]!,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Color(0xFFFF6B35).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                size: 16,
                color: Color(0xFFFF6B35),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi'),
          content: Text('Apakah Anda yakin ingin keluar?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                await AuthService.logout();
                Navigator.of(context).pop();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
              child: Text(
                'Keluar',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tentang NUTRIFIT'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('NUTRIFIT v1.0.0'),
              SizedBox(height: 8),
              Text('Aplikasi tracking nutrisi dan kesehatan untuk membantu Anda mencapai gaya hidup sehat.'),
              SizedBox(height: 16),
              Text('© 2024 NUTRIFIT Team'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tutup'),
            ),
          ],
        );
      },
    );
  }
}