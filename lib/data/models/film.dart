import 'package:flutter/material.dart';

import 'film_details.dart';

const Map<String, String> genreMap = {
  'action': 'Akcja',
  'adventure': 'Przygodowy',
  'animation': 'Animowany',
  'bollywood': 'Bollywood',
  'comedy': 'Komedia',
  'crime': 'Kryminalny',
  'documentary': 'Dokument',
  'drama': 'Dramat',
  'family': 'Familijny',
  'fantasy': 'Fantasy',
  'history': 'Historczny',
  'horror': 'Horror',
  'kids-club': 'Dla dzieci',
  'live': 'Na żywo',
  'musical': 'Musical',
  'romance': 'Romantyczny',
  'sci-fi': 'Sci-Fi',
  'sport': 'Sport',
  'thriller': 'Thriller',
  'war': 'Wojenny',
  'western': 'Western'
};

class Film {
  final String id;
  final String name;
  final int length;
  final String posterLink;
  final List<String> genres;
  final String ageRestriction;
  final String link;
  FilmDetails details;

  Film({
    @required this.id,
    @required this.name,
    @required this.length,
    @required this.posterLink,
    @required this.genres,
    @required this.ageRestriction,
    @required this.link,
    this.details,
  });

  factory Film.fromJson(Map<String, dynamic> json) {
    var tempAgeRestriction = 'NA';
    List<String> loadedGenres = [];

    json['attributeIds'].forEach((attr) {
      genreMap.forEach((key, val) {
        if (key == attr) {
          loadedGenres.add(val);
        }
      });
      if (attr.toString().contains('plus')) {
        tempAgeRestriction = attr.toString().substring(0, attr.toString().indexOf('-'));
      }
    });

    return Film(
      id: json['id'],
      name: json['name'],
      ageRestriction: tempAgeRestriction,
      genres: loadedGenres,
      length: json['length'],
      posterLink: json['posterLink'],
      link: json['link']
    );
  }
}
