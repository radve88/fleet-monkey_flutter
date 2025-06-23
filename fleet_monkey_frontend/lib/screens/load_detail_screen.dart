import 'package:flutter/material.dart';
import '../services/api_service.dart';

class LoadDetailScreen extends StatefulWidget {
  final int loadId;

  const LoadDetailScreen({super.key, required this.loadId});

  @override
  State<LoadDetailScreen> createState() => _LoadDetailScreenState();
}

class _LoadDetailScreenState extends State<LoadDetailScreen> {
  Map<String, dynamic>? master;
  List<dynamic> trailers = [];

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    final data = await ApiService.getLoadDetails(widget.loadId);
    setState(() {
      master = data['master'];
      trailers = data['trailers'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Load ${widget.loadId}')),
      body: master == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Load Code: ${master!['LoadCode']}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('Status: ${master!['ParcelDeliveryStatus']}'),
                      Text('Driver: ${master!['Driver']}'),
                      Text('Truck: ${master!['Truck Registration']}'),
                      Text('Company: ${master!['CompanyName']}'),
                      Text('From: ${master!['Origin AddressName']}'),
                      Text('To: ${master!['Destination AddressName']}'),
                      Text('Available: ${master!['AvailableToLoadDateTime']}'),
                      Text('Weight: ${master!['Weight']} | Volume: ${master!['Volume']}'),
                      const Divider(height: 20, thickness: 1),
                      const Text('Trailer Details:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: trailers.length,
                    itemBuilder: (context, index) {
                      final t = trailers[index];
                      return Card(
                        child: ListTile(
                          title: Text('Trailer ID: ${t['TrailerID']}'),
                          subtitle: Text('LoadTrailerID: ${t['LoadTrailerID']}'),
                          trailing: ElevatedButton(
                            onPressed: () {
                              // Future action for scan
                            },
                            child: const Text('Scan'),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
