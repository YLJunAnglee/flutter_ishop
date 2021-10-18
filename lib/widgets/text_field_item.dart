import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lj_ishop/res/gaps.dart';
import 'package:lj_ishop/util/input_formatter/number_text_input_formatter.dart';

/// 封装输入框
class TextFieldItem extends StatelessWidget {
  const TextFieldItem(
      {Key? key,
      this.controller,
      required this.title,
      this.keyboardType = TextInputType.text,
      this.hintText = '',
      this.focusNode})
      : super(key: key);

  final TextEditingController? controller;
  final String title;
  final String hintText;
  final TextInputType keyboardType;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final Row child = Row(
      children: [
        Text(title),
        Gaps.hGap16,
        Expanded(
            child: Semantics(
          label: hintText.isEmpty ? '请输入$title' : hintText,
          child: TextField(
            focusNode: focusNode,
            keyboardType: keyboardType,
            controller: controller,
            inputFormatters: _getInputFormatters(),
            decoration:
                InputDecoration(border: InputBorder.none, hintText: hintText),
          ),
        )),
        Gaps.hGap16,
      ],
    );
    return Container(
      height: 50.0,
      width: double.infinity,
      margin: EdgeInsets.only(left: 16.0),
      child: child,
      decoration: BoxDecoration(
          border:
              Border(bottom: Divider.createBorderSide(context, width: 0.6))),
    );
  }

  List<TextInputFormatter>? _getInputFormatters() {
    if (keyboardType == const TextInputType.numberWithOptions(decimal: true)) {
      return <TextInputFormatter>[UsNumberTextInputFormatter()];
    }
    if (keyboardType == TextInputType.number ||
        keyboardType == TextInputType.phone) {
      return <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly];
    }
    return null;
  }
}
