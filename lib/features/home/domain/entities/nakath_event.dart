class NakathEvent {
  final String id;
  final String type; // dateOnly, dateTime, range
  final String titleKey;
  final String descriptionKey;
  final String? date;
  final DateTime? start;
  final DateTime? end;
  final String notificationPolicy;

  const NakathEvent({
    required this.id,
    required this.type,
    required this.titleKey,
    required this.descriptionKey,
    this.date,
    this.start,
    this.end,
    required this.notificationPolicy,
  });
}
