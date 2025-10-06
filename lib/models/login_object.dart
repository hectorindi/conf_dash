class LoginObject {
  String name = '';
  String? uid = '';
  String? error;
  bool successful = false;

  LoginObject(
      {required this.uid,
      required this.name,
      required this.successful,
      this.error});

  // You can also add methods to your custom object
  void printDetails() {
    //log('Name: $name, Successful: $successful');
  }
}
