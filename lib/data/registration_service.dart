import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin/models/recent_user_model.dart';
import 'package:admin/core/constants/app_constants.dart';

class RegistrationService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<List<RecentUser>> getRegistrationData() async {
    try {
      // Get registered members from Firestore
      QuerySnapshot querySnapshot = await _firestore
          .collection(AppConstants.eventCollectionName)
          .doc(AppConstants.memberRegistedDocName)
          .collection(AppConstants.memberRegisteredColName)
          .orderBy('registrationDate', descending: true)
          .limit(20)
          .get();

      List<RecentUser> users = [];

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        try {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          // Map Firestore fields to RecentUser model
          String name = data['name'] ?? data['fullName'] ?? 'N/A';
          String email = data['email'] ?? 'N/A';
          String role =
              data['delegateCategory'] ?? data['memberCategory'] ?? 'N/A';
          String registrationNo =
              data['registrationNumber'] ?? data['regNo'] ?? doc.id;
          String paymentStatus =
              data['paymentStatus'] ?? data['status'] ?? 'Pending';

          // Handle date formatting
          String date = '';
          if (data['registrationDate'] != null) {
            if (data['registrationDate'] is Timestamp) {
              DateTime regDate =
                  (data['registrationDate'] as Timestamp).toDate();
              date =
                  '${regDate.day.toString().padLeft(2, '0')}-${regDate.month.toString().padLeft(2, '0')}-${regDate.year}';
            } else {
              date = data['registrationDate'].toString();
            }
          } else if (data['createdAt'] != null) {
            if (data['createdAt'] is Timestamp) {
              DateTime regDate = (data['createdAt'] as Timestamp).toDate();
              date =
                  '${regDate.day.toString().padLeft(2, '0')}-${regDate.month.toString().padLeft(2, '0')}-${regDate.year}';
            } else {
              date = data['createdAt'].toString();
            }
          }

          users.add(RecentUser(
            name: name,
            email: email,
            role: role,
            date: date,
            posts: paymentStatus, // Using payment status instead of posts
            registrationNo: registrationNo,
          ));
        } catch (e) {
          // Skip malformed documents
          print('Error parsing document ${doc.id}: $e');
          continue;
        }
      }

      return users;
    } catch (e) {
      print('Error loading registration data from Firebase: $e');

      // Fallback: try to get data from users collection if member collection is empty
      try {
        QuerySnapshot fallbackSnapshot = await _firestore
            .collection('users')
            .orderBy('createdAt', descending: true)
            .limit(20)
            .get();

        List<RecentUser> fallbackUsers = [];

        for (QueryDocumentSnapshot doc in fallbackSnapshot.docs) {
          try {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

            String name = data['name'] ?? 'N/A';
            String email = data['email'] ?? 'N/A';
            String role = data['roles'] ?? data['memberCategory'] ?? 'User';
            String registrationNo = doc.id;
            String paymentStatus = data['status'] ?? 'Active';

            String date = '';
            if (data['createdAt'] != null && data['createdAt'] is Timestamp) {
              DateTime regDate = (data['createdAt'] as Timestamp).toDate();
              date =
                  '${regDate.day.toString().padLeft(2, '0')}-${regDate.month.toString().padLeft(2, '0')}-${regDate.year}';
            }

            fallbackUsers.add(RecentUser(
              name: name,
              email: email,
              role: role,
              date: date,
              posts: paymentStatus,
              registrationNo: registrationNo,
            ));
          } catch (e) {
            continue;
          }
        }

        return fallbackUsers;
      } catch (fallbackError) {
        print('Error loading fallback data: $fallbackError');
        return [];
      }
    }
  }

  static Future<bool> exportRegistrationData() async {
    try {
      // Get all registration data for export
      QuerySnapshot querySnapshot = await _firestore
          .collection(AppConstants.eventCollectionName)
          .doc(AppConstants.memberRegistedDocName)
          .collection(AppConstants.memberRegisteredColName)
          .get();

      // Here you could implement CSV export, PDF export, or other export formats
      print('Exporting ${querySnapshot.docs.length} registration records');

      // For now, just return success
      return true;
    } catch (e) {
      print('Error exporting registration data: $e');
      return false;
    }
  }
}
