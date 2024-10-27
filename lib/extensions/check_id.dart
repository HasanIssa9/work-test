import 'package:firebase_database/firebase_database.dart';

class CheckId {
  final dbstd = FirebaseDatabase.instance.ref().child('data');
  Future<bool> checkIfItemExists(String itemKey) async {
    if (itemKey.isEmpty) {
      return false;
    }
    var snapshot = await dbstd.child(itemKey).once();
    if (snapshot.snapshot.value != null) {
      return true;
    }
    return false;
  }

  Future<String?> findItemKey(String searchValue) async {
    var snapshot = await dbstd.orderByChild('id').equalTo(searchValue).once();
    if (snapshot.snapshot.value != null) {
      Map<dynamic, dynamic> values = snapshot.snapshot.value as Map;
      String? key = values.keys.first;
      return key;
    }
    return null;
  }
}
