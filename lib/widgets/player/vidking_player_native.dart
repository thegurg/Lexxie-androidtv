import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

Widget getPlayerWidget({
  required int tmdbId,
  required String mediaType,
  int? season,
  int? episode,
}) {
  return _NativePlayer(
    tmdbId: tmdbId,
    mediaType: mediaType,
    season: season,
    episode: episode,
  );
}

class _NativePlayer extends StatefulWidget {
  final int tmdbId;
  final String mediaType;
  final int? season;
  final int? episode;

  const _NativePlayer({
    required this.tmdbId,
    required this.mediaType,
    this.season,
    this.episode,
  });

  @override
  State<_NativePlayer> createState() => _NativePlayerState();
}

class _NativePlayerState extends State<_NativePlayer> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    late String iframeUrl;

    if (widget.mediaType == 'tv' && widget.season != null && widget.episode != null) {
      iframeUrl = 'https://vidking.net/embed/tv/${widget.tmdbId}/${widget.season}/${widget.episode}';
    } else {
      iframeUrl = 'https://vidking.net/embed/movie/${widget.tmdbId}';
    }

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(iframeUrl));
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
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(color: Color(0xFF7B3FF2)),
              ),
          ],
        ),
      ),
    );
  }
}
