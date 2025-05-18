import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/flight_model.dart';
import '../services/flight_service.dart';
import '../widgets/app_header_after_login.dart';
import '../widgets/sidebar_menu_after_login.dart';

class AddFlightPage extends StatefulWidget {
  const AddFlightPage({super.key});

  @override
  State<AddFlightPage> createState() => _AddFlightPageState();
}

class _AddFlightPageState extends State<AddFlightPage> {
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

  String flightNumber = '';
  String departureCity = 'Delhi (DEL)';
  String arrivalCity = 'Mumbai (BOM)';
  DateTime departureDate = DateTime.now();
  DateTime arrivalDate = DateTime.now().add(const Duration(hours: 2));
  String airline = 'Indigo';
  int availableSeats = 0;
  double price = 0.0;

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newFlight = Flight(
        objectId: '',
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
      await FlightService().createFlight(newFlight);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Flight added successfully!')),
        );
        Navigator.pop(context, true);
      }
    }
  }

  Future<void> _pickDateTime(BuildContext context, bool isDeparture) async {
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

    final selected = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    setState(() {
      if (isDeparture) {
        departureDate = selected;
      } else {
        arrivalDate = selected;
      }
    });
  }

  String _formatDateTime(DateTime dateTime) =>
      DateFormat('dd MMM yyyy - hh:mm a').format(dateTime);

  void _onSelectMenuItem(String menuItem) {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeaderAfterLogin(),
      drawer: SideBarMenuAfterLogin(onMenuItemSelected: _onSelectMenuItem),
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
                      'Flight Registration',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Flight Number',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.flight),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Flight number is required' : null,
                      onSaved: (value) => flightNumber = value!,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Departure City',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.flight_takeoff),
                      ),
                      value: departureCity,
                      onChanged: (value) => setState(() => departureCity = value!),
                      items: _cities.map((city) => DropdownMenuItem(
                        value: city,
                        child: Text(city),
                      )).toList(),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Arrival City',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.flight_land),
                      ),
                      value: arrivalCity,
                      onChanged: (value) => setState(() => arrivalCity = value!),
                      items: _cities.map((city) => DropdownMenuItem(
                        value: city,
                        child: Text(city),
                      )).toList(),
                    ),
                    const SizedBox(height: 12),
                    _buildDateTimeRow('Departure Date & Time', departureDate, true),
                    const SizedBox(height: 12),
                    _buildDateTimeRow('Arrival Date & Time', arrivalDate, false),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Airline',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.airplanemode_active),
                      ),
                      value: airline,
                      onChanged: (value) => setState(() => airline = value!),
                      items: _airlines
                          .map((air) => DropdownMenuItem(
                                value: air,
                                child: Text(air),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Available Seats',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.event_seat),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value!.isEmpty ? 'Enter number of seats' : null,
                      onSaved: (value) => availableSeats = int.parse(value!),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Ticket Price (₹)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.currency_rupee),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value!.isEmpty ? 'Enter price' : null,
                      onSaved: (value) => price = double.parse(value!),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.check),
                      label: const Text('Create Flight'),
                      style: ElevatedButton.styleFrom(
                   backgroundColor: const Color(0xFF512DA8), // Deep Purple
                                                      foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _submit,
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

  Widget _buildDateTimeRow(String label, DateTime dateTime, bool isDeparture) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            readOnly: true,
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: const Icon(Icons.calendar_today),
              border: const OutlineInputBorder(),
            ),
            controller: TextEditingController(text: _formatDateTime(dateTime)),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.edit_calendar),
          onPressed: () => _pickDateTime(context, isDeparture),
        ),
      ],
    );
  }
}
