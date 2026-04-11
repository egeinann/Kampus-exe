import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.exampleText != null && widget.exampleText!.isNotEmpty)
          Text(
            "Örnek: ${widget.exampleText}",
            style: GoogleFonts.roboto(
              fontSize: 14.sp,
              color: TrakyaColors.negative,
            
            ),
          ),
        TextField(
          textCapitalization: TextCapitalization.none,
          maxLength: widget.maxLength,
          controller: widget.textEditingController,
          obscureText: widget.hasSuffixIcon ? obscureVisible : false,
          style: GoogleFonts.roboto(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: TrakyaColors.negative,
            letterSpacing: 1,
           
          ),
          inputFormatters: [
            if (widget.isUppercase)
              TurkishUpperCaseTextInputFormatter(),
          ],
          decoration: InputDecoration(
            counterText: "",
            filled: true,
            fillColor: TrakyaColors.card,
            prefixIcon: widget.prefixIcon,
            hintText: widget.hintText ?? "",
            hintStyle: GoogleFonts.roboto(
              fontSize: 17,
              fontWeight: FontWeight.w500,
             
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
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
          ),
        ),
      ],
    );
  }
}

/// Türkçe karakterleri doğru şekilde büyük harfe çeviren input formatter
class TurkishUpperCaseTextInputFormatter extends TextInputFormatter {
  final Map<String, String> _map = {
    'i': 'İ',
    'ı': 'I',
    'ş': 'Ş',
    'ğ': 'Ğ',
    'ü': 'Ü',
    'ö': 'Ö',
    'ç': 'Ç',
    'â': 'Â',
    'î': 'Î',
    'û': 'Û',
  };

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text.split('').map((c) => _map[c] ?? c.toUpperCase()).join();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}