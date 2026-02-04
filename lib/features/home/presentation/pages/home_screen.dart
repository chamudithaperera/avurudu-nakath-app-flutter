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
      backgroundColor: const Color(0xFFFFFDE7), // Light Cream background
      appBar: AppBar(
        title: Text(
          uiL10n.appTitle,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            color: Color(0xFF3E2723),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Color(0xFF3E2723)),
            onPressed: () {
              // TODO: Show About/Info
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Decoration (Subtle sunburst/mandala feel)
          Positioned(
            top: -100,
            right: -100,
            child: Opacity(
              opacity: 0.05,
              child: Image.asset(
                'assets/images/sun.png',
                width: 400,
                height: 400,
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Opacity(
              opacity: 0.03,
              child: Image.asset(
                'assets/images/sun.png',
                width: 300,
                height: 300,
              ),
            ),
          ),

          FutureBuilder<List<NakathEvent>>(
            future: _eventsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error loading data: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No nakath events found.'));
              }

              final events = snapshot.data!;
              final now = DateTime.now();
              final upcomingEvents = events.where((e) {
                final t =
                    e.start ??
                    (e.date != null ? DateTime.tryParse(e.date!) : null);
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
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.brown.shade200,
                              thickness: 1.5,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Text(
                              uiL10n.allNakath.toUpperCase(),
                              style: TextStyle(
                                color: Colors.brown.shade800,
                                fontWeight: FontWeight.w900,
                                fontSize: 13,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.brown.shade200,
                              thickness: 1.5,
                            ),
                          ),
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

                  // Copyright Footer
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 40.0,
                        horizontal: 24,
                      ),
                      child: Column(
                        children: [
                          const Divider(color: Color(0xFFD7CCC8), thickness: 1),
                          const SizedBox(height: 20),
                          const Text(
                            'A Product of ChamXdev by Chamuditha Perera',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF8D6E63),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '© 2026 Nakath App. All rights reserved.',
                            style: TextStyle(
                              fontSize: 10,
                              color: const Color(0xFF8D6E63).withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
