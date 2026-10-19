import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../database/database_manager.dart';
import '../models/mesh_message.dart';

class CreateAlertScreen extends StatefulWidget {
  const CreateAlertScreen({super.key});

  @override
  State<CreateAlertScreen> createState() => _CreateAlertScreenState();
}

class _CreateAlertScreenState extends State<CreateAlertScreen> {
  final TextEditingController descriptionController =
  TextEditingController();

  String selectedType = 'Medical';
  String selectedPriority = 'High';

  final List<String> types = [
    'Medical',
    'Food',
    'Water',
    'Shelter',
    'Missing Person',
    'Emergency',
  ];

  final List<String> priorities = [
    'Low',
    'Medium',
    'High',
    'Critical',
  ];

  Future<void> createAlert() async {
    if (descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a description'),
        ),
      );
      return;
    }

    final message = MeshMessage(
      id: const Uuid().v4(),
      senderId: 'local-device',
      type: selectedType,
      description: descriptionController.text.trim(),
      priority: selectedPriority,
      status: 'pending',
      createdAt: DateTime.now(),
      ttl: 10,
      hopCount: 0,
    );

    await DatabaseManager.instance.insertMessage(message);

    descriptionController.clear();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Emergency alert saved offline'),
      ),
    );
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Create Emergency Alert',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'This alert will be stored locally and can be created without internet.',
          ),

          const SizedBox(height: 24),

          const Text(
            'Emergency Type',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          DropdownButtonFormField<String>(
            value: selectedType,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            items: types.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedType = value!;
              });
            },
          ),

          const SizedBox(height: 20),

          const Text(
            'Description',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          TextField(
            controller: descriptionController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Describe the emergency...',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Priority',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          DropdownButtonFormField<String>(
            value: selectedPriority,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            items: priorities.map((priority) {
              return DropdownMenuItem(
                value: priority,
                child: Text(priority),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedPriority = value!;
              });
            },
          ),

          const SizedBox(height: 28),

          SizedBox(
            width: double.infinity,
            height: 54,
            child: FilledButton.icon(
              onPressed: createAlert,
              icon: const Icon(Icons.sos),
              label: const Text(
                'CREATE ALERT',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}