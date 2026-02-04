import '../../domain/entities/nakath_event.dart';
import '../../domain/repositories/nakath_repository.dart';
import '../datasources/nakath_local_data_source.dart';

class NakathRepositoryImpl implements NakathRepository {
  final NakathLocalDataSource localDataSource;

  NakathRepositoryImpl({required this.localDataSource});

  @override
  Future<List<NakathEvent>> getNakathEvents() async {
    // Simply fetch from local source.
    // In a real app, might handle caching or parsing errors here.
    return await localDataSource.getNakathEvents();
  }
}
