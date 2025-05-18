import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/flight_model.dart';
import '../services/flight_service.dart';
import '../services/user_service.dart'; 
import '../widgets/app_header_after_login.dart';
import '../widgets/sidebar_menu_after_login.dart';
import '../screens/add_flight_page.dart';
import '../screens/update_flight_page.dart';

class FlightListPage extends StatefulWidget {
  const FlightListPage({super.key});

  @override
  State<FlightListPage> createState() => _FlightListPageState();
}

class _FlightListPageState extends State<FlightListPage> {
  List<Flight> _flights = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFlights();
  }

  Future<void> fetchFlights() async {
    try {
      final flightService = FlightService();
      final flights = await flightService.fetchFlights();
      setState(() {
        _flights = flights;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error fetching flights: $e");
    }
  }

  String formatDate(String isoString) {
    final dateTime = DateTime.parse(isoString).toLocal();
    return DateFormat.Hm().format(dateTime);
  }

Widget buildFlightCard(Flight flight) {
  final departureTime = flight.departureDate;
  final arrivalTime = flight.arrivalDate;
  final duration = arrivalTime.difference(departureTime);
  final durationFormatted = "${duration.inHours}h ${duration.inMinutes.remainder(60)}m";

  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.all(8),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Airline Info ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (flight.logoUrl.isNotEmpty)
                    Image.network(
                      flight.logoUrl,
                      height: 40,
                      width: 40,
                      fit: BoxFit.contain,
                    ),
                  const SizedBox(width: 6),
                  Text(
                    "${flight.airline} (${flight.flightNumber})",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              Text(
                "${flight.availableSeats} seats left",
                style: const TextStyle(fontSize: 12, color: Colors.green),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // --- Departure, Duration, Arrival ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(flight.departureCity, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(DateFormat.jm().format(departureTime)),
                  Text(DateFormat.yMMMd().format(departureTime), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              Column(
                children: [
                  Text(durationFormatted, style: const TextStyle(color: Colors.black54)),
                  const Icon(Icons.flight_takeoff, color: Colors.grey),
                  const Text("Non Stop", style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(flight.arrivalCity, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(DateFormat.jm().format(arrivalTime)),
                  Text(DateFormat.yMMMd().format(arrivalTime), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ],
          ),

          const Divider(height: 24),

          // --- Price and Book Button ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Economy · Refundable", style: TextStyle(fontSize: 12, color: Colors.grey)),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.work_outline, size: 16, color: Colors.grey),
                        SizedBox(width: 4),
                        Text("Hand: 7 Kg", style: TextStyle(fontSize: 12, color: Colors.grey)),
                        SizedBox(width: 12),
                        Icon(Icons.luggage, size: 16, color: Colors.grey),
                        SizedBox(width: 4),
                        Text("Check-in: 15 Kg", style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Text(
                    "₹ ${flight.price}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.deepOrange,
      ),
    ),
  ],
),

            ],
          ),

          const SizedBox(height: 12),
          const Divider(),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
      ElevatedButton.icon(
  onPressed: () async {
    print("Update flight: ${flight.objectId}");

    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UpdateFlightPage(flight: flight)),
    );

    if (result == true) {
      setState(() {
        fetchFlights(); 
      });
    }
  },
  icon: const Icon(Icons.edit),
  label: const Text("Update"),
  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
),

              ElevatedButton.icon(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Flight'),
                      content: const Text('Are you sure you want to delete this flight?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await FlightService().deleteFlight(flight.objectId!);
                    fetchFlights(); 
                  }
                },
                icon: const Icon(Icons.delete),
                label: const Text("Delete"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red ,foregroundColor: Colors.white),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}


  void _logout() async {
    UserService().clearToken();
    Navigator.pushReplacementNamed(context, '/login');
  }


   void _onSelectMenuItem(String title) {
    Navigator.pop(context);
    if (title == "Logout") {
      _logout();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$title selected')));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeaderAfterLogin(),
      drawer: SideBarMenuAfterLogin(onMenuItemSelected: _onSelectMenuItem),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _flights.isEmpty
              ? const Center(child: Text("No flights available."))
              : ListView.builder(
                  itemCount: _flights.length,
                  itemBuilder: (context, index) {
                    return buildFlightCard(_flights[index]);
                  },
                ),

        floatingActionButton: FloatingActionButton(
      onPressed: () async {
        final result = await Navigator.pushNamed(context, '/add-flight');
        if (result == true) {
          fetchFlights(); 
        }
      },
      child: const Icon(Icons.add),
      tooltip: 'Add New Flight',
    ),
    );
  }
}
