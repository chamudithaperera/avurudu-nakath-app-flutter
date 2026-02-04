import '../entities/nakath_event.dart';
import '../repositories/nakath_repository.dart';

class GetAllNakathEvents {
  final NakathRepository repository;

  GetAllNakathEvents(this.repository);

  Future<List<NakathEvent>> call() async {
    final events = await repository.getNakathEvents();
    // Sort logic can go here (e.g., by start time)
    // For now assuming JSON is ordered or repo handles it
    // But good practice to sort here.
    events.sort((a, b) {
      // Comparison logic:
      // Priority: Start Time > Date > End Time
      final timeA =
          a.start ??
          (a.date != null ? DateTime.parse(a.date!) : DateTime(2099));
      final timeB =
          b.start ??
          (b.date != null ? DateTime.parse(b.date!) : DateTime(2099));
      return timeA.compareTo(timeB);
    });
    return events;
  }
}
