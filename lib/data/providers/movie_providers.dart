import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/dio_client.dart';
import '../models/movie_model.dart';
import '../models/movie_detail_model.dart';
import '../models/tv_models.dart';
import '../services/movie_service.dart';

final movieServiceProvider = Provider<MovieService>((ref) {
  final dio = ref.watch(dioProvider);
  return MovieService(dio);
});

final trendingMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  final service = ref.watch(movieServiceProvider);
  return await service.getTrendingMovies();
});

final popularMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  final service = ref.watch(movieServiceProvider);
  return await service.getPopularMovies();
});

final topRatedMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  final service = ref.watch(movieServiceProvider);
  return await service.getTopRatedMovies();
});

final upcomingMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  final service = ref.watch(movieServiceProvider);
  return await service.getUpcomingMovies();
});

final trendingTvProvider = FutureProvider<List<Movie>>((ref) async {
  final service = ref.watch(movieServiceProvider);
  return await service.getTrendingTv();
});

// We need a class to pass multiple arguments to family providers
class MediaParams {
  final int id;
  final String mediaType;
  MediaParams(this.id, this.mediaType);

  @override
  bool operator ==(Object other) => identical(this, other) || other is MediaParams && id == other.id && mediaType == other.mediaType;
  @override
  int get hashCode => id.hashCode ^ mediaType.hashCode;
}

final mediaDetailsProvider = FutureProvider.family<MovieDetail, MediaParams>((ref, params) async {
  final service = ref.watch(movieServiceProvider);
  return await service.getMediaDetails(params.id, params.mediaType);
});

final mediaCastProvider = FutureProvider.family<List<Cast>, MediaParams>((ref, params) async {
  final service = ref.watch(movieServiceProvider);
  return await service.getMediaCast(params.id, params.mediaType);
});

final mediaTrailersProvider = FutureProvider.family<List<Trailer>, MediaParams>((ref, params) async {
  final service = ref.watch(movieServiceProvider);
  return await service.getMediaTrailers(params.id, params.mediaType);
});

class SeasonParams {
  final int tvId;
  final int seasonNumber;
  SeasonParams(this.tvId, this.seasonNumber);

  @override
  bool operator ==(Object other) => identical(this, other) || other is SeasonParams && tvId == other.tvId && seasonNumber == other.seasonNumber;
  @override
  int get hashCode => tvId.hashCode ^ seasonNumber.hashCode;
}

final tvSeasonProvider = FutureProvider.family<Season, SeasonParams>((ref, params) async {
  final service = ref.watch(movieServiceProvider);
  return await service.getTvSeason(params.tvId, params.seasonNumber);
});

final searchMoviesProvider = FutureProvider.family<List<Movie>, String>((ref, query) async {
  if (query.isEmpty) return [];
  final service = ref.watch(movieServiceProvider);
  return await service.searchMovies(query);
});
