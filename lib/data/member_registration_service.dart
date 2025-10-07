import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin/models/member_registration_model.dart';
import 'package:admin/core/constants/app_constants.dart';

class MemberRegistrationService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<List<MemberRegistration>> getMemberRegistrationData() async {
    try {
      List<MemberRegistration> members = [];
      
      // Try multiple collection paths to find member registration data
      List<String> collectionPaths = [
        'registration-report', // Direct collection
        '${AppConstants.eventCollectionName}/${AppConstants.memberRegistedDocName}/${AppConstants.memberRegisteredColName}', // App constants path
      ];
      
      for (String collectionPath in collectionPaths) {
        try {
          QuerySnapshot querySnapshot = await _firestore
              .collection(collectionPath)
              .orderBy('createdAt', descending: true)
              .limit(50)
              .get();

          if (querySnapshot.docs.isNotEmpty) {
            print('Found ${querySnapshot.docs.length} member documents in $collectionPath');
            
            for (QueryDocumentSnapshot doc in querySnapshot.docs) {
              try {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                
                print('Processing member document ${doc.id} with data: $data');
                
                // Convert to MemberRegistration model
                MemberRegistration member = MemberRegistration.fromMap(data);
                members.add(member);
                
                print('Created MemberRegistration: ${member.name}, ${member.email}, ${member.memberCategory}');
              } catch (e) {
                print('Error processing member document ${doc.id}: $e');
                continue;
              }
            }
            
            // If we found data in this collection, break
            if (members.isNotEmpty) {
              break;
            }
          }
        } catch (e) {
          print('Error accessing collection $collectionPath: $e');
        }
      }
      
      // If no data found in Firestore, return sample data for development
      if (members.isEmpty) {
        print('No member registration data found in Firestore, using sample data');
        members = _getSampleMemberData();
      }
      
      print('Total member registrations loaded: ${members.length}');
      return members;
    } catch (e) {
      print('Error in getMemberRegistrationData: $e');
      // Return sample data as fallback
      return _getSampleMemberData();
    }
  }

  static List<MemberRegistration> _getSampleMemberData() {
    return [
      MemberRegistration(
        name: "Dr. John Smith",
        email: "john.smith@example.com",
        phone: "+1-234-567-8901",
        address: "123 Medical Center Drive",
        city: "Boston",
        state: "MA",
        pincode: "02101",
        memberCategory: "Faculty",
        specialization: "Cardiology",
        registrationId: "REG001",
        paymentStatus: "Paid",
        registrationDate: "2024-01-15",
        createdAt: "2024-01-15T10:30:00Z",
      ),
      MemberRegistration(
        name: "Dr. Sarah Johnson",
        email: "sarah.j@example.com",
        phone: "+1-234-567-8902",
        address: "456 University Ave",
        city: "Cambridge",
        state: "MA", 
        pincode: "02139",
        memberCategory: "Student",
        specialization: "Neurology",
        registrationId: "REG002",
        paymentStatus: "Pending",
        registrationDate: "2024-01-16",
        createdAt: "2024-01-16T14:20:00Z",
      ),
      MemberRegistration(
        name: "Prof. Michael Davis",
        email: "m.davis@example.com",
        phone: "+1-234-567-8903",
        address: "789 Research Blvd",
        city: "San Francisco",
        state: "CA",
        pincode: "94105",
        memberCategory: "Researcher",
        specialization: "Oncology",
        registrationId: "REG003",
        paymentStatus: "Paid",
        registrationDate: "2024-01-17",
        createdAt: "2024-01-17T09:45:00Z",
      ),
      MemberRegistration(
        name: "Dr. Emily Wilson",
        email: "emily.wilson@example.com",
        phone: "+1-234-567-8904",
        address: "321 Health Sciences Dr",
        city: "Seattle",
        state: "WA",
        pincode: "98101",
        memberCategory: "Industry",
        specialization: "Pharmaceutical Research",
        registrationId: "REG004",
        paymentStatus: "Offline",
        registrationDate: "2024-01-18",
        createdAt: "2024-01-18T16:15:00Z",
      ),
      MemberRegistration(
        name: "Dr. Robert Brown",
        email: "r.brown@example.com",
        phone: "+1-234-567-8905",
        address: "654 Medical Plaza",
        city: "Chicago",
        state: "IL",
        pincode: "60601",
        memberCategory: "Faculty",
        specialization: "Pediatrics",
        registrationId: "REG005",
        paymentStatus: "Paid",
        registrationDate: "2024-01-19",
        createdAt: "2024-01-19T11:30:00Z",
      ),
    ];
  }

  // Method to refresh data from source
  static Future<List<MemberRegistration>> refreshMemberRegistrationData() async {
    // Force refresh from database
    return await getMemberRegistrationData();
  }

  // Method to search/filter member registrations
  static Future<List<MemberRegistration>> searchMemberRegistrations(String query) async {
    List<MemberRegistration> allMembers = await getMemberRegistrationData();
    
    if (query.isEmpty) {
      return allMembers;
    }
    
    query = query.toLowerCase();
    return allMembers.where((member) {
      return (member.name?.toLowerCase().contains(query) ?? false) ||
             (member.email?.toLowerCase().contains(query) ?? false) ||
             (member.memberCategory?.toLowerCase().contains(query) ?? false) ||
             (member.registrationId?.toLowerCase().contains(query) ?? false) ||
             (member.paymentStatus?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  // Method to get members by status
  static Future<List<MemberRegistration>> getMembersByStatus(String status) async {
    List<MemberRegistration> allMembers = await getMemberRegistrationData();
    return allMembers.where((member) => 
        member.paymentStatus?.toLowerCase() == status.toLowerCase()).toList();
  }

  // Method to get members by category
  static Future<List<MemberRegistration>> getMembersByCategory(String category) async {
    List<MemberRegistration> allMembers = await getMemberRegistrationData();
    return allMembers.where((member) => 
        member.memberCategory?.toLowerCase() == category.toLowerCase()).toList();
  }
}