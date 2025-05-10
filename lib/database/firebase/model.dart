
// < Get Data From Firestore>
class Specialist {
  final String name;
  final String specialization;
  final String category;
  final String availableDays;
  final String availableTimes;
  final String bio;
  // final String imageUrl;

  Specialist({
    required this.name,
    required this.specialization,
    required this.category,
    required this.availableDays,
    required this.availableTimes,
    required this.bio,
    // required this.imageUrl,
  });

  factory Specialist.fromJson(Map<String, dynamic> json) {
    return Specialist(
      name: json['name'],
      specialization: json['specialization'],
      category: json['category'],
      availableDays: json['availableDays'],
      availableTimes: json['availableTimes'],
      bio: json['bio'],
      // imageUrl: json['imageUrl'],
    );
  }
}
