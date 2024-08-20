import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/a11y-light.dart';
import 'package:highlight/languages/python.dart';

final controller = CodeController(
  text: '',
  language: python,
);

class CodeEditor extends StatelessWidget {
  const CodeEditor({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CodeTheme(
          data: CodeThemeData(styles: a11yLightTheme),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: CodeField(
                      controller: controller,
                      minLines: 20
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}