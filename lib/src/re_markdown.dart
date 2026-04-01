library re_markdown;

import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:re_highlight/languages/all.dart';
import 'package:re_highlight/re_highlight.dart';
import 'package:re_highlight/styles/a11y-dark.dart';
import 'package:url_launcher/url_launcher.dart';

part 'builder.dart';
part 'markdown.dart';
part 'style_sheet.dart';
part 'tags.dart';

part '_node.dart';
part '_visitor.dart';