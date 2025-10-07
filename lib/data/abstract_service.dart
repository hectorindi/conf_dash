import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin/models/recent_user_model.dart';
import 'package:admin/models/abstract_model.dart';
import 'package:admin/core/constants/app_constants.dart';

class RegistrationService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<List<AbstractUser>> getAbstractData() async {
    try {
      List<AbstractUser> users = [];
      
      // Try multiple collection paths to find data
      List<String> collectionPaths = [
        'abstract-report',     // Alternative collection
      ];
      
      for (String collectionPath in collectionPaths) {
        try {
          QuerySnapshot querySnapshot = await _firestore
              .collection(collectionPath)
              .orderBy('Abstract ID', descending: true)
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
                              data['E-mail'] ?? 'no-email').toString().trim();
                if (email.isEmpty) email = 'no-email';
                              
                String institute = (data['Institute'] ?? 
                             data['institute'] ?? 
                             data['roles'] ?? 'No Institute').toString().trim();
                if (institute.isEmpty) institute = 'No Institute';
                             
                String registrationNo = (data['DOS MSNO'] ?? 
                                       data['dosmsno'] ??
                                       doc.id).toString().trim();
                if (registrationNo.isEmpty) registrationNo = doc.id;
                                       
                String membertype = (data['Member Type'] ?? 
                                      data['membertype'] ?? 
                                      'no memebership').toString().trim();
                if (membertype.isEmpty) membertype = 'no memebership';
                
                print('Mapped data: name=$name, email=$email, institute=$institute, registrationNo=$registrationNo, membertype=$membertype');

                // Always add users since we now have proper default values
                AbstractUser user = AbstractUser(
                  name: name,
                  email: email,
                  institute: institute,
                  membertype: membertype,
                  registrationNo: registrationNo,
                );
                
                users.add(user);
                print('Created AbstractUser: ${user.name}, ${user.email}, ${user.institute}');
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
      print('Total users loaded: ${users.length}');
      return users;
    } catch (e) {
      print('Error loading registration data from Firebase: $e');
      return [];
    }
  }
}
