class OffersData {
  String id;
  final String title;
  final String description;
  final String city;
  final String publishingDate;
  final bool pubActivePaid;
  final String phoneNumber;
  final String emailAddress;

  OffersData({
    this.id = '',
    required this.title,
    required this.description,
    required this.city,
    required this.publishingDate,
    required this.pubActivePaid,
    this.phoneNumber = '',
    this.emailAddress = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'city': city,
        'publish_date': publishingDate,
        'publicity': pubActivePaid,
        'phone_number': phoneNumber,
        'email_address': emailAddress,
      };

  static OffersData fromJson(Map<String, dynamic> json) => OffersData(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        city: json['city'] ?? '',
        publishingDate: json['publish_date'] ?? '11/02/2024',
        pubActivePaid: json['publicity'] ?? false,
        phoneNumber: json['phone_number'] ?? '',
        emailAddress: json['email_address'] ?? '',
      );
}
