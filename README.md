# Re-Markdown

[![latest version](https://img.shields.io/pub/v/re_markdown.svg?color=blue)](https://pub.dev/packages/re_markdown)

[中文版本](./README_CN.md)

`Re-Markdown` is a lightweight Flutter Markdown preview widget and a submodule of the [Reqable](https://reqable.com) project. `Re-Markdown` uses [re-highlight](https://github.com/reqable/re-highlight) as its code highlighting engine, supports hundreds of programming languages and color themes, and provides extensibility for custom code views, image views, and link actions. It also supports streaming rendering for AI-generated content.

**⚠️ Note: Table of contents (TOC) features are not supported.**

![](./arts/screenshot_01.png)

## Getting Started

Add the dependency to `pubspec.yaml`.

```yaml
dependencies:
	re_markdown: ^0.0.1
```

Render your Markdown content:

```dart
Markdown(
	data: "Your markdown content here",
)
```

## Customize Base Styles

You can use `StyleSheet` to configure styles for each Markdown tag and block in your Markdown view.

```dart
StyleSheet(
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
```

## Customize Code Block Styles

You can use `CodeBlockWidgetBuilder` to customize code block rendering. A default implementation, `DefaultCodeBlockWidgetBuilder`, is provided. You can configure syntax highlighting styles through its parameters, or subclass it and override `build` to add more features, such as wrap and copy buttons.

```dart
class _CodeBlockWidgetBuilder extends DefaultCodeBlockWidgetBuilder {

	_CodeBlockWidgetBuilder({
		required super.wordWrap,
		required super.theme,
	});

	@override
	Widget build(BuildContext context, CodeBlockNodeData data, StyleSheet styleSheet) {
		return Stack(
			children: [
				super.build(context, data, styleSheet),
				Positioned(
					right: 5,
					top: 5,
					child: Row(
						children: [
							// TODO: add icon buttons
						],
					)
				)
			],
		);
	}

}
```

## Customize Image Styles

You can use `ImageWidgetBuilder` to customize image rendering, including loading logic and error states. A default implementation, `DefaultImageWidgetBuilder`, is provided and supports custom image load-failure views. If you need full control, you can implement the `ImageWidgetBuilder` interface yourself.

```dart
class CustomImageWidgetBuilder implements ImageWidgetBuilder {

	@override
	Widget build(BuildContext context, ImageNodeData data, StyleSheet styleSheet) {
		// TODO: Add support for image loading and error handling.
	}

}
```

## Customize Tap Actions

By default, links are opened using `url_launcher`. You can customize link tap behavior by implementing the `LinkActionBuilder` interface.

```dart
class _LinkActionBuilder implements LinkActionBuilder {

	@override
	void onTap(BuildContext context, Uri uri) {
		// TODO: handle your tap event.
	}

}
```

## Content Selection

`Re-Markdown` supports full content selection. Just wrap it with `SelectionArea` in the parent layout.

```dart
SelectionArea(
	child: Markdown(
		data: "Your markdown content here",
	)
)
```

## Supported Markdown Tags

- blockquote
- ul
- ol
- li
- table
- thead
- tbody
- tr
- th
- td
- hr
- pre
- h1
- h2
- h3
- h4
- h5
- h6
- a
- p
- code
- em
- del
- br
- strong
- img
- input
- comment

## License

MIT License

## Acknowledgements

During development, we used or referenced the following projects. We sincerely appreciate their work.

- [markdown](https://pub.dev/packages/markdown)
- [markdown_widget](https://pub.dev/packages/markdown_widget)

## Sponsor

If this project is helpful to you, you are welcome to support us by purchasing a [Reqable](https://reqable.com/pricing) membership.