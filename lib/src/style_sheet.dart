part of re_markdown;

/// Defines the styles to use for different Markdown elements.
class StyleSheet {

  StyleSheet({
    this.a,
    this.p,
    this.pPadding,
    this.code,
    this.h1,
    this.h1Padding,
    this.h2,
    this.h2Padding,
    this.h3,
    this.h3Padding,
    this.h4,
    this.h4Padding,
    this.h5,
    this.h5Padding,
    this.h6,
    this.h6Padding,
    this.em,
    this.strong,
    this.del,
    this.blockquote,
    this.img,
    this.checkbox,
    this.blockSpacing,
    this.listIndent,
    this.listBullet,
    this.listBulletPadding,
    this.tableHead,
    this.tableBody,
    this.tableHeadAlign,
    this.tableBorder,
    this.tableColumnWidth,
    this.tableCellsPadding,
    this.tableCellsDecoration,
    this.tableVerticalAlignment = TableCellVerticalAlignment.middle,
    this.blockquotePadding,
    this.blockquoteDecoration,
    this.codeblockPadding,
    this.codeblockDecoration,
    this.codePadding,
    this.codeDecoration,
    this.horizontalRuleDecoration,
    this.textAlign = WrapAlignment.start,
    this.h1Align = WrapAlignment.start,
    this.h2Align = WrapAlignment.start,
    this.h3Align = WrapAlignment.start,
    this.h4Align = WrapAlignment.start,
    this.h5Align = WrapAlignment.start,
    this.h6Align = WrapAlignment.start,
    this.unorderedListAlign = WrapAlignment.start,
    this.orderedListAlign = WrapAlignment.start,
    this.blockquoteAlign = WrapAlignment.start,
    this.codeblockAlign = WrapAlignment.start,
  });

  factory StyleSheet.fromTheme(ThemeData theme) {
    assert(theme.textTheme.bodyMedium?.fontSize != null);
    return StyleSheet(
      a: const TextStyle(color: Colors.blue),
      p: theme.textTheme.bodyMedium,
      pPadding: EdgeInsets.zero,
      code: theme.textTheme.bodyMedium!.copyWith(
        backgroundColor: theme.cardTheme.color ?? theme.cardColor,
        fontFamily: 'monospace',
        fontSize: theme.textTheme.bodyMedium!.fontSize! * 0.85,
      ),
      h1: theme.textTheme.headlineSmall,
      h1Padding: EdgeInsets.zero,
      h2: theme.textTheme.titleLarge,
      h2Padding: EdgeInsets.zero,
      h3: theme.textTheme.titleMedium,
      h3Padding: EdgeInsets.zero,
      h4: theme.textTheme.bodyLarge,
      h4Padding: EdgeInsets.zero,
      h5: theme.textTheme.bodyLarge,
      h5Padding: EdgeInsets.zero,
      h6: theme.textTheme.bodyLarge,
      h6Padding: EdgeInsets.zero,
      em: const TextStyle(fontStyle: FontStyle.italic),
      strong: const TextStyle(fontWeight: FontWeight.bold),
      del: const TextStyle(decoration: TextDecoration.lineThrough),
      blockquote: theme.textTheme.bodyMedium,
      img: theme.textTheme.bodyMedium,
      checkbox: theme.textTheme.bodyMedium!.copyWith(
        color: theme.primaryColor,
      ),
      blockSpacing: 8.0,
      listIndent: 24.0,
      listBullet: theme.textTheme.bodyMedium,
      listBulletPadding: const EdgeInsets.only(right: 4),
      tableHead: const TextStyle(fontWeight: FontWeight.w600),
      tableBody: theme.textTheme.bodyMedium,
      tableHeadAlign: TextAlign.center,
      tableBorder: TableBorder.all(
        color: theme.dividerColor,
      ),
      tableColumnWidth: const FlexColumnWidth(),
      tableCellsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      tableCellsDecoration: const BoxDecoration(),
      blockquotePadding: const EdgeInsets.all(8.0),
      blockquoteDecoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(2.0),
      ),
      codeblockPadding: const EdgeInsets.all(8.0),
      codeblockDecoration: BoxDecoration(
        color: theme.cardTheme.color ?? theme.cardColor,
        borderRadius: BorderRadius.circular(2.0),
      ),
      codePadding: EdgeInsets.zero,
      codeDecoration: BoxDecoration(
        color: theme.cardTheme.color ?? theme.cardColor,
        borderRadius: BorderRadius.circular(2.0),
      ),
      horizontalRuleDecoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 5.0,
            color: theme.dividerColor,
          ),
        ),
      ),
    );
  }

  /// Creates a [StyleSheet] based on the current style, with the
  /// provided parameters overridden.
  StyleSheet copyWith({
    TextStyle? a,
    TextStyle? p,
    EdgeInsets? pPadding,
    TextStyle? code,
    TextStyle? h1,
    EdgeInsets? h1Padding,
    TextStyle? h2,
    EdgeInsets? h2Padding,
    TextStyle? h3,
    EdgeInsets? h3Padding,
    TextStyle? h4,
    EdgeInsets? h4Padding,
    TextStyle? h5,
    EdgeInsets? h5Padding,
    TextStyle? h6,
    EdgeInsets? h6Padding,
    TextStyle? em,
    TextStyle? strong,
    TextStyle? del,
    TextStyle? blockquote,
    TextStyle? img,
    TextStyle? checkbox,
    double? blockSpacing,
    double? listIndent,
    TextStyle? listBullet,
    EdgeInsets? listBulletPadding,
    TextStyle? tableHead,
    TextStyle? tableBody,
    TextAlign? tableHeadAlign,
    TableBorder? tableBorder,
    TableColumnWidth? tableColumnWidth,
    EdgeInsets? tableCellsPadding,
    Decoration? tableCellsDecoration,
    TableCellVerticalAlignment? tableVerticalAlignment,
    EdgeInsets? blockquotePadding,
    Decoration? blockquoteDecoration,
    EdgeInsets? codeblockPadding,
    Decoration? codeblockDecoration,
    EdgeInsets? codePadding,
    Decoration? codeDecoration,
    Decoration? horizontalRuleDecoration,
    WrapAlignment? textAlign,
    WrapAlignment? h1Align,
    WrapAlignment? h2Align,
    WrapAlignment? h3Align,
    WrapAlignment? h4Align,
    WrapAlignment? h5Align,
    WrapAlignment? h6Align,
    WrapAlignment? unorderedListAlign,
    WrapAlignment? orderedListAlign,
    WrapAlignment? blockquoteAlign,
    WrapAlignment? codeblockAlign,
  }) {
    return StyleSheet(
      a: a ?? this.a,
      p: p ?? this.p,
      pPadding: pPadding ?? this.pPadding,
      code: code ?? this.code,
      h1: h1 ?? this.h1,
      h1Padding: h1Padding ?? this.h1Padding,
      h2: h2 ?? this.h2,
      h2Padding: h2Padding ?? this.h2Padding,
      h3: h3 ?? this.h3,
      h3Padding: h3Padding ?? this.h3Padding,
      h4: h4 ?? this.h4,
      h4Padding: h4Padding ?? this.h4Padding,
      h5: h5 ?? this.h5,
      h5Padding: h5Padding ?? this.h5Padding,
      h6: h6 ?? this.h6,
      h6Padding: h6Padding ?? this.h6Padding,
      em: em ?? this.em,
      strong: strong ?? this.strong,
      del: del ?? this.del,
      blockquote: blockquote ?? this.blockquote,
      img: img ?? this.img,
      checkbox: checkbox ?? this.checkbox,
      blockSpacing: blockSpacing ?? this.blockSpacing,
      listIndent: listIndent ?? this.listIndent,
      listBullet: listBullet ?? this.listBullet,
      listBulletPadding: listBulletPadding ?? this.listBulletPadding,
      tableHead: tableHead ?? this.tableHead,
      tableBody: tableBody ?? this.tableBody,
      tableHeadAlign: tableHeadAlign ?? this.tableHeadAlign,
      tableBorder: tableBorder ?? this.tableBorder,
      tableColumnWidth: tableColumnWidth ?? this.tableColumnWidth,
      tableCellsPadding: tableCellsPadding ?? this.tableCellsPadding,
      tableCellsDecoration: tableCellsDecoration ?? this.tableCellsDecoration,
      tableVerticalAlignment:
          tableVerticalAlignment ?? this.tableVerticalAlignment,
      blockquotePadding: blockquotePadding ?? this.blockquotePadding,
      blockquoteDecoration: blockquoteDecoration ?? this.blockquoteDecoration,
      codeblockPadding: codeblockPadding ?? this.codeblockPadding,
      codeblockDecoration: codeblockDecoration ?? this.codeblockDecoration,
      codePadding: codePadding ?? this.codePadding,
      codeDecoration: codeDecoration ?? this.codeDecoration,
      horizontalRuleDecoration:
          horizontalRuleDecoration ?? this.horizontalRuleDecoration,
      textAlign: textAlign ?? this.textAlign,
      h1Align: h1Align ?? this.h1Align,
      h2Align: h2Align ?? this.h2Align,
      h3Align: h3Align ?? this.h3Align,
      h4Align: h4Align ?? this.h4Align,
      h5Align: h5Align ?? this.h5Align,
      h6Align: h6Align ?? this.h6Align,
      unorderedListAlign: unorderedListAlign ?? this.unorderedListAlign,
      orderedListAlign: orderedListAlign ?? this.orderedListAlign,
      blockquoteAlign: blockquoteAlign ?? this.blockquoteAlign,
      codeblockAlign: codeblockAlign ?? this.codeblockAlign,
    );
  }

  StyleSheet merge(StyleSheet? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      a: a!.merge(other.a),
      p: p!.merge(other.p),
      pPadding: other.pPadding,
      code: code!.merge(other.code),
      h1: h1!.merge(other.h1),
      h1Padding: other.h1Padding,
      h2: h2!.merge(other.h2),
      h2Padding: other.h2Padding,
      h3: h3!.merge(other.h3),
      h3Padding: other.h3Padding,
      h4: h4!.merge(other.h4),
      h4Padding: other.h4Padding,
      h5: h5!.merge(other.h5),
      h5Padding: other.h5Padding,
      h6: h6!.merge(other.h6),
      h6Padding: other.h6Padding,
      em: em!.merge(other.em),
      strong: strong!.merge(other.strong),
      del: del!.merge(other.del),
      blockquote: blockquote!.merge(other.blockquote),
      img: img!.merge(other.img),
      checkbox: checkbox!.merge(other.checkbox),
      blockSpacing: other.blockSpacing,
      listIndent: other.listIndent,
      listBullet: listBullet!.merge(other.listBullet),
      listBulletPadding: other.listBulletPadding,
      tableHead: tableHead!.merge(other.tableHead),
      tableBody: tableBody!.merge(other.tableBody),
      tableHeadAlign: other.tableHeadAlign,
      tableBorder: other.tableBorder,
      tableColumnWidth: other.tableColumnWidth,
      tableCellsPadding: other.tableCellsPadding,
      tableCellsDecoration: other.tableCellsDecoration,
      tableVerticalAlignment: other.tableVerticalAlignment,
      blockquotePadding: other.blockquotePadding,
      blockquoteDecoration: other.blockquoteDecoration,
      codeblockPadding: other.codeblockPadding,
      codeblockDecoration: other.codeblockDecoration,
      codePadding: other.codePadding,
      codeDecoration: other.codeDecoration,
      horizontalRuleDecoration: other.horizontalRuleDecoration,
      textAlign: other.textAlign,
      h1Align: other.h1Align,
      h2Align: other.h2Align,
      h3Align: other.h3Align,
      h4Align: other.h4Align,
      h5Align: other.h5Align,
      h6Align: other.h6Align,
      unorderedListAlign: other.unorderedListAlign,
      orderedListAlign: other.orderedListAlign,
      blockquoteAlign: other.blockquoteAlign,
      codeblockAlign: other.codeblockAlign,
    );
  }

  /// The [TextStyle] to use for `a` elements.
  final TextStyle? a;

  /// The [TextStyle] to use for `p` elements.
  final TextStyle? p;

  /// The padding to use for `p` elements.
  final EdgeInsets? pPadding;

  /// The [TextStyle] to use for `code` elements.
  final TextStyle? code;

  /// The [TextStyle] to use for `h1` elements.
  final TextStyle? h1;

  /// The padding to use for `h1` elements.
  final EdgeInsets? h1Padding;

  /// The [TextStyle] to use for `h2` elements.
  final TextStyle? h2;

  /// The padding to use for `h2` elements.
  final EdgeInsets? h2Padding;

  /// The [TextStyle] to use for `h3` elements.
  final TextStyle? h3;

  /// The padding to use for `h3` elements.
  final EdgeInsets? h3Padding;

  /// The [TextStyle] to use for `h4` elements.
  final TextStyle? h4;

  /// The padding to use for `h4` elements.
  final EdgeInsets? h4Padding;

  /// The [TextStyle] to use for `h5` elements.
  final TextStyle? h5;

  /// The padding to use for `h5` elements.
  final EdgeInsets? h5Padding;

  /// The [TextStyle] to use for `h6` elements.
  final TextStyle? h6;

  /// The padding to use for `h6` elements.
  final EdgeInsets? h6Padding;

  /// The [TextStyle] to use for `em` elements.
  final TextStyle? em;

  /// The [TextStyle] to use for `strong` elements.
  final TextStyle? strong;

  /// The [TextStyle] to use for `del` elements.
  final TextStyle? del;

  /// The [TextStyle] to use for `blockquote` elements.
  final TextStyle? blockquote;

  /// The [TextStyle] to use for `img` elements.
  final TextStyle? img;

  /// The [TextStyle] to use for `input` elements.
  final TextStyle? checkbox;

  /// The amount of vertical space to use between block-level elements.
  final double? blockSpacing;

  /// The amount of horizontal space to indent list items.
  final double? listIndent;

  /// The [TextStyle] to use for bullets.
  final TextStyle? listBullet;

  /// The padding to use for bullets.
  final EdgeInsets? listBulletPadding;

  /// The [TextStyle] to use for `th` elements.
  final TextStyle? tableHead;

  /// The [TextStyle] to use for `td` elements.
  final TextStyle? tableBody;

  /// The [TextAlign] to use for `th` elements.
  final TextAlign? tableHeadAlign;

  /// The [TableBorder] to use for `table` elements.
  final TableBorder? tableBorder;

  /// The [TableColumnWidth] to use for `th` and `td` elements.
  final TableColumnWidth? tableColumnWidth;

  /// The padding to use for `th` and `td` elements.
  final EdgeInsets? tableCellsPadding;

  /// The decoration to use for `th` and `td` elements.
  final Decoration? tableCellsDecoration;

  /// The [TableCellVerticalAlignment] to use for `th` and `td` elements.
  final TableCellVerticalAlignment tableVerticalAlignment;

  /// The padding to use for `blockquote` elements.
  final EdgeInsets? blockquotePadding;

  /// The decoration to use behind `blockquote` elements.
  final Decoration? blockquoteDecoration;

  /// The padding to use for `pre` elements.
  final EdgeInsets? codeblockPadding;

  /// The decoration to use behind for `pre` elements.
  final Decoration? codeblockDecoration;

  /// The padding to use for `code` elements.
  final EdgeInsets? codePadding;

  /// The decoration to use behind for `code` elements.
  final Decoration? codeDecoration;

  /// The decoration to use for `hr` elements.
  final Decoration? horizontalRuleDecoration;

  /// The [WrapAlignment] to use for normal text. Defaults to start.
  final WrapAlignment textAlign;

  /// The [WrapAlignment] to use for h1 text. Defaults to start.
  final WrapAlignment h1Align;

  /// The [WrapAlignment] to use for h2 text. Defaults to start.
  final WrapAlignment h2Align;

  /// The [WrapAlignment] to use for h3 text. Defaults to start.
  final WrapAlignment h3Align;

  /// The [WrapAlignment] to use for h4 text. Defaults to start.
  final WrapAlignment h4Align;

  /// The [WrapAlignment] to use for h5 text. Defaults to start.
  final WrapAlignment h5Align;

  /// The [WrapAlignment] to use for h6 text. Defaults to start.
  final WrapAlignment h6Align;

  /// The [WrapAlignment] to use for an unordered list. Defaults to start.
  final WrapAlignment unorderedListAlign;

  /// The [WrapAlignment] to use for an ordered list. Defaults to start.
  final WrapAlignment orderedListAlign;

  /// The [WrapAlignment] to use for a blockquote. Defaults to start.
  final WrapAlignment blockquoteAlign;

  /// The [WrapAlignment] to use for a code block. Defaults to start.
  final WrapAlignment codeblockAlign;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != StyleSheet) {
      return false;
    }
    return other is StyleSheet &&
        other.a == a &&
        other.p == p &&
        other.pPadding == pPadding &&
        other.code == code &&
        other.h1 == h1 &&
        other.h1Padding == h1Padding &&
        other.h2 == h2 &&
        other.h2Padding == h2Padding &&
        other.h3 == h3 &&
        other.h3Padding == h3Padding &&
        other.h4 == h4 &&
        other.h4Padding == h4Padding &&
        other.h5 == h5 &&
        other.h5Padding == h5Padding &&
        other.h6 == h6 &&
        other.h6Padding == h6Padding &&
        other.em == em &&
        other.strong == strong &&
        other.del == del &&
        other.blockquote == blockquote &&
        other.img == img &&
        other.checkbox == checkbox &&
        other.blockSpacing == blockSpacing &&
        other.listIndent == listIndent &&
        other.listBullet == listBullet &&
        other.listBulletPadding == listBulletPadding &&
        other.tableHead == tableHead &&
        other.tableBody == tableBody &&
        other.tableHeadAlign == tableHeadAlign &&
        other.tableBorder == tableBorder &&
        other.tableColumnWidth == tableColumnWidth &&
        other.tableCellsPadding == tableCellsPadding &&
        other.tableCellsDecoration == tableCellsDecoration &&
        other.tableVerticalAlignment == tableVerticalAlignment &&
        other.blockquotePadding == blockquotePadding &&
        other.blockquoteDecoration == blockquoteDecoration &&
        other.codeblockPadding == codeblockPadding &&
        other.codeblockDecoration == codeblockDecoration &&
        other.codePadding == codePadding &&
        other.codeDecoration == codeDecoration &&
        other.horizontalRuleDecoration == horizontalRuleDecoration &&
        other.textAlign == textAlign &&
        other.h1Align == h1Align &&
        other.h2Align == h2Align &&
        other.h3Align == h3Align &&
        other.h4Align == h4Align &&
        other.h5Align == h5Align &&
        other.h6Align == h6Align &&
        other.unorderedListAlign == unorderedListAlign &&
        other.orderedListAlign == orderedListAlign &&
        other.blockquoteAlign == blockquoteAlign &&
        other.codeblockAlign == codeblockAlign;
  }

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      a,
      p,
      pPadding,
      code,
      h1,
      h1Padding,
      h2,
      h2Padding,
      h3,
      h3Padding,
      h4,
      h4Padding,
      h5,
      h5Padding,
      h6,
      h6Padding,
      em,
      strong,
      del,
      blockquote,
      img,
      checkbox,
      blockSpacing,
      listIndent,
      listBullet,
      listBulletPadding,
      tableHead,
      tableBody,
      tableHeadAlign,
      tableBorder,
      tableColumnWidth,
      tableCellsPadding,
      tableCellsDecoration,
      tableVerticalAlignment,
      blockquotePadding,
      blockquoteDecoration,
      codeblockPadding,
      codeblockDecoration,
      codePadding,
      codeDecoration,
      horizontalRuleDecoration,
      textAlign,
      h1Align,
      h2Align,
      h3Align,
      h4Align,
      h5Align,
      h6Align,
      unorderedListAlign,
      orderedListAlign,
      blockquoteAlign,
      codeblockAlign,
    ]);
  }
}
