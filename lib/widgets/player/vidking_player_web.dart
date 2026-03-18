// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';

Widget getPlayerWidget({
  required int tmdbId,
  required String mediaType,
  int? season,
  int? episode,
}) {
  return _WebPlayer(
    tmdbId: tmdbId,
    mediaType: mediaType,
    season: season,
    episode: episode,
  );
}

class _WebPlayer extends StatefulWidget {
  final int tmdbId;
  final String mediaType;
  final int? season;
  final int? episode;

  const _WebPlayer({
    required this.tmdbId,
    required this.mediaType,
    this.season,
    this.episode,
  });

  @override
  State<_WebPlayer> createState() => _WebPlayerState();
}

class _WebPlayerState extends State<_WebPlayer> {
  late String _viewId;
  late String _iframeUrl;

  @override
  void initState() {
    super.initState();
    _viewId = 'vidking-player-${widget.tmdbId}-${widget.mediaType}-${widget.season}-${widget.episode}-${DateTime.now().millisecondsSinceEpoch}';

    if (widget.mediaType == 'tv' && widget.season != null && widget.episode != null) {
      _iframeUrl = 'https://vidking.net/embed/tv/${widget.tmdbId}/${widget.season}/${widget.episode}';
    } else {
      _iframeUrl = 'https://vidking.net/embed/movie/${widget.tmdbId}';
    }

    // Register iframe inside web environment
    // ignore: undefined_prefixed_name
    ui_web.platformViewRegistry.registerViewFactory(
      _viewId,
      (int viewId) {
        final iframe = html.IFrameElement()
          ..src = _iframeUrl
          ..style.border = 'none'
          ..style.height = '100%'
          ..style.width = '100%'
          ..allowFullscreen = true;
        return iframe;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: HtmlElementView(
          viewType: _viewId,
        ),
      ),
    );
  }
}
