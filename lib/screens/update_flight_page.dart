import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/flight_model.dart';
import '../services/flight_service.dart';
import '../widgets/app_header_after_login.dart';
import '../widgets/sidebar_menu_after_login.dart';

class UpdateFlightPage extends StatefulWidget {
  final Flight flight;

  const UpdateFlightPage({super.key, required this.flight});

  @override
  State<UpdateFlightPage> createState() => _UpdateFlightPageState();
}

class _UpdateFlightPageState extends State<UpdateFlightPage> {
  final _formKey = GlobalKey<FormState>();

  final _airlines = ['Indigo', 'Air India'];
  final _cities = [
    'Delhi (DEL)', 'Mumbai (BOM)', 'Bangalore (BLR)', 'Hyderabad (HYD)',
    'Chennai (MAA)', 'Kolkata (CCU)', 'Ahmedabad (AMD)', 'Pune (PNQ)',
    'Goa (GOI)', 'Jaipur (JAI)'
  ];

  final Map<String, String> _airlineLogos = {
    'Indigo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/69/IndiGo_Airlines_logo.svg/2560px-IndiGo_Airlines_logo.svg.png',
    'Air India': 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f7/Air_India.svg/2309px-Air_India.svg.png',
  };

  late String flightNumber;
  late String departureCity;
  late String arrivalCity;
  late DateTime departureDate;
  late DateTime arrivalDate;
  late String airline;
  late int availableSeats;
  late double price;

  @override
  void initState() {
    super.initState();
    final flight = widget.flight;
    flightNumber = flight.flightNumber;
    departureCity = flight.departureCity;
    arrivalCity = flight.arrivalCity;
    departureDate = flight.departureDate;
    arrivalDate = flight.arrivalDate;
    airline = flight.airline;
    availableSeats = flight.availableSeats;
    price = flight.price;
  }

  Future<void> _pickDateTime(bool isDeparture) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: isDeparture ? departureDate : arrivalDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(isDeparture ? departureDate : arrivalDate),
    );
    if (pickedTime == null) return;

    final selectedDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    setState(() {
      if (isDeparture) {
        departureDate = selectedDateTime;
      } else {
        arrivalDate = selectedDateTime;
      }
    });
  }

  String _formatDateTime(DateTime dt) => DateFormat('dd MMM yyyy - hh:mm a').format(dt);

  Future<void> _submitUpdate() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final updatedFlight = Flight(
        objectId: widget.flight.objectId,
        flightNumber: flightNumber,
        departureCity: departureCity,
        arrivalCity: arrivalCity,
        departureDate: departureDate,
        arrivalDate: arrivalDate,
        airline: airline,
        availableSeats: availableSeats,
        price: price,
        logoUrl: _airlineLogos[airline]!,
      );

      await FlightService().updateFlight(updatedFlight);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Flight updated successfully!')),
        );
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeaderAfterLogin(),
      drawer: SideBarMenuAfterLogin(onMenuItemSelected: (_) => Navigator.pop(context)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      'Update Flight Details',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),

                    // Flight Number
                    TextFormField(
                      initialValue: flightNumber,
                      decoration: const InputDecoration(
                        labelText: 'Flight Number',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.flight),
                      ),
                      validator: (val) => val!.isEmpty ? 'Please enter flight number' : null,
                      onSaved: (val) => flightNumber = val!,
                    ),
                    const SizedBox(height: 12),

                    // Departure City
                    DropdownButtonFormField<String>(
                      value: departureCity,
                      decoration: const InputDecoration(
                        labelText: 'Departure City',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.flight_takeoff),
                      ),
                      items: _cities.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (val) => setState(() => departureCity = val!),
                    ),
                    const SizedBox(height: 12),

                    // Arrival City
                    DropdownButtonFormField<String>(
                      value: arrivalCity,
                      decoration: const InputDecoration(
                        labelText: 'Arrival City',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.flight_land),
                      ),
                      items: _cities.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (val) => setState(() => arrivalCity = val!),
                    ),
                    const SizedBox(height: 12),

                    // Departure DateTime
                    InkWell(
                      onTap: () => _pickDateTime(true),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Departure',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(_formatDateTime(departureDate)),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Arrival DateTime
                    InkWell(
                      onTap: () => _pickDateTime(false),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Arrival',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(_formatDateTime(arrivalDate)),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Airline
                    DropdownButtonFormField<String>(
                      value: airline,
                      decoration: const InputDecoration(
                        labelText: 'Airline',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.airplanemode_active),
                      ),
                      items: _airlines.map((a) => DropdownMenuItem(value: a, child: Text(a))).toList(),
                      onChanged: (val) => setState(() => airline = val!),
                    ),
                    const SizedBox(height: 12),

                    // Available Seats
                    TextFormField(
                      initialValue: availableSeats.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Available Seats',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.event_seat),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (val) => val == null || int.tryParse(val) == null ? 'Enter valid number' : null,
                      onSaved: (val) => availableSeats = int.parse(val!),
                    ),
                    const SizedBox(height: 12),

                    // Price
                    TextFormField(
                      initialValue: price.toStringAsFixed(2),
                      decoration: const InputDecoration(
                        labelText: 'Price (₹)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.currency_rupee),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (val) => val == null || double.tryParse(val) == null ? 'Enter valid price' : null,
                      onSaved: (val) => price = double.parse(val!),
                    ),
                    const SizedBox(height: 24),

                    // Update Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.update),
                        label: const Text('Update Flight'),
                        onPressed: _submitUpdate,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
