import 'tv_models.dart';

class MovieDetail {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final String? releaseDate;
  final int? runtime;
  final List<String> genres;
  final String mediaType;
  final List<Season> seasons;

  MovieDetail({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    this.releaseDate,
    this.runtime,
    this.genres = const [],
    this.mediaType = 'movie',
    this.seasons = const [],
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json, {String mediaType = 'movie'}) {
    return MovieDetail(
      id: json['id'],
      title: json['title'] ?? json['name'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      releaseDate: json['release_date'] ?? json['first_air_date'],
      runtime: json['runtime'] ?? (json['episode_run_time'] != null && json['episode_run_time'].isNotEmpty ? json['episode_run_time'][0] : null),
      genres: (json['genres'] as List?)?.map((e) => e['name'].toString()).toList() ?? [],
      mediaType: mediaType,
      seasons: (json['seasons'] as List?)?.map((e) => Season.fromJson(e)).toList() ?? [],
    );
  }
}

class Cast {
  final String name;
  final String character;
  final String? profilePath;

  Cast({required this.name, required this.character, this.profilePath});

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      name: json['name'],
      character: json['character'],
      profilePath: json['profile_path'],
    );
  }
}

class Trailer {
  final String key;
  final String site;
  final String type;

  Trailer({required this.key, required this.site, required this.type});

  factory Trailer.fromJson(Map<String, dynamic> json) {
    return Trailer(
      key: json['key'],
      site: json['site'],
      type: json['type'],
    );
  }
}
