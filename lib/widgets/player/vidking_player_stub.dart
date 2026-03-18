import 'package:flutter/material.dart';

Widget getPlayerWidget({
  required int tmdbId,
  required String mediaType,
  int? season,
  int? episode,
}) {
  throw UnsupportedError('Cannot play video on this platform');
}
