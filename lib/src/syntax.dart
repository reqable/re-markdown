part of re_markdown;

/// A syntax for parsing HTML comments in markdown.
class CommentSyntax extends md.BlockSyntax {

  @override
  RegExp get pattern => RegExp(r'<!--[\s\S]*?-->');

  @override
  md.Node? parse(md.BlockParser parser) {
    parser.advance();
    return md.Element.text('comment', parser.current.content);
  }

}
