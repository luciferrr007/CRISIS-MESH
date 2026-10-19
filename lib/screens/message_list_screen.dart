import 'package:flutter/material.dart';

import '../database/database_manager.dart';
import '../models/mesh_message.dart';

class MessageListScreen extends StatefulWidget {
  const MessageListScreen({super.key});

  @override
  State<MessageListScreen> createState() => _MessageListScreenState();
}

class _MessageListScreenState extends State<MessageListScreen> {
  List<MeshMessage> messages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMessages();
  }

  Future<void> loadMessages() async {
    final data = await DatabaseManager.instance.getMessages();

    if (!mounted) return;

    setState(() {
      messages = data;
      isLoading = false;
    });
  }

  Future<void> deleteMessage(String id) async {
    await DatabaseManager.instance.deleteMessage(id);
    await loadMessages();
  }

  Color getPriorityColor(String priority) {
    switch (priority) {
      case 'Critical':
        return Colors.red;
      case 'High':
        return Colors.orange;
      case 'Medium':
        return Colors.amber;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            10,
          ),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Emergency Messages',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: loadMessages,
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh',
              ),
            ],
          ),
        ),

        Expanded(
          child: messages.isEmpty
              ? const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 70,
                  color: Colors.grey,
                ),
                SizedBox(height: 12),
                Text(
                  'No emergency alerts yet',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Create an alert from the Alert tab.',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          )
              : RefreshIndicator(
            onRefresh: loadMessages,
            child: ListView.builder(
              padding: const EdgeInsets.only(
                bottom: 20,
              ),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.warning_amber_rounded,
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: Text(
                                message.type,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
                            ),

                            Container(
                              padding:
                              const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: getPriorityColor(
                                  message.priority,
                                ).withValues(
                                  alpha: 0.15,
                                ),
                                borderRadius:
                                BorderRadius.circular(20),
                              ),
                              child: Text(
                                message.priority,
                                style: TextStyle(
                                  color: getPriorityColor(
                                    message.priority,
                                  ),
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Text(
                          message.description,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          'Status: ${message.status}',
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),

                        Text(
                          'Created: ${message.createdAt.toLocal()}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () {
                              deleteMessage(message.id);
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            tooltip: 'Delete alert',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}