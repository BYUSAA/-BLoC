import 'package:equatable/equatable.dart';

class Record extends Equatable {
  const Record({
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

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        ownerId,
        updatedAt,
      ];
}
