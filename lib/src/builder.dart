part of re_markdown;

/// Data of image node.
class ImageNodeData {

  const ImageNodeData({
    required this.uri,
    this.width,
    this.height,
    this.title,
    this.alt,
  });

  /// The URI of the image, which can be a network URL, data URI, resource URI, or file URI.
  final Uri uri;

  /// The width of the image, which can be null to use the intrinsic width of the image.
  final double? width;

  /// The height of the image, which can be null to use the intrinsic height of the image.
  final double? height;

  /// The title of the image, which can be used as a tooltip or for accessibility purposes.
  final String? title;

  /// The alt text of the image, which can be used for accessibility purposes or as a
  /// fallback when the image fails to load.
  final String? alt;

}

/// Builder of markdown image widget.
abstract class ImageWidgetBuilder {

  /// Build a markdown image widget.
  Widget build(BuildContext context, ImageNodeData data, StyleSheet styleSheet);

  /// Handle tap event of markdown image widget.
  void onTap(BuildContext context, ImageNodeData data);

}

/// Signature used by [Image.errorBuilder] to create a replacement widget to
/// render instead of the image.
abstract class ImageErrorWidgetBuilder {

  /// Creates a widget to display when an image fails to load.
  ///
  /// The arguments [error] and [stackTrace] will be non-null when the image
  /// fails to load.
  ///
  /// The argument [context] is the build context of the widget
  /// that failed to load the image.
  ///
  /// The argument [data] contains the information of the image that failed to load,
  /// such as the URI, alt text, title, width, and height.
  ///
  /// The argument [styleSheet] contains the style information for the image,
  /// such as the color and font size defined in the markdown style sheet.
  Widget build(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
    ImageNodeData data,
    StyleSheet styleSheet,
  );

}

/// Default implementation of [ImageWidgetBuilder] that supports loading images
/// from network, data URI, resource, and file.
///
/// Using [DefaultImageErrorWidgetBuilder] as the default error builder to display
/// a broken image icon and alt text when the image fails to load.
class DefaultImageWidgetBuilder implements ImageWidgetBuilder {

  const DefaultImageWidgetBuilder({
    this.errorBuilder = const DefaultImageErrorWidgetBuilder(),
  });

  /// The error builder to create a replacement widget when the image fails to load.
  final ImageErrorWidgetBuilder errorBuilder;

  @override
  Widget build(BuildContext context, ImageNodeData data, StyleSheet styleSheet) {
    final Uri uri = data.uri;
    final double? width = data.width;
    final double? height = data.height;
    Widget buildErrorWidget(
      BuildContext context,
      Object error,
      StackTrace? stackTrace,
    ) {
      return errorBuilder.build(context, error, stackTrace, data, styleSheet);
    }
    if (uri.scheme == 'http' || uri.scheme == 'https') {
      return Image.network(
        uri.toString(),
        width: width,
        height: height,
        errorBuilder: buildErrorWidget,
      );
    } else if (uri.scheme == 'data') {
      final UriData? uriData = uri.data;
      if (uriData == null) {
        return const SizedBox.shrink();
      }
      final String mimeType = uriData.mimeType;
      if (mimeType.startsWith('image/')) {
        return Image.memory(
          uriData.contentAsBytes(),
          width: width,
          height: height,
          errorBuilder: buildErrorWidget,
        );
      } else if (mimeType.startsWith('text/')) {
        return Text(uriData.contentAsString());
      }
      return const SizedBox.shrink();
    } else if (uri.scheme == 'resource') {
      return Image.asset(
        '${uri.host}/${uri.path}',
        width: width,
        height: height,
        errorBuilder: buildErrorWidget,
      );
    } else {
      return Image.file(
        File.fromUri(uri),
        width: width,
        height: height,
        errorBuilder: buildErrorWidget,
      );
    }
  }

  @protected
  @override
  void onTap(BuildContext context, ImageNodeData data) {
    // Implement your own tap handling logic here, such as opening the image in a full-screen viewer
    // or showing a dialog with image details.
  }

}

/// Default implementation of [ImageErrorWidgetBuilder] that displays a broken image icon and alt text
/// when the image fails to load.
class DefaultImageErrorWidgetBuilder implements ImageErrorWidgetBuilder {

  const DefaultImageErrorWidgetBuilder();

  @override
  Widget build(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
    ImageNodeData data,
    StyleSheet styleSheet
  ) {
    final Widget brokenImage = Icon(
      Icons.broken_image,
      color: styleSheet.img?.color,
      size: styleSheet.img?.fontSize,
    );
    final String? alt = data.alt;
    if (alt == null || alt.isEmpty) {
      return brokenImage;
    }
    return Row(
      children: [
        brokenImage,
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            alt,
            style: styleSheet.img,
          ),
        )
      ],
    );
  }

}

/// Data of code block node.
class CodeBlockNodeData {

  const CodeBlockNodeData({
    required this.code,
    this.language,
  });

  /// The code content of the code block.
  final String code;

  /// The language of the code block, which can be used for syntax highlighting.
  final String? language;

}

/// Builder of markdown code block widget.
abstract class CodeBlockWidgetBuilder {

  /// Build a markdown code block widget.
  Widget build(BuildContext context, CodeBlockNodeData data, StyleSheet styleSheet);

}

/// Default implementation of [CodeBlockWidgetBuilder] that supports syntax highlighting
/// using the `re_highlight` package.
class DefaultCodeBlockWidgetBuilder implements CodeBlockWidgetBuilder {

  DefaultCodeBlockWidgetBuilder({
    this.wordWrap = true,
    this.theme = a11YDarkTheme,
    /// The syntax highlighting languages to register in the `re_highlight` package.
    /// If null, all built-in languages will be registered.
    Map<String, Mode>? languages,
  }) {
    _highlight = Highlight();
    _highlight.registerLanguages(languages ?? builtinAllLanguages);
  }

  /// Whether to enable word wrap for code blocks.
  /// If false, a horizontal scroll view will be used to display the code block.
  final bool wordWrap;

  /// The syntax highlighting theme to use for code blocks.
  /// The keys of the theme map are the scope names defined in the `re_highlight` package.
  /// The default theme is `a11YDarkTheme`, which provides good contrast and readability for code blocks.
  final Map<String, TextStyle> theme;

  late final Highlight _highlight;

  @override
  Widget build(BuildContext context, CodeBlockNodeData data, StyleSheet styleSheet) {
    final String? language = data.language;
    // Remove the last newline if exists to avoid an extra empty line at the end of code block.
    final String code = data.code.endsWith('\n') ?
      data.code.substring(0, data.code.length - 1) : data.code;
    final HighlightResult result;
    if (language != null) {
      result = _highlight.highlightAuto(code, [
        language,
      ]);
    } else {
      result = _highlight.justTextHighlightResult(code);
    }
    final TextSpanRenderer renderer = TextSpanRenderer(styleSheet.code, theme);
    result.render(renderer);
    final TextSpan? span = renderer.span;
    final Widget codeWidget;
    if (span == null) {
      codeWidget = Text(
        code,
        style: styleSheet.code
      );
    } else {
      codeWidget = Text.rich(
        span
      );
    }
    if (wordWrap) {
      return Container(
        width: double.infinity,
        decoration: styleSheet.codeblockDecoration,
        padding: styleSheet.codeblockPadding,
        child: codeWidget,
      );
    } else {
      return Container(
        width: double.infinity,
        decoration: styleSheet.codeblockDecoration,
        child: SingleChildScrollView(
          padding: styleSheet.codeblockPadding,
          scrollDirection: Axis.horizontal,
          child: codeWidget,
        ),
      );
    }
  }

}

/// Builder of markdown link action, which is triggered when a link is tapped.
abstract class LinkActionBuilder {

  /// Handle tap event of markdown link widget.
  void onTap(BuildContext context, Uri uri);

}

/// Default implementation of [LinkActionBuilder] that uses the `url_launcher`
/// package to open the link.
class DefaultLinkActionBuilder implements LinkActionBuilder {

  const DefaultLinkActionBuilder();

  @override
  void onTap(BuildContext context, Uri uri) {
    launchUrl(uri);
  }

}