import 'package:flutter/material.dart';

import 'player/vidking_player_stub.dart'
    if (dart.library.html) 'player/vidking_player_web.dart'
    if (dart.library.io) 'player/vidking_player_native.dart';

class VidkingPlayer extends StatelessWidget {
  final int tmdbId;
  final String mediaType; // 'movie' or 'tv'
  final int? season;
  final int? episode;

  const VidkingPlayer({
    super.key,
    required this.tmdbId,
    required this.mediaType,
    this.season,
    this.episode,
  });

  @override
  Widget build(BuildContext context) {
    return getPlayerWidget(
      tmdbId: tmdbId,
      mediaType: mediaType,
      season: season,
      episode: episode,
    );
  }
}
