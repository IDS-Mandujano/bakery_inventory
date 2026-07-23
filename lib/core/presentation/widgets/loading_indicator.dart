import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;
  final bool isInButton;

  const LoadingIndicator({
    super.key,
    this.size = 24.0,
    this.color,
    this.isInButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget indicator = SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(
        strokeWidth: isInButton ? 2.0 : 4.0,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? (isInButton ? Colors.white : theme.colorScheme.primary),
        ),
      ),
    );

    if (isInButton) return indicator;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: indicator,
      ),
    );
  }
}
