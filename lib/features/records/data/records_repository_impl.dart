import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../domain/record.dart';

class RecordsRepositoryImpl {
  RecordsRepositoryImpl({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance, _auth = auth ?? FirebaseAuth.instance;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  CollectionReference<Map<String, dynamic>> get _collection => _firestore.collection('records');
  String get _uid => _auth.currentUser!.uid;
  Stream<List<Record>> watchRecords() => _collection.where('ownerId', isEqualTo: _uid).snapshots().map((snapshot) {
    final records = snapshot.docs.map((doc) => Record(
      id: doc.id,
      title: doc.data()['title'] as String? ?? '',
      description: doc.data()['description'] as String? ?? '',
      ownerId: doc.data()['ownerId'] as String? ?? '',
      updatedAt: (doc.data()['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    )).toList();
    records.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return records;
  });
  Future<void> create({required String title, required String description}) async {
    final id = const Uuid().v4();
    await _collection.doc(id).set({'title': title.trim(), 'description': description.trim(), 'ownerId': _uid, 'updatedAt': FieldValue.serverTimestamp()});
  }
  Future<void> update(Record record, {required String title, required String description}) async {
    await _collection.doc(record.id).update({'title': title.trim(), 'description': description.trim(), 'updatedAt': FieldValue.serverTimestamp()});
  }
  Future<void> delete(String id) => _collection.doc(id).delete();
}
