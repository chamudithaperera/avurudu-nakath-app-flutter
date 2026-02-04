import '../entities/nakath_event.dart';

abstract class NakathRepository {
  Future<List<NakathEvent>> getNakathEvents();
}
