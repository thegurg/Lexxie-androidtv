class Season {
  final int id;
  final String name;
  final String overview;
  final int seasonNumber;
  final int episodeCount;
  final String? posterPath;
  List<Episode> episodes;

  Season({
    required this.id,
    required this.name,
    required this.overview,
    required this.seasonNumber,
    required this.episodeCount,
    this.posterPath,
    this.episodes = const [],
  });

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      id: json['id'],
      name: json['name'],
      overview: json['overview'] ?? '',
      seasonNumber: json['season_number'],
      episodeCount: json['episode_count'],
      posterPath: json['poster_path'],
      episodes: (json['episodes'] as List?)
              ?.map((e) => Episode.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class Episode {
  final int id;
  final String name;
  final String overview;
  final int seasonNumber;
  final int episodeNumber;
  final String? stillPath;
  final double voteAverage;

  Episode({
    required this.id,
    required this.name,
    required this.overview,
    required this.seasonNumber,
    required this.episodeNumber,
    this.stillPath,
    required this.voteAverage,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'],
      name: json['name'],
      overview: json['overview'] ?? '',
      seasonNumber: json['season_number'],
      episodeNumber: json['episode_number'],
      stillPath: json['still_path'],
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
