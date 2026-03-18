import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../core/config/api_config.dart';
import '../core/theme/app_theme.dart';
import '../data/models/movie_model.dart';
import '../core/utils/tv_navigation_intents.dart';
import 'rating_badge.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class MovieCard extends StatefulWidget {
  final Movie movie;
  final double width;
  final double height;
  final FocusNode? focusNode;
  final VoidCallback? onEnterPressed;

  const MovieCard({
    super.key,
    required this.movie,
    this.width = 140,
    this.height = 210,
    this.focusNode,
    this.onEnterPressed,
  });

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  bool _isHovered = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: tvShortcuts,
      child: Actions(
        actions: <Type, Action<Intent>>{
          TvSelectIntent: CallbackAction<TvSelectIntent>(
            onInvoke: (intent) {
              widget.onEnterPressed ??
                  context.push(
                    '/details/${widget.movie.mediaType}/${widget.movie.id}',
                  );
              return null;
            },
          ),
        },
        child: Focus(
          focusNode: _focusNode,
          onFocusChange: (hasFocus) {
            setState(() {
              if (hasFocus) _isHovered = true;
            });
          },
          onKeyEvent: (node, event) => KeyEventResult.handled,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: GestureDetector(
              onTap: () => context.push(
                '/details/${widget.movie.mediaType}/${widget.movie.id}',
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: widget.width,
                margin: const EdgeInsets.only(right: 16),
                transform: Matrix4.identity()
                  ..scaleByVector3(Vector3.all(_isHovered ? 1.05 : 1.0)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: _isHovered
                        ? AppTheme.primaryColor
                        : AppTheme.borderColor,
                    width: _isHovered ? 1.5 : 1,
                  ),
                  boxShadow: _isHovered
                      ? [
                          BoxShadow(
                            color: AppTheme.primaryColor.withValues(alpha: 0.5),
                            blurRadius: 20,
                            spreadRadius: 1,
                          ),
                          BoxShadow(
                            color: AppTheme.primaryGlow.withValues(alpha: 0.3),
                            blurRadius: 40,
                            spreadRadius: 2,
                          ),
                        ]
                      : [],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (widget.movie.posterPath != null)
                        CachedNetworkImage(
                          imageUrl:
                              '${ApiConfig.imageBaseUrl}${widget.movie.posterPath}',
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: AppTheme.surfaceColor,
                            highlightColor: AppTheme.borderColor,
                            child: Container(color: AppTheme.surfaceColor),
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.broken_image,
                            color: AppTheme.textSecondary,
                          ),
                        )
                      else
                        Container(
                          color: AppTheme.surfaceColor,
                          child: const Center(
                            child: Icon(
                              Icons.movie,
                              size: 40,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ),

                      // Cyberpunk scan-line overlay on hover
                      if (_isHovered)
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppTheme.primaryColor.withValues(alpha: 0.08),
                                Colors.transparent,
                                AppTheme.primaryColor.withValues(alpha: 0.08),
                              ],
                            ),
                          ),
                        ),

                      // Rating badge
                      Positioned(
                        top: 8,
                        right: 8,
                        child: RatingBadge(rating: widget.movie.voteAverage),
                      ),

                      // Title gradient at bottom
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(8, 24, 8, 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.95),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Text(
                            widget.movie.title,
                            style: const TextStyle(
                              fontFamily: 'Iceland',
                              color: AppTheme.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
