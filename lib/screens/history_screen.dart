import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/bottom_navigation.dart';
import '../services/food_service.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> _todayEntries = [];
  List<Map<String, dynamic>> _yesterdayEntries = [];
  List<double> _weeklyData = [100, 200, 250, 400, 700, 600, 300];
  int _averageCalories = 1500;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  void _loadData() async {
    // Load data from API
    // This is a placeholder - implement actual API calls
    setState(() {
      _todayEntries = [
        {'name': 'Sandwich', 'calories': 500, 'type': 'sarapan'},
        {'name': 'Gym', 'duration': 30, 'type': 'exercise'},
      ];
      _yesterdayEntries = [
        {'name': 'Roti Bakar', 'calories': 300, 'type': 'sarapan'},
        {'name': 'Lari Pagi', 'duration': 30, 'type': 'exercise'},
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    'Riwayat Aktivitas',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 24),
                  
                  // Tab Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: Color(0xFFFF6B35),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.grey[600],
                      labelStyle: TextStyle(fontWeight: FontWeight.w600),
                      tabs: [
                        Tab(text: 'Kemarin'),
                        Tab(text: 'Hari Ini'),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Calendar Icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.calendar_today,
                      color: Colors.grey[400],
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildHistoryContent(_yesterdayEntries, 1500),
                  _buildHistoryContent(_todayEntries, 1700),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(currentIndex: 1),
    );
  }

  Widget _buildHistoryContent(List<Map<String, dynamic>> entries, int avgCalories) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Daily Summary
          Text(
            'Harian',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sarapan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        entries.isNotEmpty ? entries[0]['name'] : 'Tidak ada data',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (entries.isNotEmpty && entries[0]['calories'] != null)
                        Text(
                          '${entries[0]['calories']} kkal',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(width: 16),
              
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Olahraga',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        entries.length > 1 ? entries[1]['name'] : 'Tidak ada data',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (entries.length > 1 && entries[1]['duration'] != null)
                        Text(
                          '${entries[1]['duration']} menit',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 32),
          
          // Chart Section
          Text(
            'Grafik',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16),
          
          Container(
            padding: EdgeInsets.all(24),
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
              children: [
                // Bar Chart
                Container(
                  height: 200,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 800,
                      barTouchData: BarTouchData(enabled: false),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              const style = TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              );
                              Widget text;
                              switch (value.toInt()) {
                                case 0:
                                  text = Text('S', style: style);
                                  break;
                                case 1:
                                  text = Text('S', style: style);
                                  break;
                                case 2:
                                  text = Text('R', style: style);
                                  break;
                                case 3:
                                  text = Text('K', style: style);
                                  break;
                                case 4:
                                  text = Text('J', style: style);
                                  break;
                                case 5:
                                  text = Text('S', style: style);
                                  break;
                                case 6:
                                  text = Text('M', style: style);
                                  break;
                                default:
                                  text = Text('', style: style);
                                  break;
                              }
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                space: 16,
                                child: text,
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: _weeklyData.asMap().entries.map((entry) {
                        return BarChartGroupData(
                          x: entry.key,
                          barRods: [
                            BarChartRodData(
                              toY: entry.value,
                              color: Color(0xFFFF6B35),
                              width: 16,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
                
                SizedBox(height: 24),
                
                // Average
                Row(
                  children: [
                    Text(
                      'Rata-rata Harian ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '$avgCalories kkal',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          SizedBox(height: 100), // Space for bottom navigation
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}