import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/event.dart';
import '../providers/event_provider.dart';

class EventRegistrationScreen extends StatefulWidget {
  final Event event;

  const EventRegistrationScreen({super.key, required this.event});

  @override
  State<EventRegistrationScreen> createState() =>
      _EventRegistrationScreenState();
}

class _EventRegistrationScreenState extends State<EventRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _studentIdController = TextEditingController();

  static const _departments = [
    'Informatique',
    'Génie Électrique',
    'Génie Mécanique',
    'Génie Civil',
    'Gestion',
  ];
  static const _years = [
    '1ère année',
    '2ème année',
    '3ème année',
    'Master 1',
    'Master 2',
  ];

  String? _department;
  String? _year;
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _studentIdController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String? _required(String? value, String message) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  String? _validateName(String? value) {
    final error = _required(value, 'Veuillez saisir votre nom complet');
    if (error != null) return error;
    if (value!.trim().length < 3) {
      return 'Le nom est trop court (3 caractères min.)';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final error = _required(value, 'Veuillez saisir votre e-mail');
    if (error != null) return error;
    final regex = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$');
    if (!regex.hasMatch(value!.trim())) return 'Adresse e-mail invalide';
    return null;
  }

  String? _validateStudentId(String? value) {
    final error = _required(
      value,
      'Veuillez saisir votre identifiant étudiant',
    );
    if (error != null) return error;
    if (value!.trim().length < 4) {
      return 'Identifiant trop court (4 caractères min.)';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    final error = _required(value, 'Veuillez saisir votre numéro de téléphone');
    if (error != null) return error;
    final regex = RegExp(r'^\+?[0-9 ]{8,15}$');
    if (!regex.hasMatch(value!.trim())) {
      return 'Numéro invalide (8 à 15 chiffres)';
    }
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez corriger les erreurs du formulaire'),
        ),
      );
      return;
    }
    context.read<EventProvider>().register(widget.event);
    Navigator.pop(context, true);
  }


  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final event = widget.event;

    return Scaffold(
      appBar: AppBar(title: const Text('Event Registration')),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.event),
                title: Text(
                  event.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  '${event.date} • ${event.location}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Student Profile', style: textTheme.titleLarge),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              textInputAction: TextInputAction.next,
              validator: _validateName,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: _validateEmail,
              decoration: const InputDecoration(
                labelText: 'Institutional Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _studentIdController,
              textInputAction: TextInputAction.next,
              validator: _validateStudentId,
              decoration: const InputDecoration(
                labelText: 'Student ID Number',
                prefixIcon: Icon(Icons.badge),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _department,
              isExpanded: true,
              validator: (v) =>
                  v == null ? 'Veuillez choisir votre département' : null,
              decoration: const InputDecoration(
                labelText: 'Major / Department',
                prefixIcon: Icon(Icons.school),
                border: OutlineInputBorder(),
              ),
              items: _departments
                  .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                  .toList(),
              onChanged: (value) => setState(() => _department = value),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _year,
              isExpanded: true,
              validator: (v) =>
                  v == null ? 'Veuillez choisir votre année' : null,
              decoration: const InputDecoration(
                labelText: 'Current Academic Year',
                prefixIcon: Icon(Icons.calendar_month),
                border: OutlineInputBorder(),
              ),
              items: _years
                  .map((y) => DropdownMenuItem(value: y, child: Text(y)))
                  .toList(),
              onChanged: (value) => setState(() => _year = value),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              validator: _validatePhone,
              decoration: const InputDecoration(
                labelText: 'Mobile Number',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.send),
              label: const Text('Submit Registration'),
            ),
          ],
        ),
      ),
    );
  }
}
