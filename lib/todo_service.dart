// todo_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _todosCollection =
      _firestore.collection('todos');

  // TODO 1: CREATE - Add new todo to Firestore
  static Future<DocumentReference> addTodo(String task) async {
    return await _todosCollection.add({
      'task': task,
      'completed': false,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // TODO 2: READ - Get todos stream for real-time updates
  static Stream<QuerySnapshot> getTodosStream() {
    return _todosCollection
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // TODO 3: UPDATE - Toggle todo completion status
  static Future<void> toggleTodo(String id, bool currentStatus) async {
    await _todosCollection.doc(id).update({
      'completed': !currentStatus,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // TODO 4: UPDATE - Edit todo text
  static Future<void> updateTodo(String id, String newTask) async {
    await _todosCollection.doc(id).update({
      'task': newTask,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // TODO 5: DELETE - Remove a todo
  static Future<void> deleteTodo(String id) async {
    await _todosCollection.doc(id).delete();
  }

  // TODO 6: BONUS - Delete all completed todos
  static Future<void> deleteCompletedTodos() async {
    final querySnapshot =
        await _todosCollection.where('completed', isEqualTo: true).get();

    final batch = _firestore.batch();
    for (final doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
