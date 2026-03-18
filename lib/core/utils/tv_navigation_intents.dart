import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class TvSelectIntent extends Intent {
  final VoidCallback? callback;
  const TvSelectIntent({this.callback});
}

class NavigateLeftIntent extends Intent {
  const NavigateLeftIntent();
}

class NavigateRightIntent extends Intent {
  const NavigateRightIntent();
}

class NavigateUpIntent extends Intent {
  const NavigateUpIntent();
}

class NavigateDownIntent extends Intent {
  const NavigateDownIntent();
}

class OpenDetailsIntent extends Intent {
  final int mediaId;
  final String mediaType;
  const OpenDetailsIntent({required this.mediaId, required this.mediaType});
}

class SelectAction extends Action<TvSelectIntent> {
  @override
  Object? invoke(TvSelectIntent intent) {
    intent.callback?.call();
    return null;
  }
}

class NavigateLeftAction extends Action<NavigateLeftIntent> {
  @override
  Object? invoke(NavigateLeftIntent intent) {
    return null;
  }
}

class NavigateRightAction extends Action<NavigateRightIntent> {
  @override
  Object? invoke(NavigateRightIntent intent) {
    return null;
  }
}

class NavigateUpAction extends Action<NavigateUpIntent> {
  @override
  Object? invoke(NavigateUpIntent intent) {
    return null;
  }
}

class NavigateDownAction extends Action<NavigateDownIntent> {
  @override
  Object? invoke(NavigateDownIntent intent) {
    return null;
  }
}

class OpenDetailsAction extends Action<OpenDetailsIntent> {
  final void Function(int id, String type) onOpen;

  OpenDetailsAction({required this.onOpen});

  @override
  Object? invoke(OpenDetailsIntent intent) {
    onOpen(intent.mediaId, intent.mediaType);
    return null;
  }
}

final tvShortcuts = <ShortcutActivator, Intent>{
  SingleActivator(LogicalKeyboardKey.enter): const TvSelectIntent(),
  SingleActivator(LogicalKeyboardKey.select): const TvSelectIntent(),
  SingleActivator(LogicalKeyboardKey.arrowLeft): const NavigateLeftIntent(),
  SingleActivator(LogicalKeyboardKey.arrowRight): const NavigateRightIntent(),
  SingleActivator(LogicalKeyboardKey.arrowUp): const NavigateUpIntent(),
  SingleActivator(LogicalKeyboardKey.arrowDown): const NavigateDownIntent(),
};
