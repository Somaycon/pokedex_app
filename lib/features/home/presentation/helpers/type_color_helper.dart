import 'package:flutter/material.dart';

Color getTypeColor(String type) {
  final key = type.toLowerCase().trim();
  return _typeColors[key] ?? _defaultColor;
}

Color getTypeTextColor(String type) {
  final bg = getTypeColor(type);
  return bg.computeLuminance() > 0.5 ? Colors.black : Colors.white;
}

const Color _defaultColor = Colors.grey;

final Map<String, Color> _typeColors = {
  'normal': Color(0xFFA8A77A),
  'fire': Color(0xFFEE8130),
  'water': Color(0xFF6390F0),
  'electric': Color(0xFFF7D02C),
  'grass': Color(0xFF7AC74C),
  'ice': Color(0xFF96D9D6),
  'fighting': Color(0xFFC22E28),
  'poison': Color(0xFFA33EA1),
  'ground': Color(0xFFE2BF65),
  'flying': Color(0xFFA98FF3),
  'psychic': Color(0xFFF95587),
  'bug': Color(0xFFA6B91A),
  'rock': Color(0xFFB6A136),
  'ghost': Color(0xFF735797),
  'dark': Color(0xFF705746),
  'dragon': Color(0xFF6F35FC),
  'steel': Color(0xFFB7B7CE),
  'fairy': Color(0xFFD685AD),
};
