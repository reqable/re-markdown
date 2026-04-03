part of re_markdown;

abstract class _SpanNode {

  _SpanNode? parent;

  void acceptParent(_SpanNode node) {
    parent = node;
  }

  InlineSpan? build(BuildContext context, StyleSheet styleSheet);

}

/// Parent node of all element nodes.
abstract class _ElementNode extends _SpanNode {

  final List<_SpanNode> children = [];

  void acceptChild(_SpanNode? node) {
    if (node != null) {
      children.add(node);
      node.acceptParent(this);
    }
  }

  @override
  InlineSpan? build(BuildContext context, StyleSheet styleSheet) {
    if (children.isEmpty) {
      return null;
    }
    if (children.length == 1) {
      return children.first.build(context, styleSheet);
    }
    final List<InlineSpan> spans = [];
    for (final _SpanNode child in children) {
      final InlineSpan? span = child.build(context, styleSheet);
      if (span == null) {
        continue;
      }
      spans.add(span);
    }
    if (spans.isEmpty) {
      return null;
    }
    return TextSpan(
      children: spans
    );
  }

}

/// The default concrete node for [_ElementNode].
class _ConcreteElementNode extends _ElementNode {

  _ConcreteElementNode();

}

/// The node for markdown text.
class _TextNode extends _SpanNode {

  final String text;

  _TextNode(this.text);

  @override
  InlineSpan? build(BuildContext context, StyleSheet styleSheet) {
    if (text.isEmpty) {
      return null;
    }
    return TextSpan(
      text: text,
    );
  }

}

enum _HeadingType {
  h1,
  h2,
  h3,
  h4,
  h5,
  h6,
}

/// Tag [MarkdownTag.h1]、[MarkdownTag.h2]、[MarkdownTag.h3]、[MarkdownTag.h4]、[MarkdownTag.h5]、[MarkdownTag.h6]
class _HeadingNode extends _ElementNode {

  final _HeadingType type;

  _HeadingNode(this.type);

  @override
  InlineSpan? build(BuildContext context, StyleSheet styleSheet) {
    final InlineSpan? childSpan = super.build(context, styleSheet);
    if (childSpan == null) {
      return null;
    }
    final TextStyle? headingStyle;
    final EdgeInsets? padding;
    switch (type) {
      case _HeadingType.h1:
        headingStyle = styleSheet.h1;
        padding = styleSheet.h1Padding;
        break;
      case _HeadingType.h2:
        headingStyle = styleSheet.h2;
        padding = styleSheet.h2Padding;
        break;
      case _HeadingType.h3:
        headingStyle = styleSheet.h3;
        padding = styleSheet.h3Padding;
        break;
      case _HeadingType.h4:
        headingStyle = styleSheet.h4;
        padding = styleSheet.h4Padding;
        break;
      case _HeadingType.h5:
        headingStyle = styleSheet.h5;
        padding = styleSheet.h5Padding;
        break;
      case _HeadingType.h6:
        headingStyle = styleSheet.h6;
        padding = styleSheet.h6Padding;
        break;
    }
    if (padding == null || padding == EdgeInsets.zero) {
      return TextSpan(
        style: headingStyle,
        children: [
          childSpan
        ]
      );
    }
    return WidgetSpan(
      child: Container(
        padding: padding,
        child: Text.rich(
          childSpan,
          style: headingStyle,
        ),
      )
    );
  }

}

/// Tag [MarkdownTag.li]
class _ListNode extends _ElementNode {

  int index = 0;
  int count = 0;

  @override
  InlineSpan? build(BuildContext context, StyleSheet styleSheet) {
    if (children.isEmpty) {
      return null;
    }
    final int depth = _depth;
    final _SpanNode firstChild = children.first;
    final TextPainter painter = TextPainter(
      text: TextSpan(
        text: '${count + 1}.',
        style: styleSheet.listBullet,
      ),
      textDirection: TextDirection.ltr,
    );
    painter.layout();
    final Widget bullet;
    final double? bulletWidth;
    if (firstChild is _InputNode) {
      bullet = const SizedBox.shrink();
      bulletWidth = null;
    } else {
      if (_isOrdered) {
        bullet = SelectionContainer.disabled(
          child: Text(
            '${index + 1}.',
            textAlign: TextAlign.right,
            style: styleSheet.listBullet,
          ),
        );
      } else {
        final BoxDecoration decoration;
        final Color? color = styleSheet.listBullet?.color;
        if (depth == 0) {
          decoration = BoxDecoration(
            shape: BoxShape.circle,
            color: color
          );
        } else if (depth == 1) {
          decoration = BoxDecoration(
            border: color == null ? null : Border.all(
              color: color
            ),
            shape: BoxShape.circle,
          );
        } else {
          decoration = BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          );
        }
        bullet = Container(
          width: 5,
          height: 5,
          decoration: decoration,
        );
      }
      bulletWidth = (styleSheet.listIndent ?? 0) + painter.width;
    }
    final List<InlineSpan> spans = [];
    for (final _SpanNode child in children) {
      if (child is _UlOrOLNode) {
        spans.add(const TextSpan(
          text: '\n'
        ));
      }
      final InlineSpan? span = child.build(context, styleSheet);
      if (span == null) {
        continue;
      }
      spans.add(span);
    }
    return WidgetSpan(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.centerRight,
            padding: styleSheet.listBulletPadding,
            width: bulletWidth,
            height: painter.height * 1.2,
            child: bullet,
          ),
          Flexible(
            child: Text.rich(
              TextSpan(
                style: styleSheet.listBullet,
                children: spans,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool get _isOrdered {
    final _SpanNode? p = parent;
    return p != null && p is _UlOrOLNode && p.tag == MarkdownTag.ol.name;
  }

  int get _depth {
    int d = 0;
    _SpanNode? p = parent;
    while (p != null) {
      p = p.parent;
      if (p != null && p is _UlOrOLNode && const {
        'ul',
        'ol',
      }.contains(p.tag)) d += 1;
    }
    return d;
  }

}

/// Tag [MarkdownTag.ol]、[MarkdownTag.ul]
class _UlOrOLNode extends _ElementNode {

  final String tag;
  late int start;

  _UlOrOLNode(this.tag, Map<String, String> attributes) {
    start = (int.tryParse(attributes['start'] ?? '') ?? 1) - 1;
  }

  @override
  void acceptChild(_SpanNode? node) {
    super.acceptChild(node);
    if (node != null && node is _ListNode) {
      node.index = start;
      start++;
    }
    for (final _SpanNode child in children) {
      if (child is _ListNode) {
        child.count = start;
      }
    }
  }

  @override
  InlineSpan? build(BuildContext context, StyleSheet styleSheet) {
    return WidgetSpan(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children
          .map((child) => child.build(context, styleSheet))
          .whereNotNull()
          .map((span) => Text.rich(span))
          .toList(),
      ),
    );
  }

}

/// Tag: [MarkdownTag.blockquote]
class _BlockquoteNode extends _ElementNode {

  @override
  InlineSpan? build(BuildContext context, StyleSheet styleSheet) {
    final InlineSpan? childSpan = super.build(context, styleSheet);
    if (childSpan == null) {
      return null;
    }
    final List<InlineSpan> spans = List.of((childSpan as TextSpan).children ?? []);
    int len = spans.length - 1;
    while(len > 0) {
      spans.insert(len, const TextSpan(
        text: '\n'
      ));
      len--;
    }
    return WidgetSpan(
      child: Container(
        width: double.infinity,
        decoration: styleSheet.blockquoteDecoration,
        padding: styleSheet.blockquotePadding,
        child: Text.rich(TextSpan(
          style: styleSheet.blockquote,
          children: spans,
        )),
      ),
    );
  }

}

/// Tag: [MarkdownTag.pre]
class _CodeBlockNode extends _ElementNode {

  final md.Element element;
  final CodeBlockWidgetBuilder builder;

  _CodeBlockNode(this.element, this.builder);

  @override
  InlineSpan? build(BuildContext context, StyleSheet styleSheet) {
    final String code = element.textContent;
    final String? language = element.children?.map((node) {
      if (node is md.Element) {
        final String? classAttr = node.attributes['class'];
        if (classAttr != null && classAttr.startsWith('language-')) {
          return classAttr.substring(9);
        }
        return classAttr;
      } else {
        return null;
      }
    }).whereNotNull().firstOrNull;
    final Widget codeWidget = builder.build(context, CodeBlockNodeData(
      code: code,
      language: language
    ), styleSheet);
    final double spacing = styleSheet.blockSpacing ?? 0;
    if (parent is _ConcreteElementNode || spacing <= 0) {
      return WidgetSpan(
        child: codeWidget,
      );
    } else {
      return WidgetSpan(
        child: Container(
          padding: EdgeInsets.only(
            top: spacing,
            bottom: spacing,
          ),
          child: codeWidget,
        )
      );
    }
  }

}

/// Tag: [MarkdownTag.hr]
class _HrNode extends _SpanNode {

  @override
  InlineSpan? build(BuildContext context, StyleSheet styleSheet) {
    return WidgetSpan(
      child: Container(
        decoration: styleSheet.horizontalRuleDecoration,
      ),
    );
  }

}

/// Tag: [MarkdownTag.table]
class _TableNode extends _ElementNode {

  @override
  InlineSpan? build(BuildContext context, StyleSheet styleSheet) {
    final List<TableRow> rows = [];
    int cellCount = 0;
    for (final _SpanNode child in children) {
      if (child is _THeadNode) {
        cellCount = child.cellCount;
        rows.addAll(child.buildRows(context, styleSheet));
      } else if (child is _TBodyNode) {
        rows.addAll(child.buildRows(context, cellCount, styleSheet));
      }
    }
    return WidgetSpan(
      child: Table(
        border: styleSheet.tableBorder,
        defaultColumnWidth: styleSheet.tableColumnWidth ?? const FlexColumnWidth(),
        defaultVerticalAlignment: styleSheet.tableVerticalAlignment,
        children: rows,
      ),
    );
  }

}

class _THeadNode extends _ElementNode {

  int get cellCount => (children.first as _TrNode).children.length;

  List<TableRow> buildRows(BuildContext context, StyleSheet styleSheet) {
    return children.map((child) {
      final _TrNode node = child as _TrNode;
      return TableRow(
        decoration: styleSheet.tableCellsDecoration,
        children: node.children.map((cell) {
          final InlineSpan? cellSpan = cell.build(context, styleSheet);
          return TableCell(
            verticalAlignment: styleSheet.tableVerticalAlignment,
            child: Container(
              padding: styleSheet.tableCellsPadding,
              child: Text.rich(
                cellSpan ?? const TextSpan(),
                style: styleSheet.tableHead,
              )
            ),
          );
        }).toList(),
      );
    }).toList();
  }

}

class _TBodyNode extends _ElementNode {

  List<TableRow> buildRows(BuildContext context, int cellCount, StyleSheet styleSheet) {
    return children.map((child) {
      final _TrNode node = child as _TrNode;
      final List<_SpanNode> cells = List.of(node.children);
      if (cells.length < cellCount) {
        cells.addAll(List.generate(cellCount - cells.length, (_) => _TextNode('')));
      } else {
        cells.removeRange(cellCount, cells.length);
      }
      return TableRow(
        decoration: styleSheet.tableCellsDecoration,
        children: cells.map((cell) {
          final InlineSpan? cellSpan = cell.build(context, styleSheet);
          return TableCell(
            verticalAlignment: styleSheet.tableVerticalAlignment,
            child: Container(
              padding: styleSheet.tableCellsPadding,
              child: Text.rich(
                cellSpan ?? const TextSpan(),
                style: styleSheet.tableBody,
              )
            ),
          );
        }).toList(),
      );
    }).toList();
  }

}

/// Tag: [MarkdownTag.tr]
class _TrNode extends _ElementNode {
}

/// Tag: [MarkdownTag.th]
class _ThNode extends _ElementNode {
}

/// Tag: [MarkdownTag.td]
class _TdNode extends _ElementNode {

  final Map<String, String> attributes;

  _TdNode(this.attributes);

  @override
  InlineSpan? build(BuildContext context, StyleSheet styleSheet) {
    final InlineSpan? childSpan = super.build(context, styleSheet);
    if (childSpan == null) {
      return null;
    }
    final String? align = attributes['align'];
    if (align == 'left') {
      return WidgetSpan(
        child: Container(
          alignment: Alignment.centerLeft,
          child: Text.rich(childSpan),
        ),
      );
    } else if (align == 'center') {
      return WidgetSpan(
        child: Container(
          alignment: Alignment.center,
          child: Text.rich(childSpan),
        ),
      );
    } else if (align == 'right') {
      return WidgetSpan(
        child: Container(
          alignment: Alignment.centerRight,
          child: Text.rich(childSpan),
        ),
      );
    } else {
      return childSpan;
    }
  }

}

/// Tag: [MarkdownTag.p]
class _ParagraphNode extends _StyleElementNode {

  @override
  InlineSpan? build(BuildContext context, StyleSheet styleSheet) {
    final InlineSpan? childSpan = super.build(context, styleSheet);
    if (childSpan == null) {
      return null;
    }
    final EdgeInsets? padding = styleSheet.pPadding;
    if (padding == null || padding == EdgeInsets.zero) {
      return childSpan;
    }
    return WidgetSpan(
      child: Padding(
        padding: padding,
        child: Text.rich(childSpan),
      ),
    );
  }

  @override
  TextStyle? getStyle(StyleSheet styleSheet) {
    return styleSheet.p;
  }

}

/// Tag: [MarkdownTag.input]
class _InputNode extends _SpanNode {

  final Map<String, String> attributes;

  _InputNode(this.attributes);

  @override
  InlineSpan? build(BuildContext context, StyleSheet styleSheet) {
    bool checked = attributes['checked']?.toLowerCase() == 'true';
    return WidgetSpan(
      child: Padding(
        padding: styleSheet.listBulletPadding ?? EdgeInsets.zero,
        child: Icon(
          checked ? Icons.check_box : Icons.check_box_outline_blank,
          size: styleSheet.checkbox?.fontSize,
          color: styleSheet.checkbox?.color,
        ),
      )
    );
  }

}

/// Tag: [MarkdownTag.a]
class _LinkNode extends _ElementNode {

  final Map<String, String> attributes;
  final LinkActionBuilder linkActionBuilder;

  _LinkNode(this.attributes, this.linkActionBuilder);

  @override
  InlineSpan? build(BuildContext context, StyleSheet styleSheet) {
    final InlineSpan? childSpan = super.build(context, styleSheet);
    if (childSpan == null) {
      return null;
    }
    final String? url = attributes['href'];
    if (url == null) {
      return childSpan;
    }
    final Uri? uri = Uri.tryParse(url);
    if (uri == null) {
      return childSpan;
    }
    return _wrapWithLink(context,childSpan, uri, styleSheet);
  }

  InlineSpan _wrapWithLink(BuildContext context, InlineSpan span, Uri uri, StyleSheet styleSheet) {
    if (span is TextSpan) {
      return TextSpan(
        text: span.text,
        children: span.children?.map((child) {
          return _wrapWithLink(context, child, uri, styleSheet);
        }).toList(),
        style: styleSheet.a,
        recognizer: TapGestureRecognizer()..onTap = () => linkActionBuilder.onTap(context, uri),
      );
    } else if (span is WidgetSpan) {
      return WidgetSpan(
        style: styleSheet.a,
        alignment: span.alignment,
        baseline: span.baseline,
        child: InkWell(
          onTap: () => linkActionBuilder.onTap(context, uri),
          child: span.child,
        ),
      );
    } else {
      return span;
    }
  }

}

abstract class _StyleElementNode extends _ElementNode {

  @override
  InlineSpan? build(BuildContext context, StyleSheet styleSheet) {
    final InlineSpan? childSpan = super.build(context, styleSheet);
    if (childSpan == null) {
      return null;
    }
    return TextSpan(
      style: getStyle(styleSheet),
      children: [
        childSpan
      ]
    );
  }

  TextStyle? getStyle(StyleSheet styleSheet);

}

/// Tag: [MarkdownTag.del]
class _DelNode extends _StyleElementNode {

  @override
  TextStyle? getStyle(StyleSheet styleSheet) {
    return styleSheet.del ?? const TextStyle(
      decoration: TextDecoration.lineThrough,
    );
  }

}

/// Tag: [MarkdownTag.strong]
class _StrongNode extends _StyleElementNode {

  @override
  TextStyle? getStyle(StyleSheet styleSheet) {
    return styleSheet.strong ?? const TextStyle(
      fontWeight: FontWeight.bold,
    );
  }

}

/// Tag: [MarkdownTag.em]
class _EmNode extends _StyleElementNode {

  @override
  TextStyle? getStyle(StyleSheet styleSheet) {
    return styleSheet.em ?? const TextStyle(
      fontStyle: FontStyle.italic,
    );
  }

}

/// Tag: [MarkdownTag.br]
class _BrNode extends _SpanNode {

  @override
  InlineSpan? build(BuildContext context, StyleSheet styleSheet) {
    return const TextSpan(
      text: '\n'
    );
  }

}

/// Tag:  [MarkdownTag.code]
class _CodeNode extends _ElementNode {

  final String text;

  _CodeNode(this.text);

  @override
  InlineSpan? build(BuildContext context, StyleSheet styleSheet) {
    if (text.isEmpty) {
      return null;
    }
    return WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: Container(
        padding: styleSheet.codePadding,
        decoration: styleSheet.codeDecoration,
        child: Text(
          text,
          style: styleSheet.code,
        ),
      )
    );
  }

}

/// Tag: [MarkdownTag.img]
class _ImageNode extends _SpanNode {

  final ImageWidgetBuilder builder;
  final Map<String, String> attributes;

  _ImageNode(this.attributes, this.builder);

  @override
  InlineSpan? build(BuildContext context, StyleSheet styleSheet) {
    final String? url = attributes['src'];
    if (url == null) {
      return null;
    }
    final Uri? uri = Uri.tryParse(url);
    if (uri == null) {
      return null;
    }
    double? width;
    double? height;
    final String? widthStr = attributes['width'];
    if (widthStr != null) {
      width = double.tryParse(widthStr);
      if (width != null && width <= 0) {
        width = null;
      }
    }
    final String? heightStr = attributes['height'];
    if (heightStr != null) {
      height = double.tryParse(heightStr);
      if (height != null && height <= 0) {
        height = null;
      }
    }
    final ImageNodeData data = ImageNodeData(
      uri: uri,
      width: width,
      height: height,
      title: attributes['title'],
      alt: attributes['alt'],
    );
    return WidgetSpan(
      child: builder.build(context, data, styleSheet)
    );
  }

}