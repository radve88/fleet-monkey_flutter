import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import 'load_detail_screen.dart';

class LoadListScreen extends StatefulWidget {
  const LoadListScreen({super.key});

  @override
  State<LoadListScreen> createState() => _LoadListScreenState();
}

class _LoadListScreenState extends State<LoadListScreen> {
  DateTime? startDate;
  DateTime? endDate;
  int? selectedStatus;
  List<Map<String, dynamic>> loads = [];
  List<Map<String, dynamic>> statuses = [];

  @override
  void initState() {
    super.initState();
    print('Init state called ✅');
    fetchStatuses();
  }

  Future<void> fetchStatuses() async {
  try {
    print('📥 fetchStatuses() called');
    final data = await ApiService.getStatuses();
    print('✅ Statuses fetched: $data');
    setState(() => statuses = data);
  } catch (e) {
    print('❌ Error in fetchStatuses: $e');
  }
}

  Future<void> fetchLoads() async {
    if (startDate != null && endDate != null && selectedStatus != null) {
      final data = await ApiService.getLoads(
        startDate: startDate!,
        endDate: endDate!,
        statusId: selectedStatus!,
      );
      setState(() => loads = data);
    }
  }

  Future<void> pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
        fetchLoads();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fleet Monkey')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => pickDate(isStart: true),
                    child: Text(startDate == null
                        ? 'Start Date'
                        : DateFormat.yMd().format(startDate!)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextButton(
                    onPressed: () => pickDate(isStart: false),
                    child: Text(endDate == null
                        ? 'End Date'
                        : DateFormat.yMd().format(endDate!)),
                  ),
                ),
              ],
            ),
            DropdownButton<int>(
  isExpanded: true,
  hint: const Text('Select Status'),
  value: selectedStatus,
  items: statuses.map<DropdownMenuItem<int>>((status) {
    return DropdownMenuItem<int>(
      value: status['ParcelDeliveryStatusID'],
      child: Text(status['ParcelDeliveryStatus']),
    );
  }).toList(),
  onChanged: (val) {
    setState(() {
      selectedStatus = val;
      fetchLoads(); // Only if needed
    });
  },
),

            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: loads.length,
                itemBuilder: (context, index) {
                  final item = loads[index];
                  return ListTile(
                    title: Text(
                      '${item['LoadCode']} - ${item['ParcelDeliveryStatus']}',
                      style:
                          const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Driver: ${item['Driver']}'),
                        Text('Truck: ${item['Truck Registration']}'),
                        Text('Company: ${item['CompanyName']}'),
                        Text('From: ${item['Origin AddressName']}'),
                        Text('To: ${item['Destination AddressName']}'),
                        Text(
                            'Available: ${item['AvailableToLoadDateTime']}'),
                        Text('Weight: ${item['Weight']} | Volume: ${item['Volume']}'),
                      ],
                    ),
                    isThreeLine: true,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LoadDetailScreen(loadId: item['LoadID']),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
