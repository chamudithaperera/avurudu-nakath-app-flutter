import 'package:flutter/material.dart';
import '../../data/datasources/nakath_local_data_source.dart';
import '../../data/repositories/nakath_repository_impl.dart';
import '../../domain/entities/nakath_event.dart';
import '../../domain/usecases/get_all_nakath_events.dart';
import '../widgets/nakath_hero_card.dart';
import '../widgets/nakath_list_tile.dart';
import '../widgets/nakath_detail_popup.dart'; // Added
import 'package:avurudu_nakath_app/l10n/generated/ui/ui_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<NakathEvent>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    // DI Setup
    final dataSource = NakathLocalDataSourceImpl();
    final repository = NakathRepositoryImpl(localDataSource: dataSource);
    final useCase = GetAllNakathEvents(repository);

    _eventsFuture = useCase();
  }

  void _showNakathDetail(NakathEvent event) {
    showDialog(
      context: context,
      builder: (context) => NakathDetailPopup(event: event),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uiL10n = UiLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(uiL10n.appTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // TODO: Show About/Info
            },
          ),
        ],
      ),
      body: FutureBuilder<List<NakathEvent>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading data: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No nakath events found.'));
          }

          final events = snapshot.data!;
          // Simple logic: Find first event in future, or first event if all past
          // This logic can be moved to Domain later
          final now = DateTime.now();
          final upcomingEvents = events.where((e) {
            final t =
                e.start ?? (e.date != null ? DateTime.tryParse(e.date!) : null);
            return t != null && t.isAfter(now);
          }).toList();

          final nextEvent = upcomingEvents.isNotEmpty
              ? upcomingEvents.first
              : events.first;
          final otherEvents = events.where((e) => e != nextEvent).toList();

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: NakathHeroCard(
                  event: nextEvent,
                  onTap: () => _showNakathDetail(nextEvent),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Divider(color: Colors.brown.shade200)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          uiL10n.allNakath,
                          style: TextStyle(
                            color: Colors.brown.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.brown.shade200)),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final event = otherEvents[index];
                  return NakathListTile(
                    event: event,
                    onTap: () => _showNakathDetail(event),
                  );
                }, childCount: otherEvents.length),
              ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 20)),
            ],
          );
        },
      ),
    );
  }
}
