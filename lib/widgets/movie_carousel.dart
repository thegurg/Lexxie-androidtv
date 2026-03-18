import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_theme.dart';
import '../data/models/movie_model.dart';
import '../core/utils/tv_navigation_intents.dart';
import 'movie_card.dart';

class MovieCarousel extends StatefulWidget {
  final String title;
  final List<Movie> movies;
  final bool isLoading;

  const MovieCarousel({
    super.key,
    required this.title,
    required this.movies,
    this.isLoading = false,
  });

  @override
  State<MovieCarousel> createState() => _MovieCarouselState();
}

class _MovieCarouselState extends State<MovieCarousel> {
  late ScrollController _scrollController;
  final FocusNode _carouselFocusNode = FocusNode();
  int _focusedIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _carouselFocusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        if (_focusedIndex < widget.movies.length - 1) {
          setState(() => _focusedIndex++);
          _scrollToFocusedItem();
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        if (_focusedIndex > 0) {
          setState(() => _focusedIndex--);
          _scrollToFocusedItem();
        }
      } else if (event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.select) {
        if (_focusedIndex < widget.movies.length) {
          final movie = widget.movies[_focusedIndex];
          context.push('/details/${movie.mediaType}/${movie.id}');
        }
      }
    }
  }

  void _scrollToFocusedItem() {
    const itemWidth = 156.0;
    final offset = _focusedIndex * itemWidth;
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
          child: Row(
            children: [
              Container(
                width: 3,
                height: 20,
                margin: const EdgeInsets.only(right: 10),
                decoration: const BoxDecoration(
                  color: AppTheme.primaryColor,
                  boxShadow: [
                    BoxShadow(color: AppTheme.primaryColor, blurRadius: 8),
                  ],
                ),
              ),
              Text(
                '// ${widget.title}',
                style: const TextStyle(
                  fontFamily: 'TurretRoad',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  letterSpacing: 1.5,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 220,
          child: widget.isLoading
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 140,
                      margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppTheme.borderColor),
                      ),
                    );
                  },
                )
              : Shortcuts(
                  shortcuts: tvShortcuts,
                  child: Actions(
                    actions: <Type, Action<Intent>>{
                      TvSelectIntent: CallbackAction<TvSelectIntent>(
                        onInvoke: (intent) {
                          if (_focusedIndex < widget.movies.length) {
                            final movie = widget.movies[_focusedIndex];
                            context.push(
                              '/details/${movie.mediaType}/${movie.id}',
                            );
                          }
                          return null;
                        },
                      ),
                    },
                    child: Focus(
                      focusNode: _carouselFocusNode,
                      onKeyEvent: (node, event) {
                        _handleKeyEvent(event);
                        return KeyEventResult.handled;
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        itemCount: widget.movies.length,
                        itemBuilder: (context, index) {
                          return MovieCard(
                            movie: widget.movies[index],
                            onEnterPressed: () {
                              final movie = widget.movies[index];
                              context.push(
                                '/details/${movie.mediaType}/${movie.id}',
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
