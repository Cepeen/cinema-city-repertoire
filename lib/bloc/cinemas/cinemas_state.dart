import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../data/models/models.dart';

abstract class CinemasState extends Equatable {
  const CinemasState();

  @override
  List<Object> get props => [];
}

class CinemasInitial extends CinemasState {
  @override
  String toString() => 'CinemasInitial';
}

class CinemasLoading extends CinemasState {
  @override
  String toString() => 'CinemasLoading';
}

class CinemasLoaded extends CinemasState {
  final List<Cinema> cinemas;
  final List<String> favoriteCinemaIds;

  const CinemasLoaded({@required this.cinemas, @required this.favoriteCinemaIds}) : assert(cinemas != null), assert(favoriteCinemaIds != null);

  @override
  String toString() => 'CinemasLoaded $cinemas, $favoriteCinemaIds';
}

class CinemasError extends CinemasState {
  final String message;

  const CinemasError({@required this.message}) : assert(message != null);

  @override
  String toString() => 'CinemasError';
}