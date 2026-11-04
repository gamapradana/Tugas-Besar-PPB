class ReceiverLocation {
  final String name;
  final String description;
  final String address;
  final String phone;
  final String operatingHours;
  final List<String> acceptedCategories;
  final String status;
  final bool isActive;

  const ReceiverLocation({
    required this.name,
    required this.description,
    required this.address,
    required this.phone,
    required this.operatingHours,
    required this.acceptedCategories,
    required this.status,
    required this.isActive,
  });
}
