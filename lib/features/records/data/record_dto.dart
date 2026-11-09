import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/record.dart';

/// Firestore representation of a domain record.
class RecordDto {
  const RecordDto({
    required this.id,
    required this.title,
    required this.description,
    required this.ownerId,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final String description;
  final String ownerId;
  final DateTime updatedAt;

  factory RecordDto.fromDocument(
    QueryDocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();
    final timestamp = data['updatedAt'];

    return RecordDto(
      id: document.id,
      title: data['title'] is String ? data['title'] as String : '',
      description:
          data['description'] is String ? data['description'] as String : '',
      ownerId: data['ownerId'] is String ? data['ownerId'] as String : '',
      updatedAt: timestamp is Timestamp
          ? timestamp.toDate()
          : DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
    );
  }

  Record toDomain() {
    return Record(
      id: id,
      title: title,
      description: description,
      ownerId: ownerId,
      updatedAt: updatedAt,
    );
  }
}
