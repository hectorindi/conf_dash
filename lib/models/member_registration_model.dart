class MemberRegistration {
  final String? name;
  final String? email; 
  final String? phone;
  final String? address;
  final String? city;
  final String? state;
  final String? pincode;
  final String? memberCategory;
  final String? specialization;
  final String? registrationId;
  final String? paymentStatus;
  final String? registrationDate;
  final String? createdAt;

  MemberRegistration({
    this.name,
    this.email,
    this.phone,
    this.address,
    this.city,
    this.state,
    this.pincode,
    this.memberCategory,
    this.specialization,
    this.registrationId,
    this.paymentStatus,
    this.registrationDate,
    this.createdAt,
  });

  // Convert from Map<String, dynamic> (for Firestore/API data)
  factory MemberRegistration.fromMap(Map<String, dynamic> data) {
    // Handle email and phone parsing (currently stored as "email/phone")
    String? email;
    String? phone;
    if (data['emailMobile'] != null) {
      final parts = data['emailMobile'].toString().split('/');
      email = parts.isNotEmpty ? parts[0] : null;
      phone = parts.length > 1 ? parts[1] : null;
    } else {
      email = data['email'] ?? data['Email'];
      phone = data['phone'] ?? data['phoneNumber'] ?? data['Phone'];
    }

    // Handle city, state, pincode parsing (currently stored as "city_state_pincode")
    String? city;
    String? state;
    String? pincode;
    if (data['city_state_pincode'] != null) {
      final parts = data['city_state_pincode'].toString().split('_');
      city = parts.isNotEmpty ? parts[0] : null;
      state = parts.length > 1 ? parts[1] : null;
      pincode = parts.length > 2 ? parts[2] : null;
    } else {
      city = data['city'] ?? data['City'];
      state = data['state'] ?? data['State'];
      pincode = data['pincode'] ?? data['Pincode'];
    }

    // Handle specialization object
    String? specialization;
    if (data['specialization'] is Map) {
      specialization = data['specialization']['name'];
    } else {
      specialization = data['specialization']?.toString();
    }

    return MemberRegistration(
      name: data['name']?.toString() ?? data['Name']?.toString(),
      email: email,
      phone: phone,
      address: data['address']?.toString() ?? data['Address']?.toString(),
      city: city,
      state: state,
      pincode: pincode,
      memberCategory: data['memberCategory']?.toString() ?? data['Member Category']?.toString(),
      specialization: specialization,
      registrationId: data['regID']?.toString() ?? data['registrationId']?.toString(),
      paymentStatus: data['paymentStatus']?.toString() ?? data['status']?.toString() ?? 'Pending',
      registrationDate: data['registrationDate']?.toString() ?? data['date']?.toString(),
      createdAt: data['createdAt']?.toString(),
    );
  }

  // Convert to Map<String, dynamic> (for sending to API/Firestore)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'city': city,
      'state': state,
      'pincode': pincode,
      'memberCategory': memberCategory,
      'specialization': specialization,
      'registrationId': registrationId,
      'paymentStatus': paymentStatus,
      'registrationDate': registrationDate,
      'createdAt': createdAt,
    };
  }
}