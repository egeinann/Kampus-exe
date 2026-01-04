import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:trakya_kampus_41/constants/colors.dart';

class TrakyaTextfield extends StatefulWidget {
  final BuildContext context;
  final Widget? prefixIcon;
  final String? hintText;
  final bool hasSuffixIcon;
  final TextEditingController textEditingController;
  final String? exampleText;
  final int? maxLength;
  final bool isUppercase;

  const TrakyaTextfield({
    super.key,
    required this.context,
    this.prefixIcon,
    this.hintText,
    this.hasSuffixIcon = false,
    required this.textEditingController,
    this.exampleText,
    this.maxLength,
    this.isUppercase = false,
  });

  @override
  State<TrakyaTextfield> createState() => _TrakyaTextfieldState();
}

class _TrakyaTextfieldState extends State<TrakyaTextfield> {
  bool obscureVisible = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // example true ise göster, değilse hiç widget ekleme
        if (widget.exampleText != null && widget.exampleText!.isNotEmpty)
          Text(
            "Örnek: ${widget.exampleText}",
            style: TextStyle(
              fontSize: 14.sp,
              color: TrakyaColors.negative,
              fontFamily: "Roboto",
            ),
          ),
        TextField(
          maxLength: widget.maxLength,
          controller: widget.textEditingController,
          obscureText: widget.hasSuffixIcon ? obscureVisible : false,
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w900,
            color: TrakyaColors.negative,
            fontFamily: "RobotoBold",
          ),
          inputFormatters: [
            if (widget.isUppercase)
              TextInputFormatter.withFunction((oldValue, newValue) {
                return newValue.copyWith(
                  text: newValue.text.toUpperCase(),
                  selection: newValue.selection,
                );
              }),
          ],
          decoration: InputDecoration(
            counterText: "",
            filled: true,
            fillColor: TrakyaColors.card,
            prefixIcon: widget.prefixIcon,
            hintText: widget.hintText ?? "",
            hintStyle: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              fontFamily: "Roboto",
              color: TrakyaColors.negative,
            ),
            suffixIcon: widget.hasSuffixIcon
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        obscureVisible = !obscureVisible;
                      });
                    },
                    child: Icon(
                      obscureVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  )
                : null,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: 18,
              horizontal: 18,
            ),
          ),
        ),
      ],
    );
  }
}
