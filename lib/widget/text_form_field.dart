import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ucservice_customer/utils/color_widget.dart';

class CustomTextfield extends StatefulWidget {
  final TextEditingController? fieldController;
  final String? fieldName;
  final TextCapitalization? textCapitalization;
  final String? hint;
  final TextInputType? fieldInputType;
  final bool? enabled;
  final Color? bgColor;
  final int? maxLine;
  final int? maxLength;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChange;
  final ValueChanged<String>? onSaved;
  final VoidCallback? onTap;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? obscureText;
  final double? contentpadding;
  final Color? cursorColor;
  final TextStyle? hintStyle;
  final double? cursorHeight;
  final String? errorText;
  final List<TextInputFormatter>? inputFormatter;
  final bool? autofocus;
  final bool? readOnly;

  // final MaxLengthEnforcement? maxLengthEnforcement;

  const CustomTextfield({
    Key? key,
    this.fieldName,
    this.textCapitalization,
    this.bgColor,
    this.fieldController,
    this.fieldInputType,
    this.enabled,
    this.maxLine,
    this.maxLength,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.autofocus,
    this.contentpadding,
    this.cursorColor,
    this.cursorHeight,
    this.errorText,
    this.hint,
    this.hintStyle,
    this.inputFormatter,
    this.obscureText,
    this.onChange,
    this.onSaved,
    this.onTap,
    this.readOnly,
    // this.maxLengthEnforcement,
  }) : super(key: key);

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: CustomColors.black,
      controller: widget.fieldController,
      inputFormatters: widget.inputFormatter,
      validator: widget.validator,
      maxLength: widget.maxLength,
      readOnly: widget.readOnly ?? false,
      // maxLengthEnforcement:
      //     widget.maxLengthEnforcement ?? MaxLengthEnforcement.enforced,
      obscureText: widget.obscureText ?? false,
      textInputAction: TextInputAction.next,
      keyboardType: widget.fieldInputType ?? TextInputType.text,
      decoration: InputDecoration(
          isDense: true,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          hintStyle: widget.hintStyle,
          labelText: widget.hint,
          labelStyle: const TextStyle(color: CustomColors.grey),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: CustomColors.grey),
            borderRadius: BorderRadius.circular(16),
          ),
          // disabledBorder: OutlineInputBorder(
          //   borderSide: const BorderSide(color: CustomColors.grey),
          //   borderRadius: BorderRadius.circular(16),
          // ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: CustomColors.red, width: 0),
            borderRadius: BorderRadius.circular(16),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: CustomColors.red),
            borderRadius: BorderRadius.circular(16),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: CustomColors.grey),
            borderRadius: BorderRadius.circular(16),
          )),
    );
  }
}
