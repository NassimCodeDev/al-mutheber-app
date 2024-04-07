class UsersInformations {
  String id;
  final String fullName;
  final String domaine;
  final String city;
  final String profileImage;
  final String cvFile;
  final String emailAddress;
  final String phoneNumber;
  final String description;
  final String password;
  final bool subscriptionIsActive;

  UsersInformations({
    this.id = '',
    required this.fullName,
    required this.domaine,
    required this.city,
    required this.profileImage,
    required this.cvFile,
    required this.emailAddress,
    required this.phoneNumber,
    required this.description,
    required this.password,
    required this.subscriptionIsActive,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'full_name': fullName,
        'domaine': domaine,
        'city': city,
        'profile_image': profileImage,
        'cv_file': cvFile,
        'email_address': emailAddress,
        'phone_number': phoneNumber,
        'description': description,
        'password': password,
        'subscription': subscriptionIsActive,
      };

  static UsersInformations fromJson(Map<String, dynamic> json) =>
      UsersInformations(
        id: json['id'] ?? '',
        fullName: json['full_name'] ?? '',
        domaine: json['domaine'] ?? '',
        city: json['city'] ?? '',
        profileImage: json['profile_image'] ?? '',
        cvFile: json['cv_file'] ?? '',
        emailAddress: json['email_address'] ?? '',
        phoneNumber: json['phone_number'] ?? '',
        description: json['description'] ?? '',
        password: json['password'] ?? '',
        subscriptionIsActive: json['subscription'] ?? false,
      );
}
