import '../../domain/entities/nakath_event.dart';

class NakathEventModel extends NakathEvent {
  const NakathEventModel({
    required super.id,
    required super.type,
    required super.titleKey,
    required super.descriptionKey,
    super.date,
    super.start,
    super.end,
    required super.notificationPolicy,
  });

  factory NakathEventModel.fromJson(Map<String, dynamic> json) {
    return NakathEventModel(
      id: json['id'],
      type: json['type'],
      titleKey: json['titleKey'],
      descriptionKey: json['descriptionKey'],
      date: json['date'],
      start: json['start'] != null ? DateTime.parse(json['start']) : null,
      end: json['end'] != null ? DateTime.parse(json['end']) : null,
      notificationPolicy: json['notificationPolicy'],
    );
  }
}
