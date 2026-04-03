part of re_markdown;

typedef _SpanNodeGenerator = _SpanNode Function(md.Element e, _NodeVisitor visitor);

final Map<String, _SpanNodeGenerator> _kNodeGenerators = <String, _SpanNodeGenerator>{
  MarkdownTag.h1.name: (e, visitor) => _HeadingNode(_HeadingType.h1),
  MarkdownTag.h2.name: (e, visitor) => _HeadingNode(_HeadingType.h2),
  MarkdownTag.h3.name: (e, visitor) => _HeadingNode(_HeadingType.h3),
  MarkdownTag.h4.name: (e, visitor) => _HeadingNode(_HeadingType.h4),
  MarkdownTag.h5.name: (e, visitor) => _HeadingNode(_HeadingType.h5),
  MarkdownTag.h6.name: (e, visitor) => _HeadingNode(_HeadingType.h6),
  MarkdownTag.li.name: (e, visitor) => _ListNode(),
  MarkdownTag.ol.name: (e, visitor) => _UlOrOLNode(e.tag, e.attributes),
  MarkdownTag.ul.name: (e, visitor) => _UlOrOLNode(e.tag, e.attributes),
  MarkdownTag.blockquote.name: (e, visitor) => _BlockquoteNode(),
  MarkdownTag.pre.name: (e, visitor) => _CodeBlockNode(e, visitor.codeBlockWidgetBuilder),
  MarkdownTag.hr.name: (e, visitor) => _HrNode(),
  MarkdownTag.table.name: (e, visitor) => _TableNode(),
  MarkdownTag.thead.name: (e, visitor) => _THeadNode(),
  MarkdownTag.tbody.name: (e, visitor) => _TBodyNode(),
  MarkdownTag.tr.name: (e, visitor) => _TrNode(),
  MarkdownTag.th.name: (e, visitor) => _ThNode(),
  MarkdownTag.td.name: (e, visitor) => _TdNode(e.attributes),
  MarkdownTag.p.name: (e, visitor) => _ParagraphNode(),
  MarkdownTag.input.name: (e, visitor) => _InputNode(e.attributes),
  MarkdownTag.a.name: (e, visitor) => _LinkNode(e.attributes, visitor.linkActionBuilder),
  MarkdownTag.del.name: (e, visitor) => _DelNode(),
  MarkdownTag.strong.name: (e, visitor) => _StrongNode(),
  MarkdownTag.em.name: (e, visitor) => _EmNode(),
  MarkdownTag.br.name: (e, visitor) => _BrNode(),
  MarkdownTag.code.name: (e, visitor) => _CodeNode(e.textContent),
  MarkdownTag.img.name: (e, visitor) => _ImageNode(e.attributes, visitor.imageWidgetBuilder),
  MarkdownTag.comment.name: (e, visitor) => _CommentNode(e.textContent),
};

class _NodeVisitor implements md.NodeVisitor {

  _NodeVisitor({
    required this.imageWidgetBuilder,
    required this.codeBlockWidgetBuilder,
    required this.linkActionBuilder,
  });

  final ImageWidgetBuilder imageWidgetBuilder;
  final CodeBlockWidgetBuilder codeBlockWidgetBuilder;
  final LinkActionBuilder linkActionBuilder;

  final List<_SpanNode> _spansStack = [];

  List<_SpanNode> visit(List<md.Node> nodes) {
    final List<_SpanNode> spans = [];
    for (final md.Node node in nodes) {
      final _SpanNode emptyNode = _ConcreteElementNode();
      spans.add(emptyNode);
      _spansStack.add(emptyNode);
      node.accept(this);
      _spansStack.removeLast();
    }
    _spansStack.clear();
    return spans;
  }

  @override
  bool visitElementBefore(md.Element element) {
    final _SpanNodeGenerator? generator = _kNodeGenerators[element.tag];
    final _SpanNode node = generator?.call(element, this) ?? _TextNode(element.textContent);
    final _SpanNode last = _spansStack.last;
    if (last is _ElementNode) {
      last.acceptChild(node);
    }
    _spansStack.add(node);
    return true;
  }

  @override
  void visitElementAfter(md.Element element) {
    _spansStack.removeLast();
  }


  @override
  void visitText(md.Text text) {
    final _SpanNode last = _spansStack.last;
    if (last is _ElementNode) {
      last.acceptChild(_TextNode(text.text));
    }
  }

}