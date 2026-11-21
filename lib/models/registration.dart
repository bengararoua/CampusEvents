import 'event.dart';

class Registration {
  final Event event;
  final String status;
  final String registeredOn;

  const Registration({
    required this.event,
    required this.status,
    required this.registeredOn,
  });

  factory Registration.fromJson(Map<String, dynamic> json, Event event) {
    return Registration(
      event: event,
      status: json['status'] as String? ?? 'Confirmed',
      registeredOn: json['registeredOn'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eventId': event.id,
      'status': status,
      'registeredOn': registeredOn,
    };
  }
}
