import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pro_mobile/services/general_service.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GeneralService _generalService = GeneralService();

  List<dynamic> _summary = [
    {
      "total_free": "1",
      "total_pending": "1",
      "total_reserved": "1",
      "total_disabled": "1",
      "total_slot": "1"
    }
  ];

  @override
  void initState() {
    super.initState();
    _getSummary();
  }

  Future<void> _getSummary() async {
    try {
      final response = await _generalService.getSummary().timeout(
            const Duration(seconds: 10),
          );
      if (response.statusCode == 200) {
        setState(() {
          _summary = jsonDecode(response.body);
        });
        debugPrint(_summary[0]['total_free']);
      } else {
        throw Exception(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      debugPrint(e.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SLOT STATUS'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          SizedBox(
            height: 300, // ขยายขนาดของ PieChart
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 50,
                sections: [
                  PieChartSectionData(
                    color: const Color(0xFFE34034), // สีสำหรับ RESERVED
                    value: double.tryParse(_summary[0]["total_reserved"]),
                    title: '',
                    radius: 90,
                    titleStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    badgeWidget:
                        _buildBadge('RESERVED', _summary[0]["total_reserved"]),
                  ),
                  PieChartSectionData(
                    color: const Color(0xFFFFCB30), // สีสำหรับ PENDING
                    value: double.tryParse(_summary[0]["total_pending"]),
                    title: '',
                    radius: 90,
                    titleStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    badgeWidget:
                        _buildBadge('PENDING', _summary[0]["total_pending"]),
                  ),
                  PieChartSectionData(
                    color: const Color(0xFFBCBCBC), // สีสำหรับ DISABLE
                    value: double.tryParse(_summary[0]["total_disabled"]),
                    title: '',
                    radius: 90,
                    titleStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    badgeWidget:
                        _buildBadge('DISABLE', _summary[0]["total_disabled"]),
                  ),
                  PieChartSectionData(
                    color: const Color(0xFF3166B7), // สีสำหรับ FREE
                    value: double.tryParse(_summary[0]["total_free"]),
                    title: '',
                    radius: 90,
                    titleStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    badgeWidget: _buildBadge('FREE', _summary[0]["total_free"]),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Total Slot: ${_summary[0]["total_slot"]}',
              style: const TextStyle(fontSize: 18)),

          // แสดงสัญลักษณ์สีและข้อความ
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegend(const Color(0xFF3166B7), "FREE"),
              const SizedBox(width: 10),
              _buildLegend(const Color(0xFFE34034), "RESERVED"),
              const SizedBox(width: 10),
              _buildLegend(const Color(0xFFFFCB30), "PENDING"),
              const SizedBox(width: 10),
              _buildLegend(const Color(0xFFBCBCBC), "DISABLE"),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }

  // ฟังก์ชันสำหรับสร้างสัญลักษณ์และข้อความ
  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildBadge(String title, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
