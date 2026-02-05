import 'package:flutter/material.dart';
import '../../data/datasources/nakath_local_data_source.dart';
import '../../data/repositories/nakath_repository_impl.dart';
import '../../domain/entities/nakath_event.dart';
import '../../domain/usecases/get_all_nakath_events.dart';
import '../widgets/nakath_hero_card.dart';
import '../widgets/nakath_list_tile.dart';
import '../widgets/nakath_detail_popup.dart'; // Added
import 'package:avurudu_nakath_app/l10n/generated/ui/ui_localizations.dart';

import '../../../../core/services/notification_service.dart';

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

    _eventsFuture = useCase().then((events) async {
      // Schedule notifications when data is loaded
      final notificationService = NotificationService();
      await notificationService.init();
      await notificationService.requestPermissions();
      await notificationService.scheduleNotifications(events);
      return events;
    });
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(uiL10n.appTitle, style: theme.appBarTheme.titleTextStyle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.language_rounded),
            onPressed: () {
              // TODO: Navigate to language selection or show quick picker
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Parchment Texture Base
          Positioned.fill(
            child: Image.asset(
              'assets/images/parchment_texture.png',
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(0.6),
            ),
          ),

          // Central Lotus Mandala (Large, subtle)
          Center(
            child: Opacity(
              opacity: 0.08,
              child: Image.asset(
                'assets/images/lotus_mandala.png',
                width: MediaQuery.of(context).size.width * 0.9,
              ),
            ),
          ),

          // Top Mandala Decoration
          Positioned(
            top: -150,
            right: -100,
            child: Opacity(
              opacity: 0.1,
              child: Image.asset('assets/images/lotus_mandala.png', width: 400),
            ),
          ),

          FutureBuilder<List<NakathEvent>>(
            future: _eventsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
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
                physics: const BouncingScrollPhysics(),
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
                        vertical: 24,
                        horizontal: 24,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.3,
                              ),
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              uiL10n.allNakath.toUpperCase(),
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.3,
                              ),
                              thickness: 1,
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
                    child: Container(
                      margin: const EdgeInsets.only(top: 40, bottom: 60),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          const SizedBox(height: 24),
                          Divider(
                            color: const Color(
                              0xFF3E2723,
                            ).withValues(alpha: 0.1),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'A Product of ChamXdev by Chamuditha Perera',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF8D6E63),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '© 2026 Nakath App. All rights reserved.',
                            style: TextStyle(
                              fontSize: 11,
                              color: const Color(
                                0xFF8D6E63,
                              ).withValues(alpha: 0.5),
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
