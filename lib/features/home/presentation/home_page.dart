import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/providers/movie_providers.dart';
import '../../../widgets/navbar.dart';
import '../../../widgets/footer.dart';
import '../../../widgets/movie_carousel.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trending = ref.watch(trendingMoviesProvider);
    final trendingTv = ref.watch(trendingTvProvider);
    final popular = ref.watch(popularMoviesProvider);
    final topRated = ref.watch(topRatedMoviesProvider);
    final upcoming = ref.watch(upcomingMoviesProvider);

    return Scaffold(
      appBar: const Navbar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trending Carousel
            trending.when(
              data: (movies) => MovieCarousel(title: 'Trending Movies', movies: movies),
              loading: () => const MovieCarousel(title: 'Trending Movies', movies: [], isLoading: true),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
            
            // Trending TV Shows
            trendingTv.when(
              data: (movies) => MovieCarousel(title: 'Trending TV Shows', movies: movies),
              loading: () => const MovieCarousel(title: 'Trending TV Shows', movies: [], isLoading: true),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
            
            // Popular Carousel
            popular.when(
              data: (movies) => MovieCarousel(title: 'Popular on q.o.leexie', movies: movies),
              loading: () => const MovieCarousel(title: 'Popular on q.o.leexie', movies: [], isLoading: true),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),

            // Top Rated Carousel
            topRated.when(
              data: (movies) => MovieCarousel(title: 'Critically Acclaimed', movies: movies),
              loading: () => const MovieCarousel(title: 'Critically Acclaimed', movies: [], isLoading: true),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),

            // Upcoming Carousel
            upcoming.when(
              data: (movies) => MovieCarousel(title: 'Upcoming Releases', movies: movies),
              loading: () => const MovieCarousel(title: 'Upcoming Releases', movies: [], isLoading: true),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),

            const SizedBox(height: 40),
            const Footer(),
          ],
        ),
      ),
    );
  }
}
