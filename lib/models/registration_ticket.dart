class RegistrationTicket {
  final String ticketId;
  final String eventId;
  final String eventTitle;
  final String eventCategory;
  final String eventDate;
  final String eventTime;
  final String eventLocation;
  final String participantName;
  final String nim;
  final String email;
  final String whatsapp;
  final String participantType;
  final String attendanceDate;
  final bool includeSeminarKit;
  final double donationAmount;
  final DateTime registeredAt;
  bool isActive;

  RegistrationTicket({
    required this.ticketId,
    required this.eventId,
    required this.eventTitle,
    required this.eventCategory,
    required this.eventDate,
    required this.eventTime,
    required this.eventLocation,
    required this.participantName,
    required this.nim,
    required this.email,
    required this.whatsapp,
    required this.participantType,
    required this.attendanceDate,
    required this.includeSeminarKit,
    required this.donationAmount,
    required this.registeredAt,
    this.isActive = true,
  });

  double get totalCost => donationAmount + (includeSeminarKit ? 25000 : 0);

  String get ticketCode =>
      'NSE-${ticketId.substring(0, 6).toUpperCase()}-${eventCategory.substring(0, 2).toUpperCase()}';
}
