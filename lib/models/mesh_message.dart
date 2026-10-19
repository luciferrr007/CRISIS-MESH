class MeshMessage {
  final String id;
  final String senderId;
  final String type;
  final String description;
  final String priority;
  final String status;
  final DateTime createdAt;
  final int ttl;
  final int hopCount;

  MeshMessage({
    required this.id,
    required this.senderId,
    required this.type,
    required this.description,
    required this.priority,
    this.status = 'pending',
    required this.createdAt,
    this.ttl = 10,
    this.hopCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sender_id': senderId,
      'type': type,
      'description': description,
      'priority': priority,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'ttl': ttl,
      'hop_count': hopCount,
    };
  }

  factory MeshMessage.fromMap(Map<String, dynamic> map) {
    return MeshMessage(
      id: map['id'],
      senderId: map['sender_id'],
      type: map['type'],
      description: map['description'],
      priority: map['priority'],
      status: map['status'],
      createdAt: DateTime.parse(map['created_at']),
      ttl: map['ttl'],
      hopCount: map['hop_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  factory MeshMessage.fromJson(Map<String, dynamic> json) {
    return MeshMessage.fromMap(json);
  }

  MeshMessage copyWith({
    String? id,
    String? senderId,
    String? type,
    String? description,
    String? priority,
    String? status,
    DateTime? createdAt,
    int? ttl,
    int? hopCount,
  }) {
    return MeshMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      type: type ?? this.type,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      ttl: ttl ?? this.ttl,
      hopCount: hopCount ?? this.hopCount,
    );
  }
}