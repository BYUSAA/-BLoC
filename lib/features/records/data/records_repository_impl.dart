import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../domain/record.dart';
import '../domain/records_repository.dart';

class RecordsRepositoryImpl implements RecordsRepository {
  RecordsRepositoryImpl({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('records');

  String get _userId {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('A signed-in user is required to access records.');
    }
    return user.uid;
  }

  @override
  Stream<List<Record>> watchRecords() {
    final userId = _userId;
    return _collection
        .where('ownerId', isEqualTo: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((document) {
                final data = document.data();
                final timestamp = data['updatedAt'];
                return Record(
                  id: document.id,
                  title: data['title'] as String? ?? '',
                  description: data['description'] as String? ?? '',
                  ownerId: data['ownerId'] as String? ?? '',
                  updatedAt: timestamp is Timestamp
                      ? timestamp.toDate()
                      : DateTime.fromMillisecondsSinceEpoch(0),
                );
              })
              .toList(growable: false),
        );
  }

  @override
  Future<void> create({
    required String title,
    required String description,
  }) async {
    final normalizedTitle = _validateTitle(title);
    final normalizedDescription = _validateDescription(description);
    await _collection.doc(const Uuid().v4()).set({
      'title': normalizedTitle,
      'description': normalizedDescription,
      'ownerId': _userId,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> update(
    Record record, {
    required String title,
    required String description,
  }) async {
    final normalizedTitle = _validateTitle(title);
    final normalizedDescription = _validateDescription(description);
    await _collection.doc(record.id).update({
      'title': normalizedTitle,
      'description': normalizedDescription,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> delete(String id) async {
    if (id.trim().isEmpty) {
      throw ArgumentError.value(id, 'id', 'Record ID cannot be empty.');
    }
    await _collection.doc(id).delete();
  }

  String _validateTitle(String value) {
    final title = value.trim();
    if (title.isEmpty || title.length > RecordsRepository.maxTitleLength) {
      throw ArgumentError.value(
        value,
        'title',
        'Title must contain 1 to ${RecordsRepository.maxTitleLength} characters.',
      );
    }
    return title;
  }

  String _validateDescription(String value) {
    final description = value.trim();
    if (description.length > RecordsRepository.maxDescriptionLength) {
      throw ArgumentError.value(
        value,
        'description',
        'Description cannot exceed ${RecordsRepository.maxDescriptionLength} characters.',
      );
    }
    return description;
  }
}
