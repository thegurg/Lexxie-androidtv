import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/providers/movie_providers.dart';
import '../../../widgets/navbar.dart';
import '../../../widgets/footer.dart';
import '../../../widgets/custom_search_bar.dart';
import '../../../widgets/movie_grid.dart';

// State provider for the search query to trigger reactivity
final searchQueryProvider = StateProvider<String>((ref) => '');

class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(searchQueryProvider);
    final searchResults = ref.watch(searchMoviesProvider(query));

    return Scaffold(
      appBar: const Navbar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).primaryColor.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Find Your Next Favorite',
                    style: Theme.of(context).textTheme.displaySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  CustomSearchBar(
                    onSearch: (value) {
                      ref.read(searchQueryProvider.notifier).state = value;
                    },
                  ),
                ],
              ),
            ),
            
            if (query.isEmpty)
              const Padding(
                padding: EdgeInsets.all(40.0),
                child: Center(
                  child: Text(
                    'Type something to start searching.',
                    style: TextStyle(color: Colors.white54, fontSize: 18),
                  ),
                ),
              )
            else
              searchResults.when(
                data: (movies) => MovieGrid(movies: movies),
                loading: () => const MovieGrid(movies: [], isLoading: true),
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
