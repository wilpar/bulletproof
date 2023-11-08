import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  final String uid;
  final String email;
  final String firstName;

  Profile({
    required this.uid,
    required this.email,
    required this.firstName,
  });

  factory Profile.fromFirestore(DocumentSnapshot doc) {
    if (doc.exists) {
      Map data = doc.data() as Map<String, dynamic>;

      return Profile(
        uid: doc.id,
        email: data['email'] ?? 'no email',
        firstName: data['firstName'] ?? 'no firstName',
      );
    }
    throw TypeError();
  }

  @override
  String toString() =>
      'Profile(uid: $uid, email: $email, firstName: $firstName)';
}
