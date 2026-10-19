import 'package:flutter/material.dart';

import '../database/database_manager.dart';

class NetworkStatusScreen extends StatefulWidget {
  const NetworkStatusScreen({super.key});

  @override
  State<NetworkStatusScreen> createState() =>
      _NetworkStatusScreenState();
}

class _NetworkStatusScreenState
    extends State<NetworkStatusScreen> {
  int storedMessages = 0;

  @override
  void initState() {
    super.initState();
    loadStoredMessages();
  }

  Future<void> loadStoredMessages() async {
    final messages =
    await DatabaseManager.instance.getMessages();

    if (!mounted) return;

    setState(() {
      storedMessages = messages.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: loadStoredMessages,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Network Status',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'CrisisMesh can store emergency messages locally without internet.',
          ),

          const SizedBox(height: 24),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),

                  const SizedBox(width: 14),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          'OFFLINE MESH MODE',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Local emergency storage active',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          const Card(
            child: ListTile(
              leading: Icon(
                Icons.cloud_off,
                size: 32,
              ),
              title: Text(
                'Internet',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Not required for local alerts',
              ),
              trailing: Text(
                'OFFLINE',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          const Card(
            child: ListTile(
              leading: Icon(
                Icons.bluetooth,
                size: 32,
              ),
              title: Text(
                'Bluetooth',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Awaiting networking module',
              ),
              trailing: Icon(
                Icons.schedule,
              ),
            ),
          ),

          const SizedBox(height: 10),

          const Card(
            child: ListTile(
              leading: Icon(
                Icons.devices,
                size: 32,
              ),
              title: Text(
                'Nearby Devices',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Peer discovery will be integrated later',
              ),
              trailing: Text(
                '0',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Card(
            child: ListTile(
              leading: const Icon(
                Icons.storage,
                size: 32,
              ),
              title: const Text(
                'Locally Stored Messages',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                'Saved in SQLite on this device',
              ),
              trailing: Text(
                '$storedMessages',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Mesh Network',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Bluetooth peer discovery, message forwarding, and multi-device communication will connect to this interface through the networking module.',
          ),

          const SizedBox(height: 30),

          OutlinedButton.icon(
            onPressed: null,
            icon: Icon(Icons.bluetooth_searching),
            label: Text(
              'Peer Discovery - Coming Next',
            ),
          ),
        ],
      ),
    );
  }
}