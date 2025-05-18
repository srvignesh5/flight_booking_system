import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/flight_model.dart';
import 'parse_config.dart';  

class FlightService {
  Future<List<Flight>> fetchFlights() async {
    final response = await http.get(
      Uri.parse('${ParseConfig.baseUrl}/Flights'),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "X-Parse-Application-Id": ParseConfig.appId,
        "X-Parse-REST-API-Key": ParseConfig.apiKey,
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final flights = (jsonData['results'] as List)
          .map((data) => Flight.fromJson(data))
          .toList();
      return flights;
    } else {
      throw Exception('Failed to load flights');
    }
  }

  Future<Flight> fetchFlightDetails(String flightId) async {
    final response = await http.get(
      Uri.parse('${ParseConfig.baseUrl}/Flights/$flightId'),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "X-Parse-Application-Id": ParseConfig.appId,
        "X-Parse-REST-API-Key": ParseConfig.apiKey,
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Flight.fromJson(jsonData);
    } else {
      throw Exception('Failed to load flight details');
    }
  }

  Future<void> createFlight(Flight flight) async {
    final response = await http.post(
      Uri.parse('${ParseConfig.baseUrl}/Flights'),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "X-Parse-Application-Id": ParseConfig.appId,
        "X-Parse-REST-API-Key": ParseConfig.apiKey,
      },
      body: json.encode(flight.toJson()..remove('objectId')),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create flight');
    }
  }


Future<void> updateFlight(Flight flight) async {
  final response = await http.put(
    Uri.parse('${ParseConfig.baseUrl}/Flights/${flight.objectId}'),
    headers: {
      "Content-Type": "application/json; charset=UTF-8",
      "X-Parse-Application-Id": ParseConfig.appId,
      "X-Parse-REST-API-Key": ParseConfig.apiKey,
    },
    body: json.encode(flight.toJson()),
  );

  print('Update response: ${response.statusCode}, body: ${response.body}');

  if (response.statusCode != 200) {
    throw Exception('Failed to update flight');
  }
}

  Future<void> deleteFlight(String flightId) async {
    final response = await http.delete(
      Uri.parse('${ParseConfig.baseUrl}/Flights/$flightId'),
      headers: {
        "X-Parse-Application-Id": ParseConfig.appId,
        "X-Parse-REST-API-Key": ParseConfig.apiKey,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete flight');
    }
  }
}
