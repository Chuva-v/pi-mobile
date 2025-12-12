import 'package:flutter/material.dart';

class Rotasemanimacao<T> extends MaterialPageRoute<T> {
  Rotasemanimacao({
    required WidgetBuilder builder,
    RouteSettings? settings,
  }) : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child; // <-- remove todas as animações
  }
}
