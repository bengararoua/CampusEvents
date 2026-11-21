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

  bool get isConfirmed => status.toLowerCase() == 'confirmed';

  bool get isWaitlisted => status.toLowerCase().startsWith('waitlist');

  Registration copyWith({
    Event? event,
    String? status,
    String? registeredOn,
  }) {
    return Registration(
      event: event ?? this.event,
      status: status ?? this.status,
      registeredOn: registeredOn ?? this.registeredOn,
    );
  }

  factory Registration.fromJson(Map<String, dynamic> json, Event event) {
    return Registration(
      event: event,
      status: json['status'] as String,
      registeredOn: json['registeredOn'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'eventId': event.id,
        'status': status,
        'registeredOn': registeredOn,
      };
}
