import 'package:flutter/material.dart';

String greetings() {
  final hour = TimeOfDay.now().hour;

  if (hour <= 12) {
    return 'Good Morning';
  } else if (hour <= 17) {
    return 'Cood Afternoon';
  }
  return 'Good Evening';
}
