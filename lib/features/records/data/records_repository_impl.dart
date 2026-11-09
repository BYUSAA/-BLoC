import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../app/constants/app_constants.dart';
import '../../../core/errors/app_exception.dart';
import '../domain/record.dart';
import '../domain/records_repository.dart';
import 'record_dto.dart';

class RecordsRepositoryImpl implements RecordsRepository {
  RecordsRepositoryImpl({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(AppConstants.recordsCollection);

  String _requireUserId() {
    final user = _auth.currentUser;
    if (user == null) {
      throw const AppException(
        code: 'not-authenticated',
        message: 'Sign in before accessing records.',
      );
    }
    return user.uid;
  }

  @override
  Stream<List<Record>> watchRecords() {
    final userId = _requireUserId();

    return _collection
        .where('ownerId', isEqualTo: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => List<Record>.unmodifiable(
            snapshot.docs.map(
              (document) => RecordDto.fromDocument(document).toDomain(),
            ),
          ),
        );
  }

  @override
  Future<void> create({
    required String title,
    required String description,
  }) async {
    final ownerId = _requireUserId();

    await _collection.doc().set({
      'title': _validateTitle(title),
      'description': _validateDescription(description),
      'ownerId': ownerId,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> update(
    Record record, {
    required String title,
    required String description,
  }) async {
    final ownerId = _requireUserId();

    if (record.ownerId != ownerId) {
      throw const AppException(
        code: 'record-not-owned',
        message: 'You do not have permission to change this record.',
      );
    }

    if (record.id.trim().isEmpty) {
      throw const AppException(
        code: 'invalid-record-id',
        message: 'The record identifier is invalid.',
      );
    }

    await _collection.doc(record.id).update({
      'title': _validateTitle(title),
      'description': _validateDescription(description),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> delete(String id) async {
    _requireUserId();

    if (id.trim().isEmpty) {
      throw const AppException(
        code: 'invalid-record-id',
        message: 'The record identifier is invalid.',
      );
    }

    await _collection.doc(id).delete();
  }

  String _validateTitle(String value) {
    final title = value.trim();
    if (title.isEmpty || title.length > AppConstants.maxRecordTitleLength) {
      throw AppException(
        code: 'invalid-record-title',
        message:
            'A record title must contain 1 to ${AppConstants.maxRecordTitleLength} characters.',
      );
    }
    return title;
  }

  String _validateDescription(String value) {
    final description = value.trim();
    if (description.length > AppConstants.maxRecordDescriptionLength) {
      throw AppException(
        code: 'invalid-record-description',
        message:
            'A record description cannot exceed ${AppConstants.maxRecordDescriptionLength} characters.',
      );
    }
    return description;
  }
}
