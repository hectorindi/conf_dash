class AbstractUser {
  final String? icon, name, membertype, institute, email, registrationNo;

  AbstractUser(
      {this.icon,
      this.name,
      this.membertype,
      this.institute,
      this.email,
      this.registrationNo});
}

// Static data replaced with dynamic CSV data from RegistrationService
// This ensures we get real-time registration data from the registration-report.csv file
