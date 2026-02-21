

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/firestore_service.dart';

class DashboardScreenss extends StatefulWidget {
  final FirestoreService firestoreService;
  const DashboardScreenss({super.key, required this.firestoreService});

  @override
  State<DashboardScreenss> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreenss>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Helper function to show a dialog for features that are not yet implemented.
  void _showFeatureNotAvailable(BuildContext context, String featureName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(featureName),
          content: Text("The '$featureName' feature is coming soon!"),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _animatedWrapper(Widget child) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(position: _slideAnimation, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              "Welcome Back, Admin!",
              style: TextStyle(
                  fontSize: 28, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
            const SizedBox(height: 6),
            const Text(
              "Here's a quick overview of your restaurant dashboard",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // KPI Cards Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _animatedWrapper(_kpiCard("Users", "120", Icons.people, Colors.blue)),
                  const SizedBox(width: 10),
                  _animatedWrapper(_kpiCard("Orders", "45", Icons.shopping_cart, Colors.orange)),
                  const SizedBox(width: 10),
                  _animatedWrapper(_kpiCard("Revenue", "\$5.2K", Icons.attach_money, Colors.green)),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Quick Actions
            const Text(
              "Quick Actions",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _animatedWrapper(
                  _actionCard(
                    "Add Order",
                    Icons.add_shopping_cart,
                    Colors.deepPurple,
                        () => _showFeatureNotAvailable(context, 'Add Order'),
                  ),
                ),
                _animatedWrapper(
                  _actionCard(
                    "Add User",
                    Icons.person_add,
                    Colors.teal,
                        () => _showFeatureNotAvailable(context, 'Add User'),
                  ),
                ),
                _animatedWrapper(
                  _actionCard(
                    "Reports",
                    Icons.bar_chart,
                    Colors.orange,
                        () => _showFeatureNotAvailable(context, 'Reports'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Revenue Chart
            const Text(
              "Revenue Chart",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
            const SizedBox(height: 12),
            _animatedWrapper(
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [
                        Colors.deepPurpleAccent.withOpacity(0.2),
                        Colors.deepPurpleAccent.withOpacity(0.05)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: true,
                        getDrawingHorizontalLine: (value) =>
                            FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1),
                        getDrawingVerticalLine: (value) =>
                            FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              const style = TextStyle(fontSize: 12, color: Colors.black87);
                              Widget text;
                              switch (value.toInt()) {
                                case 0: text = const Text('Mon', style: style); break;
                                case 1: text = const Text('Tue', style: style); break;
                                case 2: text = const Text('Wed', style: style); break;
                                case 3: text = const Text('Thu', style: style); break;
                                case 4: text = const Text('Fri', style: style); break;
                                case 5: text = const Text('Sat', style: style); break;
                                case 6: text = const Text('Sun', style: style); break;
                                default: text = const Text('', style: style); break;
                              }
                              return SideTitleWidget(axisSide: meta.axisSide, child: text);
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            interval: 2,
                            getTitlesWidget: (value, meta) => Text(
                              '${value.toInt()}K',
                              style: const TextStyle(fontSize: 12, color: Colors.black54),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      minX: 0,
                      maxX: 6,
                      minY: 0,
                      maxY: 10,
                      lineBarsData: [
                        LineChartBarData(
                          spots: const [
                            FlSpot(0, 3), FlSpot(1, 4), FlSpot(2, 3.5), FlSpot(3, 5),
                            FlSpot(4, 4.5), FlSpot(5, 6), FlSpot(6, 5.5),
                          ],
                          isCurved: true,
                          gradient: const LinearGradient(
                              colors: [Colors.greenAccent, Colors.green]),
                          barWidth: 4,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                Colors.greenAccent.withOpacity(0.3),
                                Colors.green.withOpacity(0.0)
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // KPI Card Widget
  Widget _kpiCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Container(
        width: 125,
        height: 125,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.2), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color), // Reduced icon size
            const SizedBox(height: 6), // Adjusted spacing
            Text(value,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(fontSize: 14, color: Colors.black87)),
          ],
        ),
      ),
    );
  }

  // Quick Action Card Widget
  Widget _actionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Container(
          width: 100,
          height: 100,
          padding: const EdgeInsets.all(12), // Reduced padding
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.2), Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28, color: color),
              const SizedBox(height: 8),
              Flexible( // Wrapped Text with Flexible to prevent overflow
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold, color: color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


