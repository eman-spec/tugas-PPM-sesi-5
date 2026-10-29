class EventItem {
  final String id;
  final String title;
  final String speaker;
  final String category;
  final String date;
  final String time;
  final String location;
  final String description;
  final String imageUrl;
  final int capacity;
  final int registered;
  final double price;

  EventItem({
    required this.id,
    required this.title,
    required this.speaker,
    required this.category,
    required this.date,
    required this.time,
    required this.location,
    required this.description,
    required this.imageUrl,
    required this.capacity,
    required this.registered,
    required this.price,
  });

  bool get isAvailable => registered < capacity;
  int get availableSlots => capacity - registered;

  double get occupancyRate =>
      capacity > 0 ? (registered / capacity).clamp(0.0, 1.0) : 0.0;
}
