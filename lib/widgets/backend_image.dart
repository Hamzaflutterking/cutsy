import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BackendImage extends StatelessWidget {
  final String? url;

  /// Size
  final double? width;
  final double? height;

  /// Shape & corners
  final BoxShape shape;
  final BorderRadius? borderRadius; // ignored when shape == BoxShape.circle

  /// Styling
  final BoxFit fit;
  final Color? backgroundColor;
  final BoxBorder? border;

  /// Custom placeholders/fallbacks (optional)
  final Widget? placeholder;
  final Widget? error;

  /// Effects
  final Duration fadeInDuration;
  final Duration fadeOutDuration;

  const BackendImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.shape = BoxShape.rectangle,
    this.borderRadius,
    this.fit = BoxFit.cover,
    this.backgroundColor,
    this.border,
    this.placeholder,
    this.error,
    this.fadeInDuration = const Duration(milliseconds: 200),
    this.fadeOutDuration = const Duration(milliseconds: 150),
  });

  /// Handy circle constructor
  factory BackendImage.circle({
    Key? key,
    required String? url,
    double size = 48,
    BoxFit fit = BoxFit.cover,
    Color? backgroundColor,
    BoxBorder? border,
    Widget? placeholder,
    Widget? error,
    Duration fadeInDuration = const Duration(milliseconds: 200),
    Duration fadeOutDuration = const Duration(milliseconds: 150),
  }) {
    return BackendImage(
      key: key,
      url: url,
      width: size,
      height: size,
      shape: BoxShape.circle,
      fit: fit,
      backgroundColor: backgroundColor,
      border: border,
      placeholder: placeholder,
      error: error,
      fadeInDuration: fadeInDuration,
      fadeOutDuration: fadeOutDuration,
    );
  }

  @override
  Widget build(BuildContext context) {
    final placeholderWidget = placeholder ?? _DefaultPlaceholder(shape: shape);
    final errorWidget = error ?? _DefaultError(shape: shape);

    // Empty/invalid URL → show error immediately
    if (url == null || url!.trim().isEmpty) {
      return _frame(errorWidget);
    }

    return CachedNetworkImage(
      imageUrl: url!,
      imageBuilder: (context, imageProvider) => _frame(
        DecoratedBox(
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: shape,
            borderRadius: shape == BoxShape.rectangle ? borderRadius : null,
            border: border,
            image: DecorationImage(image: imageProvider, fit: fit),
          ),
        ),
      ),
      placeholder: (_, __) => _frame(placeholderWidget),
      errorWidget: (_, __, ___) => _frame(errorWidget),
      fadeInDuration: fadeInDuration,
      fadeOutDuration: fadeOutDuration,
    );
  }

  Widget _frame(Widget child) {
    final clipped = shape == BoxShape.circle
        ? ClipOval(child: child)
        : ClipRRect(borderRadius: borderRadius ?? BorderRadius.circular(12), child: child);

    return SizedBox(width: width, height: height, child: clipped);
  }
}

class _DefaultPlaceholder extends StatelessWidget {
  final BoxShape shape;
  const _DefaultPlaceholder({required this.shape});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        shape: shape,
        borderRadius: shape == BoxShape.rectangle ? BorderRadius.circular(12) : null,
      ),
      child: const Center(child: CupertinoActivityIndicator()),
    );
  }
}

class _DefaultError extends StatelessWidget {
  final BoxShape shape;
  const _DefaultError({required this.shape});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: Colors.black87, shape: shape, borderRadius: shape == BoxShape.rectangle ? BorderRadius.circular(12) : null),
      child: const Center(child: Icon(Icons.image_not_supported_outlined, color: Colors.white38, size: 22)),
    );
  }
}
