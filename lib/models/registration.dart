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
}
