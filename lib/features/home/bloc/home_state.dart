import 'package:dog_app/features/home/model/dog_model.dart';
import 'package:flutter/material.dart';

enum HomeStatus { initial, loading, done, error }

@immutable
class HomeState {
  const HomeState({required this.status, this.dogs,this.errorMessage,});

  final HomeStatus status;
  final List<ImmutableDog>? dogs;
  final String? errorMessage;
}
