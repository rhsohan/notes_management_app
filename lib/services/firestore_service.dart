import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note.dart';

class FirestoreService {
  final CollectionReference _notesCollection =
      FirebaseFirestore.instance.collection('notes');

  // Create Note
  Future<void> addNote(Note note) async {
    await _notesCollection.add(note.toMap());
  }

  // Read Notes (Stream)
  Stream<List<Note>> getNotes() {
    return _notesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Note.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Update Note
  Future<void> updateNote(Note note) async {
    await _notesCollection.doc(note.id).update(note.toMap());
  }

  // Delete Note
  Future<void> deleteNote(String id) async {
    await _notesCollection.doc(id).delete();
  }
}
