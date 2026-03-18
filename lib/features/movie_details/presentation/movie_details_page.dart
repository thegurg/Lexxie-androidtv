import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/config/api_config.dart';
import '../../../data/providers/movie_providers.dart';
import '../../../data/models/tv_models.dart';
import '../../../widgets/navbar.dart';
import '../../../widgets/footer.dart';
import '../../../widgets/rating_badge.dart';
import '../../../widgets/vidking_player.dart';
import 'package:responsive_framework/responsive_framework.dart';

class MovieDetailsPage extends ConsumerStatefulWidget {
  final int mediaId;
  final String mediaType;

  const MovieDetailsPage({
    super.key,
    required this.mediaId,
    required this.mediaType,
  });

  @override
  ConsumerState<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends ConsumerState<MovieDetailsPage> {
  bool _isPlaying = false;
  int? _selectedSeason;
  int? _selectedEpisode;

  @override
  Widget build(BuildContext context) {
    final mediaParams = MediaParams(widget.mediaId, widget.mediaType);
    final detailsAsync = ref.watch(mediaDetailsProvider(mediaParams));
    final castAsync = ref.watch(mediaCastProvider(mediaParams));
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const Navbar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            detailsAsync.when(
              loading: () => const SizedBox(
                height: 500,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => Center(child: Text('Error: $err')),
              data: (movie) {
                // Default selections for TV shows
                if (widget.mediaType == 'tv' &&
                    movie.seasons.isNotEmpty &&
                    _selectedSeason == null) {
                  // Wait for build to finish before setting state to avoid errors
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      // Skip season 0 (Specials) — pick first real season
                      final List<Season> allSeasons = (movie.seasons as List)
                          .cast<Season>();
                      final Season firstReal = allSeasons.firstWhere(
                        (s) => s.seasonNumber > 0,
                        orElse: () => allSeasons.first,
                      );
                      setState(() {
                        _selectedSeason = firstReal.seasonNumber;
                        _selectedEpisode = 1;
                      });
                    }
                  });
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Backdrop Hero or Player
                    Stack(
                      children: [
                        if (_isPlaying)
                          SizedBox(
                            height: isDesktop ? 600 : 400,
                            width: double.infinity,
                            child: VidkingPlayer(
                              tmdbId: widget.mediaId,
                              mediaType: widget.mediaType,
                              season: _selectedSeason,
                              episode: _selectedEpisode,
                            ),
                          )
                        else if (movie.backdropPath != null)
                          ShaderMask(
                            shaderCallback: (rect) {
                              return LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black,
                                  Colors.black.withValues(alpha: 0.5),
                                  Colors.transparent,
                                ],
                                stops: const [0.0, 0.5, 1.0],
                              ).createShader(
                                Rect.fromLTRB(0, 0, rect.width, rect.height),
                              );
                            },
                            blendMode: BlendMode.dstIn,
                            child: CachedNetworkImage(
                              imageUrl:
                                  '${ApiConfig.originalImageBaseUrl}${movie.backdropPath}',
                              height: isDesktop ? 600 : 400,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          )
                        else
                          Container(
                            height: isDesktop ? 600 : 400,
                            color: Colors.grey[900],
                            width: double.infinity,
                          ),

                        if (!_isPlaying)
                          Container(
                            height: isDesktop ? 600 : 400,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Theme.of(context).scaffoldBackgroundColor,
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        if (!_isPlaying)
                          Positioned(
                            bottom: 40,
                            left: 40,
                            right: 40,
                            child: isDesktop
                                ? Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      if (movie.posterPath != null)
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                '${ApiConfig.imageBaseUrl}${movie.posterPath}',
                                            width: 200,
                                            height: 300,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      const SizedBox(width: 40),
                                      Expanded(
                                        child: _buildMovieDetailsInfo(
                                          context,
                                          movie,
                                        ),
                                      ),
                                    ],
                                  )
                                : _buildMovieDetailsInfo(context, movie),
                          ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.mediaType == 'tv' &&
                              movie.seasons.isNotEmpty) ...[
                            _buildTvSelectors(movie),
                            const SizedBox(height: 32),
                          ],

                          Text(
                            'Overview',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            movie.overview,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(height: 1.6),
                          ),
                          const SizedBox(height: 48),
                          Text(
                            'Top Cast',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 24),

                          // Cast List
                          castAsync.when(
                            loading: () => const CircularProgressIndicator(),
                            error: (err, stack) => Text('Error: $err'),
                            data: (cast) {
                              return SizedBox(
                                height: 260,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: cast.length > 10
                                      ? 10
                                      : cast.length,
                                  itemBuilder: (context, index) {
                                    final actor = cast[index];
                                    return Container(
                                      width: 140,
                                      margin: const EdgeInsets.only(right: 16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: actor.profilePath != null
                                                  ? CachedNetworkImage(
                                                      imageUrl:
                                                          '${ApiConfig.imageBaseUrl}${actor.profilePath}',
                                                      fit: BoxFit.cover,
                                                      width: double.infinity,
                                                    )
                                                  : Container(
                                                      color: Colors.grey[800],
                                                      child: const Center(
                                                        child: Icon(
                                                          Icons.person,
                                                          size: 50,
                                                        ),
                                                      ),
                                                    ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            actor.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            actor.character,
                                            style: const TextStyle(
                                              color: Colors.white54,
                                              fontSize: 12,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 60),
            const Footer(),
          ],
        ),
      ),
    );
  }

  Widget _buildTvSelectors(dynamic movie) {
    if (_selectedSeason == null || _selectedEpisode == null) {
      return const SizedBox();
    }

    final List<Season> seasons = (movie.seasons as List).cast<Season>();
    // Only real seasons (exclude season 0 / Specials)
    final List<Season> realSeasons = seasons
        .where((s) => s.seasonNumber > 0)
        .toList();

    final Season currentSeason = realSeasons.firstWhere(
      (s) => s.seasonNumber == _selectedSeason,
      orElse: () => realSeasons.isNotEmpty ? realSeasons.first : seasons.first,
    );

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: DropdownButtonFormField<int>(
            decoration: const InputDecoration(labelText: 'Season'),
            initialValue: _selectedSeason,
            items: realSeasons.map<DropdownMenuItem<int>>((s) {
              return DropdownMenuItem<int>(
                value: s.seasonNumber,
                child: Text('Season ${s.seasonNumber}'),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) {
                setState(() {
                  _selectedSeason = val;
                  _selectedEpisode = 1; // Reset to Ep 1 when changing seasons
                  // Restart player to apply changes
                  if (_isPlaying) {
                    _isPlaying = false;
                    Future.delayed(const Duration(milliseconds: 100), () {
                      if (mounted) setState(() => _isPlaying = true);
                    });
                  }
                });
              }
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: DropdownButtonFormField<int>(
            decoration: const InputDecoration(labelText: 'Episode'),
            initialValue: _selectedEpisode,
            items: List.generate(currentSeason.episodeCount, (index) {
              final epNum = index + 1;
              return DropdownMenuItem<int>(
                value: epNum,
                child: Text('Episode $epNum'),
              );
            }),
            onChanged: (val) {
              if (val != null) {
                setState(() {
                  _selectedEpisode = val;
                  // Restart player to apply changes
                  if (_isPlaying) {
                    _isPlaying = false;
                    Future.delayed(const Duration(milliseconds: 100), () {
                      if (mounted) setState(() => _isPlaying = true);
                    });
                  }
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMovieDetailsInfo(BuildContext context, dynamic movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(movie.title, style: Theme.of(context).textTheme.displayMedium),
        const SizedBox(height: 16),
        Row(
          children: [
            RatingBadge(rating: movie.voteAverage),
            const SizedBox(width: 16),
            if (movie.releaseDate != null && movie.releaseDate!.length >= 4)
              Text(
                movie.releaseDate!.substring(0, 4),
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            const SizedBox(width: 16),
            if (movie.runtime != null)
              Text(
                '${movie.runtime} min',
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: movie.genres.map<Widget>((genre) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white24),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(genre, style: const TextStyle(fontSize: 12)),
            );
          }).toList(),
        ),
        const SizedBox(height: 32),
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              _isPlaying = true;
            });
            // Scroll to top where player is
            Scrollable.ensureVisible(context);
          },
          icon: const Icon(Icons.play_arrow, size: 28),
          label: Text(widget.mediaType == 'tv' ? 'Watch Episode' : 'Watch Now'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
