import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  Future<String?> addUser({
    required String accountNo,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNo,
    required String address1,
    required String address2,
    required String password,
  }) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      // Call the user's CollectionReference to add a new user
      await users.doc(accountNo).set({
        'accountNo': accountNo,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNo': phoneNo,
        'address1': address1,
        'address2': address2,
        'password': password,
      });
      return 'success';
    } catch (e) {
      return 'Error adding user';
    }
  }

  Future<String?> getUser(String accountNo) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      final snapshot = await users.doc(accountNo).get();
      final data = snapshot.data() as Map<String, dynamic>;
      return data['firstName'];
    } catch (e) {
      return 'Error fetching user';
    }
  }
}