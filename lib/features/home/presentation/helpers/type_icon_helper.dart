import 'package:flutter/material.dart';

IconData getTypeIcon(String type) {
  final t = type.toLowerCase();
  switch (t) {
    case 'grass':
      return Icons.eco;
    case 'fire':
      return Icons.local_fire_department;
    case 'water':
      return Icons.water_drop;
    case 'bug':
      return Icons.bug_report;
    case 'normal':
      return Icons.circle;
    case 'poison':
      return Icons.science;
    case 'electric':
      return Icons.flash_on;
    case 'ground':
      return Icons.terrain;
    case 'fairy':
      return Icons.auto_awesome;
    case 'fighting':
      return Icons.sports_mma;
    case 'psychic':
      return Icons.psychology;
    case 'rock':
      return Icons.terrain;
    case 'ghost':
      return Icons.nightlight_round;
    case 'ice':
      return Icons.ac_unit;
    case 'dragon':
      return Icons.whatshot;
    case 'dark':
      return Icons.nights_stay;
    case 'steel':
      return Icons.build;
    case 'flying':
      return Icons.flight;
    default:
      return Icons.help_outline;
  }
}
