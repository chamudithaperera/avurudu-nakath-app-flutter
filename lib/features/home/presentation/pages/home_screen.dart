import 'package:flutter/material.dart';
import '../../data/datasources/nakath_local_data_source.dart';
import '../../data/repositories/nakath_repository_impl.dart';
import '../../domain/entities/nakath_event.dart';
import '../../domain/usecases/get_all_nakath_events.dart';
import '../widgets/nakath_hero_card.dart';
import '../widgets/nakath_list_tile.dart';
import '../widgets/nakath_detail_popup.dart'; // Added
import 'package:avurudu_nakath_app/l10n/generated/ui/ui_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/services/notification_service.dart';
import '../../../../core/widgets/kandyan_background.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          uiL10n.appTitle,
          style: GoogleFonts.cinzel(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.6,
            color: const Color(0xFFF8EED1),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFFF8EED1)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(14),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: 2,
            width: 180,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFC99A3B), Color(0xFF8C1B1B)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.language_rounded),
            onPressed: () {
              // TODO: Navigate to language selection or show quick picker
            },
          ),
        ],
      ),
      body: KandyanBackground(
        child: FutureBuilder<List<NakathEvent>>(
          future: _eventsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFFC99A3B)),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Color(0xFFF8EED1)),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No nakath events found.',
                  style: TextStyle(color: Color(0xFFF8EED1)),
                ),
              );
            }

            final events = snapshot.data!;
            final now = DateTime.now();
            final upcomingEvents = events.where((e) {
              final t =
                  e.start ?? (e.date != null ? DateTime.tryParse(e.date!) : null);
              return t != null && t.isAfter(now);
            }).toList();

            final nextEvent =
                upcomingEvents.isNotEmpty ? upcomingEvents.first : events.first;
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
                      vertical: 20,
                      horizontal: 24,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFFC99A3B).withValues(alpha: 0.2),
                                  const Color(0xFFC99A3B),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            uiL10n.allNakath.toUpperCase(),
                            style: GoogleFonts.cinzel(
                              color: const Color(0xFFF8EED1),
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFFC99A3B),
                                  const Color(0xFFC99A3B).withValues(alpha: 0.2),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
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
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.only(top: 40, bottom: 60),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        Divider(
                          color: const Color(0xFFC99A3B).withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'A Product of ChamXdev by Chamuditha Perera',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFE9D5A8),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '© 2026 Nakath App. All rights reserved.',
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 11,
                            color: const Color(0xFFE9D5A8).withValues(alpha: 0.7),
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
      ),
    );
  }
}
