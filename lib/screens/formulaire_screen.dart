import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/event.dart';
import '../providers/event_provider.dart';

class FormulaireScreen extends StatefulWidget {
  const FormulaireScreen({super.key});

  @override
  State<FormulaireScreen> createState() => _FormulaireScreenState();
}

class _FormulaireScreenState extends State<FormulaireScreen> {
  static const _categories = [
    'Hackathons',
    'Conferences',
    'Workshops',
    'Student Clubs',
    'Competitions',
    'Cultural Events',
  ];
  static const _defaultImage = 'assets/images/ui_ux_jam.jpg';

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _capacityController = TextEditingController();
  final _dateController = TextEditingController();

  String? _category;
    bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _capacityController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  String _iso(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(_dateController.text) ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 3),
    );
    if (picked != null) {
      setState(() => _dateController.text = _iso(picked));
    }
  }

  String? _validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Veuillez saisir le titre';
    }
    if (value.trim().length < 5) return 'Titre trop court (5 caractères min.)';
    return null;
  }

  String? _validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Veuillez saisir une description';
    }
    if (value.trim().length < 10) {
      return 'Description trop courte (10 caractères min.)';
    }
    return null;
  }

  String? _validateCapacity(String? value) {
    final number = int.tryParse(value?.trim() ?? '');
    if (number == null) return 'Saisissez un nombre entier';
    if (number < 1 || number > 5000) return 'Entre 1 et 5000 places';
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez corriger les erreurs du formulaire'),
        ),
      );
      return;
    }

    final provider = context.read<EventProvider>();
    final event = Event(
      id: provider.nextEventId,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _category!,
      date: _dateController.text,
      time: '09:00 AM',
      location: _locationController.text.trim(),
      organizer: 'Campus Organizer',
      capacity: int.parse(_capacityController.text.trim()),
      registered: 0,
      imageUrl: _defaultImage,
    );

    setState(() => _isSaving = true);
    final saved = await provider.addEvent(event);
    if (!mounted) return;
    Navigator.pop(context, saved);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Créer un événement')),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                textInputAction: TextInputAction.next,
                validator: _validateTitle,
                decoration: const InputDecoration(
                  labelText: 'Titre de l\'événement',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _category,
                isExpanded: true,
                validator: (v) =>
                    v == null ? 'Veuillez choisir une catégorie' : null,
                decoration: const InputDecoration(
                  labelText: 'Catégorie',
                  border: OutlineInputBorder(),
                ),
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (value) => setState(() => _category = value),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: _pickDate,
                validator: (v) => (v == null || v.isEmpty)
                    ? 'Veuillez choisir une date'
                    : null,
                decoration: const InputDecoration(
                  labelText: 'Date',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                textInputAction: TextInputAction.next,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Veuillez saisir le lieu'
                    : null,
                decoration: const InputDecoration(
                  labelText: 'Lieu',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _capacityController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                validator: _validateCapacity,
                decoration: const InputDecoration(
                  labelText: 'Nombre de places',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                validator: _validateDescription,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: _isSaving ? null : _submit,
                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Enregistrer l\'événement'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}