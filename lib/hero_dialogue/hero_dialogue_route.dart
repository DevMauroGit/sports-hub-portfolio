import 'package:flutter/material.dart';

/// A custom PageRoute for displaying a dialog with transparent background.
/// This route is non-opaque, allowing the underlying screen to be visible with a dark overlay.
class HeroDialogRoute<T> extends PageRoute<T> {
  HeroDialogRoute({
    required WidgetBuilder builder,
    super.settings,
    super.fullscreenDialog,
  }) : _builder = builder;

  final WidgetBuilder _builder;

  /// Make the route non-opaque to allow background to be visible.
  @override
  bool get opaque => false;

  /// Allow dismissing the dialog by tapping outside its bounds.
  @override
  bool get barrierDismissible => true;

  /// Duration of the transition animation (though no animation is applied here).
  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  /// Keep the state of this route alive when it is inactive.
  @override
  bool get maintainState => true;

  /// Color of the modal barrier that darkens the background.
  @override
  Color get barrierColor => Colors.black54;

  /// Build the transition animation, here simply returning the child without animation.
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }

  /// Build the content of the route using the provided builder.
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return _builder(context);
  }

  /// Accessibility label for the modal barrier.
  @override
  String get barrierLabel => 'Popup dialog open';
}
