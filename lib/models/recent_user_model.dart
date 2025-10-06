class RecentUser {
  final String? icon, name, date, posts, role, email, registrationNo;

  RecentUser(
      {this.icon,
      this.name,
      this.date,
      this.posts,
      this.role,
      this.email,
      this.registrationNo});
}

// Static data replaced with dynamic CSV data from RegistrationService
// This ensures we get real-time registration data from the registration-report.csv file
