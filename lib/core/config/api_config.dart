class ApiConfig {
  static const String apiKey = 'Your Tmdb Api key';
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  static const String originalImageBaseUrl =
      'https://image.tmdb.org/t/p/original';

  static const String trendingMovies = '/trending/movie/day';
  static const String trendingTv = '/trending/tv/day';
  static const String popularMovies = '/movie/popular';
  static const String topRatedMovies = '/movie/top_rated';
  static const String upcomingMovies = '/movie/upcoming';
  static const String searchMulti = '/search/multi';

  static String movieDetails(int id) => '/movie/$id';
  static String movieCredits(int id) => '/movie/$id/credits';
  static String movieVideos(int id) => '/movie/$id/videos';
  
  static String tvDetails(int id) => '/tv/$id';
  static String tvCredits(int id) => '/tv/$id/credits';
  static String tvVideos(int id) => '/tv/$id/videos';
  static String tvSeason(int id, int seasonNumber) => '/tv/$id/season/$seasonNumber';
}
