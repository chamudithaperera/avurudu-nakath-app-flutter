import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/nakath_event_model.dart';

abstract class NakathLocalDataSource {
  Future<List<NakathEventModel>> getNakathEvents();
}

class NakathLocalDataSourceImpl implements NakathLocalDataSource {
  @override
  Future<List<NakathEventModel>> getNakathEvents() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/nakath_2025.json',
    );
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    final List<dynamic> eventsJson = jsonMap['events'];

    return eventsJson.map((json) => NakathEventModel.fromJson(json)).toList();
  }
}
