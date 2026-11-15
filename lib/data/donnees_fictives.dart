import '../models/event.dart';
import '../models/registration.dart';

const List<Event> events = [
  Event(
    id: 1,
    title: 'Annual Campus AI Hackathon 2025',
    description:
        'Immerse yourself in 48 hours of rapid prototyping, creative coding and collaborative innovation. Teams of 2 to 4 students build an AI project and present it to industry mentors.',
    category: 'Hackathons',
    date: 'Oct 24 - Oct 26',
    time: '09:00 AM',
    location: 'Engineering Hub, Great Hall A',
    organizer: 'Central Tech & Innovation Society',
    capacity: 400,
    registered: 388,
  ),
  Event(
    id: 2,
    title: 'UI/UX Campus Design Jam 2025',
    description:
        'A one-day design sprint where students redesign a campus service in small teams. Bring a laptop or a sketchbook.',
    category: 'Competitions',
    date: 'Oct 25',
    time: '10:00 AM',
    location: 'Design Center, Lab 3',
    organizer: 'Design Club',
    capacity: 120,
    registered: 78,
  ),
  Event(
    id: 3,
    title: 'Robotics Club Showcase & Sumo Battle',
    description:
        'Watch student-built robots compete in a sumo arena and meet the members of the robotics club.',
    category: 'Student Clubs',
    date: 'Oct 26',
    time: '01:00 PM',
    location: 'Mech Lab Arena',
    organizer: 'IEEE Student Chapter',
    capacity: 150,
    registered: 110,
  ),
  Event(
    id: 4,
    title: 'Global Climate & Sustainability Forum',
    description:
        'Talks and panels about climate action on campus and beyond, with a keynote speech by Dr. Aris.',
    category: 'Conferences',
    date: 'Oct 28',
    time: '09:00 AM',
    location: 'Main Auditorium',
    organizer: 'Green Campus Office',
    capacity: 300,
    registered: 190,
  ),
  Event(
    id: 5,
    title: 'Flutter & Mobile Dev Bootcamp',
    description:
        'A hands-on workshop to build your first mobile app with Flutter. Install the Flutter SDK before the session.',
    category: 'Workshops',
    date: 'Nov 2',
    time: '03:00 PM',
    location: 'Turing Hall, Room 402',
    organizer: 'Google Developer Student Club',
    capacity: 60,
    registered: 52,
  ),
  Event(
    id: 6,
    title: 'Fintech & Blockchain Career Summit',
    description:
        'Meet professionals from banks and startups, attend short talks and discover internship offers in fintech.',
    category: 'Conferences',
    date: 'Nov 4',
    time: '04:00 PM',
    location: 'Business School Aud. 2',
    organizer: 'Central Finance Club',
    capacity: 200,
    registered: 155,
  ),
  Event(
    id: 7,
    title: 'Autumn Acoustic Night',
    description:
        'An open-air evening of live music by student bands, with open seating in the amphitheater.',
    category: 'Cultural Events',
    date: 'Nov 7',
    time: '07:30 PM',
    location: 'Student Amphitheater',
    organizer: 'Cultural Club',
    capacity: 250,
    registered: 92,
  ),
  Event(
    id: 8,
    title: 'Google Cloud Hands-on Workshop',
    description:
        'Learn the basics of cloud computing and deploy your first application during this guided lab.',
    category: 'Workshops',
    date: 'Nov 10',
    time: '02:00 PM',
    location: 'CS Lab 4, North Wing',
    organizer: 'Google Developer Student Club',
    capacity: 80,
    registered: 45,
  ),
];

final List<Event> favorites = [events[1], events[2], events[3]];

final List<Registration> registrations = [
  Registration(
    event: events[0],
    status: 'Confirmed',
    registeredOn: 'Oct 12',
  ),
  Registration(
    event: events[4],
    status: 'Waitlist #4',
    registeredOn: 'Oct 15',
  ),
  Registration(
    event: events[6],
    status: 'Confirmed',
    registeredOn: 'Oct 20',
  ),
];
