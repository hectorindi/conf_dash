import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin/models/recent_user_model.dart';
import 'package:admin/core/constants/app_constants.dart';

class RegistrationService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<List<RecentUser>> getRegistrationData() async {
    try {
      List<RecentUser> users = [];
      
      // Try multiple collection paths to find data
      List<String> collectionPaths = [
        'registration-report', // Direct collection
        'abstract-report',     // Alternative collection
        'users',              // Fallback collection
      ];
      
      for (String collectionPath in collectionPaths) {
        try {
          QuerySnapshot querySnapshot = await _firestore
              .collection(collectionPath)
              .orderBy('createdAt', descending: true)
              .limit(20)
              .get();

          if (querySnapshot.docs.isNotEmpty) {
            print('Found ${querySnapshot.docs.length} documents in $collectionPath');
            
            for (QueryDocumentSnapshot doc in querySnapshot.docs) {
              try {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                
                print('Processing document ${doc.id} with data: $data');
                
                // Map Firestore fields to RecentUser model with flexible field names
                String name = (data['Name'] ?? 
                             data['name'] ?? 
                             data['fullName'] ?? 
                             data['Full Name'] ?? 'Unknown User').toString().trim();
                if (name.isEmpty) name = 'Unknown User';
                             
                String email = (data['Email'] ?? 
                              data['email'] ?? 
                              data['E-mail'] ?? 'no-email@example.com').toString().trim();
                if (email.isEmpty) email = 'no-email@example.com';
                              
                String role = (data['Delegate Category'] ?? 
                             data['delegateCategory'] ?? 
                             data['Member Category'] ?? 
                             data['memberCategory'] ?? 
                             data['Position'] ??
                             data['roles'] ?? 'General').toString().trim();
                if (role.isEmpty) role = 'General';
                             
                String registrationNo = (data['Registration No.'] ?? 
                                       data['registrationNumber'] ?? 
                                       data['regNo'] ?? 
                                       data['Registration No'] ??
                                       doc.id).toString().trim();
                if (registrationNo.isEmpty) registrationNo = doc.id;
                                       
                String paymentStatus = (data['Payment Status'] ?? 
                                      data['paymentStatus'] ?? 
                                      data['status'] ?? 
                                      data['Status'] ?? 'Pending').toString().trim();
                if (paymentStatus.isEmpty) paymentStatus = 'Pending';
                
                print('Mapped data: name=$name, email=$email, role=$role, registrationNo=$registrationNo, paymentStatus=$paymentStatus');

                // Handle date formatting with multiple possible field names
                String date = 'Recent';
                var dateField = data['Date'] ?? 
                               data['date'] ?? 
                               data['registrationDate'] ?? 
                               data['createdAt'] ?? 
                               data['importedAt'];
                               
                if (dateField != null) {
                  if (dateField is Timestamp) {
                    DateTime regDate = dateField.toDate();
                    date = '${regDate.day.toString().padLeft(2, '0')}-${regDate.month.toString().padLeft(2, '0')}-${regDate.year}';
                  } else if (dateField is String && dateField.isNotEmpty) {
                    // Try to parse string dates
                    try {
                      DateTime parsedDate = DateTime.parse(dateField);
                      date = '${parsedDate.day.toString().padLeft(2, '0')}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.year}';
                    } catch (e) {
                      date = dateField.trim(); // Use as-is if parsing fails
                      if (date.isEmpty) date = 'Recent';
                    }
                  } else {
                    String dateStr = dateField.toString().trim();
                    date = dateStr.isNotEmpty ? dateStr : 'Recent';
                  }
                }

                // Always add users since we now have proper default values
                RecentUser user = RecentUser(
                  name: name,
                  email: email,
                  role: role,
                  date: date,
                  posts: paymentStatus,
                  registrationNo: registrationNo,
                );
                
                users.add(user);
                print('Created RecentUser: ${user.name}, ${user.email}, ${user.role}');
              } catch (e) {
                print('Error parsing document ${doc.id}: $e');
                continue;
              }
            }
            
            if (users.isNotEmpty) {
              print('Successfully loaded ${users.length} users from $collectionPath');
              return users;
            }
          }
        } catch (e) {
          print('Error accessing collection $collectionPath: $e');
          continue;
        }
      }
      
      // If no data found in any collection, try the nested structure
      try {
        QuerySnapshot querySnapshot = await _firestore
            .collection(AppConstants.eventCollectionName)
            .doc(AppConstants.memberRegistedDocName)
            .collection(AppConstants.memberRegisteredColName)
            .limit(20)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          print('Found ${querySnapshot.docs.length} documents in nested structure');
          
          for (QueryDocumentSnapshot doc in querySnapshot.docs) {
            try {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              
              String name = data['name'] ?? data['fullName'] ?? 'N/A';
              String email = data['email'] ?? 'N/A';
              String role = data['delegateCategory'] ?? data['memberCategory'] ?? 'N/A';
              String registrationNo = data['registrationNumber'] ?? data['regNo'] ?? doc.id;
              String paymentStatus = data['paymentStatus'] ?? data['status'] ?? 'Pending';
              
              String date = '';
              if (data['registrationDate'] != null && data['registrationDate'] is Timestamp) {
                DateTime regDate = (data['registrationDate'] as Timestamp).toDate();
                date = '${regDate.day.toString().padLeft(2, '0')}-${regDate.month.toString().padLeft(2, '0')}-${regDate.year}';
              }

              users.add(RecentUser(
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
        }
      } catch (e) {
        print('Error accessing nested structure: $e');
      }

      print('Total users loaded: ${users.length}');
      return users;
    } catch (e) {
      print('Error loading registration data from Firebase: $e');
      return [];
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
