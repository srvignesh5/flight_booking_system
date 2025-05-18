import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/flight_list_page.dart';
import '../screens/add_flight_page.dart'; 
import '../screens/update_flight_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flight Booking App',
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => RegisterPage(),
        '/flight_list': (context) => const FlightListPage(),
        '/add-flight': (context) => const AddFlightPage(), 
      },

    );
  }
}
