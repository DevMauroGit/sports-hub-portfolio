import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sports_hub_ios/utils/constants.dart';

class CodeBoard extends StatefulWidget {
  const CodeBoard({super.key, required this.verificationId});

  final RxString verificationId;

  @override
  State<CodeBoard> createState() => _CodeBoardState();
}

class _CodeBoardState extends State<CodeBoard> {
  TextEditingController textEditingController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: PinCodeTextField(
          controller: textEditingController,
          length: 6,
          appContext: context,
          keyboardType: TextInputType.number,
        ),
      ),
    );
  }
}
