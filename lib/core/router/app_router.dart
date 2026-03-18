import 'package:go_router/go_router.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/movie_details/presentation/movie_details_page.dart';
import '../../features/search/presentation/search_page.dart';
import '../../features/splash/presentation/splash_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchPage(),
    ),
    GoRoute(
      path: '/details/:type/:id',
      builder: (context, state) {
        final idStr = state.pathParameters['id'];
        final type = state.pathParameters['type'] ?? 'movie';
        final id = int.tryParse(idStr ?? '0') ?? 0;
        return MovieDetailsPage(mediaId: id, mediaType: type);
      },
    ),
  ],
);
