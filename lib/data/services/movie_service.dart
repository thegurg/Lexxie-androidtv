import 'package:dio/dio.dart';
import '../../core/config/api_config.dart';
import '../models/movie_model.dart';
import '../models/movie_detail_model.dart';
import '../models/tv_models.dart';

class MovieService {
  final Dio _dio;

  MovieService(this._dio);

  Future<List<Movie>> getTrendingMovies() async {
    final response = await _dio.get(ApiConfig.trendingMovies);
    return (response.data['results'] as List)
        .map((json) => Movie.fromJson(json))
        .toList();
  }

  Future<List<Movie>> getTrendingTv() async {
    final response = await _dio.get(ApiConfig.trendingTv);
    // Explicitly set the media type to tv since trending endpoint might not include it sometimes
    return (response.data['results'] as List)
        .map((json) {
          json['media_type'] = 'tv';
          return Movie.fromJson(json);
        })
        .toList();
  }

  Future<List<Movie>> getPopularMovies() async {
    final response = await _dio.get(ApiConfig.popularMovies);
    return (response.data['results'] as List)
        .map((json) => Movie.fromJson(json))
        .toList();
  }

  Future<List<Movie>> getTopRatedMovies() async {
    final response = await _dio.get(ApiConfig.topRatedMovies);
    return (response.data['results'] as List)
        .map((json) => Movie.fromJson(json))
        .toList();
  }

  Future<List<Movie>> getUpcomingMovies() async {
    final response = await _dio.get(ApiConfig.upcomingMovies);
    return (response.data['results'] as List)
        .map((json) => Movie.fromJson(json))
        .toList();
  }

  Future<List<Movie>> searchMovies(String query) async {
    final response = await _dio.get(ApiConfig.searchMulti, queryParameters: {'query': query});
    return (response.data['results'] as List)
        .map((json) => Movie.fromJson(json))
        .toList();
  }

  Future<MovieDetail> getMediaDetails(int id, String mediaType) async {
    final url = mediaType == 'tv' ? ApiConfig.tvDetails(id) : ApiConfig.movieDetails(id);
    final response = await _dio.get(url);
    return MovieDetail.fromJson(response.data, mediaType: mediaType);
  }

  Future<List<Cast>> getMediaCast(int id, String mediaType) async {
    final url = mediaType == 'tv' ? ApiConfig.tvCredits(id) : ApiConfig.movieCredits(id);
    final response = await _dio.get(url);
    return (response.data['cast'] as List)
        .map((json) => Cast.fromJson(json))
        .toList();
  }

  Future<List<Trailer>> getMediaTrailers(int id, String mediaType) async {
    final url = mediaType == 'tv' ? ApiConfig.tvVideos(id) : ApiConfig.movieVideos(id);
    final response = await _dio.get(url);
    return (response.data['results'] as List)
        .map((json) => Trailer.fromJson(json))
        .toList();
  }

  Future<Season> getTvSeason(int tvId, int seasonNumber) async {
    final response = await _dio.get(ApiConfig.tvSeason(tvId, seasonNumber));
    return Season.fromJson(response.data);
  }
}
