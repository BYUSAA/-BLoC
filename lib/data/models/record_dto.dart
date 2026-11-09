import '../../features/records/domain/record.dart';

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

  factory RecordDto.fromMap(String id, Map<String, dynamic> map) => RecordDto(
        id: id,
        title: map['title'] as String? ?? '',
        description: map['description'] as String? ?? '',
        ownerId: map['ownerId'] as String? ?? '',
        updatedAt: DateTime.tryParse(map['updatedAt']?.toString() ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0),
      );

  Record toDomain() => Record(
        id: id,
        title: title,
        description: description,
        ownerId: ownerId,
        updatedAt: updatedAt,
      );
}
