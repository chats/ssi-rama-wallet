class NovaTicket {
  final String email;
  final String eventDateTime; 
  final String eventId;
  final String eventImage;
  final String eventName;
  final String eventRound;
  final String mobile;
  final String seatNumber;

  NovaTicket({
    required this.email,
    required this.eventDateTime,
    required this.eventId,
    required this.eventImage,
    required this.eventName,
    required this.eventRound,
    required this.mobile,
    required this.seatNumber,
  });

  factory NovaTicket.fromJson(Map<String, dynamic> json) {
    return NovaTicket(
      email: json['email'] ?? '',
      eventDateTime: json['event_date_time'] ?? '',
      eventId: json['event_id'] ?? '',
      eventImage: json['event_image'] ?? '',
      eventName: json['event_name'] ?? '',
      eventRound: json['event_round'] ?? '',
      mobile: json['mobile'] ?? '',
      seatNumber: json['seat_number'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'event_date_time': eventDateTime,
      'event_id': eventId,
      'event_image': eventImage,
      'event_name': eventName,
      'event_round': eventRound,
      'mobile': mobile,
      'seat_number': seatNumber,
    };
  }
}
