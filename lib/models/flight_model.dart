class Flight {
  final String objectId;
  final String flightNumber;
  final String departureCity;
  final String arrivalCity;
  final DateTime departureDate;
  final DateTime arrivalDate;
  final String airline;
  final int availableSeats;
  final double price;
  final String logoUrl;

  Flight({
    required this.objectId,
    required this.flightNumber,
    required this.departureCity,
    required this.arrivalCity,
    required this.departureDate,
    required this.arrivalDate,
    required this.airline,
    required this.availableSeats,
    required this.price,
    required this.logoUrl,
  });

  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight(
      objectId: json['objectId'] ?? '',
      flightNumber: json['flightNumber'] ?? '',
      departureCity: json['departureCity'] ?? '',
      arrivalCity: json['arrivalCity'] ?? '',
      departureDate: json['departureDate'] != null && json['departureDate']['iso'] != null
          ? DateTime.parse(json['departureDate']['iso'])
          : DateTime.now(),
      arrivalDate: json['arrivalDate'] != null && json['arrivalDate']['iso'] != null
          ? DateTime.parse(json['arrivalDate']['iso'])
          : DateTime.now(),
      airline: json['airline'] ?? '',
      availableSeats: json['availableSeats'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      logoUrl: json['logoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'objectId': objectId,
      'flightNumber': flightNumber,
      'departureCity': departureCity,
      'arrivalCity': arrivalCity,
      'departureDate': {
        '__type': 'Date',
        'iso': departureDate.toIso8601String(),
      },
      'arrivalDate': {
        '__type': 'Date',
        'iso': arrivalDate.toIso8601String(),
      },
      'airline': airline,
      'availableSeats': availableSeats,
      'price': price,
      'logoUrl': logoUrl,
    };
  }

  Duration get duration => arrivalDate.difference(departureDate);

  String get durationFormatted {
    final d = duration;
    return "${d.inHours}h ${d.inMinutes.remainder(60)}m";
  }
}
