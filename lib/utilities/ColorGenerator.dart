import 'dart:math';
import 'package:flutter/material.dart';

class ColorGenerator {
  static Color getColor() {
    Random _random = new Random();
    return Color.fromARGB(255, _random.nextInt(255), _random.nextInt(255), _random.nextInt(255));
  }
}