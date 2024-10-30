
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/staff_model.dart';

class StaffService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'staff';

  Stream<List<Staff>> getAllStaff() {
    return _firestore.collection('staff').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Staff.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }
 Future<void> createStaff(Staff staff) async {
    await _firestore.collection('staff').add(staff.toMap());
  }

  Future<void> updateStaff(String id, Staff staff) async {
    await _firestore.collection('staff').doc(id).update(staff.toMap());
  }

  Future<void> deleteStaff(String id) async {
    await _firestore.collection('staff').doc(id).delete();
  }
}