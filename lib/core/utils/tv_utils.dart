import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

bool isTvMode(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final aspectRatio = size.width / size.height;

  return size.width >= 1200 || (aspectRatio >= 1.6 && size.width >= 800);
}

bool get isAndroidTv {
  if (!kIsWeb) {
    return defaultTargetPlatform == TargetPlatform.android;
  }
  return false;
}
