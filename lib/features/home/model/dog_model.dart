import 'package:flutter/material.dart';

@immutable
class ImmutableDog {
  const ImmutableDog({required this.name, required this.imageUrl});

  final String name;
  final String imageUrl; 
}
