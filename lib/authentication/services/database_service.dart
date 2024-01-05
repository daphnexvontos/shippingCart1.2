import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  Future<String?> addUser({
    required String accountNo,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNo,
    required String address1,
    required String password,
    required String city,
    required String state,
    required String postal,
    required String country
  }) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      // Call the user's CollectionReference to add a new user
      await users.doc(accountNo).set({
        'accountNo': accountNo,
        'Name': '$firstName $lastName',
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone No': phoneNo,
        'Address': address1,
        'password': password,
        'city': city,
        'state': state,
        'postal': postal,
        'country': country
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