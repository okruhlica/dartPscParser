library postal_codes;

import 'dart:async';
import 'dart:io';

part 'postal_code_importer.dart';
part 'postal_code.dart';

String ltrim(String str) => str.replaceFirst(new RegExp(r"^\s+"), "");
String rtrim(String str) => str.replaceFirst(new RegExp(r"\s+$"), "");
String trim(String str) => ltrim(rtrim(str));
