part of re_markdown;

/// A widget that parses and renders markdown data.
class Markdown extends StatefulWidget {

  const Markdown({
    Key? key,
    required this.data,
    this.styleSheet,
    this.blockSyntaxes,
    this.inlineSyntaxes,
    this.extensionSet,
    this.controller,
    this.shrinkWrap = false,
    this.padding,
    this.imageWidgetBuilder,
    this.codeBlockWidgetBuilder,
    this.linkActionBuilder,
  }) : super(key: key);

  /// Markdown data
  final String data;

  /// Style sheet of markdown.
  final StyleSheet? styleSheet;

  /// Collection of custom block syntax types to be used parsing the Markdown data.
  final List<md.BlockSyntax>? blockSyntaxes;

  /// Collection of custom inline syntax types to be used parsing the Markdown data.
  final List<md.InlineSyntax>? inlineSyntaxes;

  /// Markdown syntax extension set.
  ///
  /// Defaults to [md.ExtensionSet.gitHubFlavored]
  final md.ExtensionSet? extensionSet;

  /// Set the desired scroll controller for the markdown item list.
  final ScrollController? controller;

  /// Set shrinkWrap to obtained [ListView].
  final bool shrinkWrap;

  /// Content padding of the markdown document.
  final EdgeInsetsGeometry? padding;

  /// Call when build an image widget.
  /// If null, [DefaultImageWidgetBuilder] will be used.
  final ImageWidgetBuilder? imageWidgetBuilder;

  /// Call when build a code block widget.
  /// If null, [DefaultCodeBlockWidgetBuilder] will be used.
  final CodeBlockWidgetBuilder? codeBlockWidgetBuilder;

  /// Call when tap a link.
  /// If null, [DefaultLinkActionBuilder] will be used.
  final LinkActionBuilder? linkActionBuilder;

  @override
  State<Markdown> createState() => _MarkdownState();

}

class _MarkdownState extends State<Markdown> {

  late md.Document _document;
  final List<_SpanNode> _spans = [];

  @override
  void initState() {
    super.initState();
    _initDocument();
    _updateState();
  }

  @override
  void didUpdateWidget(covariant Markdown oldWidget) {
    bool documentChanged = false;
    if (!listEquals(oldWidget.blockSyntaxes, widget.blockSyntaxes) ||
        !listEquals(oldWidget.inlineSyntaxes, widget.inlineSyntaxes) ||
        oldWidget.extensionSet != widget.extensionSet) {
      _initDocument();
      documentChanged = true;
    }
    if (documentChanged || oldWidget.data != widget.data ||
        oldWidget.styleSheet != widget.styleSheet ||
        oldWidget.imageWidgetBuilder != widget.imageWidgetBuilder ||
        oldWidget.codeBlockWidgetBuilder != widget.codeBlockWidgetBuilder ||
        oldWidget.linkActionBuilder != widget.linkActionBuilder
    ) {
      _updateState();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final StyleSheet styleSheet = widget.styleSheet ?? StyleSheet.fromTheme(Theme.of(context));
    return ListView.separated(
      shrinkWrap: widget.shrinkWrap,
      controller: widget.controller,
      itemBuilder: (context, index) {
        final _SpanNode node = _spans[index];
        final InlineSpan? span = node.build(context, styleSheet);
        if (span == null) {
          return const SizedBox.shrink();
        }
        return Text.rich(span);
      },
      separatorBuilder: (context, index) {
        final _SpanNode node = _spans[index];
        if (node is _ElementNode) {
          final double spacing = styleSheet.blockSpacing ?? 0;
          if (spacing > 0) {
            return SizedBox(height: spacing);
          }
        }
        return const SizedBox.shrink();
      },
      itemCount: _spans.length,
      padding: widget.padding,
    );
  }

  void _initDocument() {
    _document = md.Document(
      encodeHtml: false,
      extensionSet: widget.extensionSet ?? md.ExtensionSet.gitHubFlavored,
      blockSyntaxes: widget.blockSyntaxes,
      inlineSyntaxes: widget.inlineSyntaxes,
    );
  }

  void _updateState() {
    final List<md.Node> nodes;
    try {
      nodes = _document.parse(widget.data);
    } catch (e) {
      // If parse failed, we skip update state.
      return;
    }
    final _NodeVisitor visitor = _NodeVisitor(
      imageWidgetBuilder: widget.imageWidgetBuilder ?? const DefaultImageWidgetBuilder(),
      codeBlockWidgetBuilder: widget.codeBlockWidgetBuilder ?? DefaultCodeBlockWidgetBuilder(),
      linkActionBuilder: widget.linkActionBuilder ?? const DefaultLinkActionBuilder(),
    );
    visitor.visit(nodes);
    setState(() {
      _spans.clear();
      _spans.addAll(visitor.visit(nodes));
    });
  }

}