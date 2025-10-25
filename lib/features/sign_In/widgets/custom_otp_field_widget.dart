import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otp_pin_field/otp_pin_field.dart';
import 'package:final_year_project_frontend/constants/text_font_style.dart';
import 'package:final_year_project_frontend/gen/colors.gen.dart';

class CustomOtpPinField extends StatefulWidget {
  final int maxLength;
  final bool autoFillEnable;
  final bool showCustomKeyboard;
  final Function(String) onSubmit;
  final Function(String) onChange;

  const CustomOtpPinField({
    Key? key,
    this.maxLength = 4,
    this.autoFillEnable = false,
    this.showCustomKeyboard = false,
    required this.onSubmit,
    required this.onChange,
  }) : super(key: key);

  @override
  _CustomOtpPinFieldState createState() => _CustomOtpPinFieldState();
}

class _CustomOtpPinFieldState extends State<CustomOtpPinField> {
  final _otpPinFieldController = GlobalKey<OtpPinFieldState>();

  // Custom keyboard widget
  Widget _buildCustomKeyboard() {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.grey[200],
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(12, (index) {
          if (index == 9) {
            return Container(); // Empty space
          } else if (index == 10) {
            return _buildKeyboardButton('0');
          } else if (index == 11) {
            return _buildKeyboardButton('⌫', onTap: () {
              _otpPinFieldController.currentState?.clearOtp();
            });
          } else {
            return _buildKeyboardButton('${index + 1}');
          }
        }),
      ),
    );
  }

  Widget _buildKeyboardButton(String text, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap ??
          () {
            _otpPinFieldController.currentState?.controller.text += text;
          },
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OtpPinField(
          key: _otpPinFieldController,
          maxLength: widget.maxLength,
          autoFillEnable: widget.autoFillEnable,
          showCustomKeyboard: widget.showCustomKeyboard,
          customKeyboard: widget.showCustomKeyboard ? _buildCustomKeyboard() : null,
          showDefaultKeyboard: !widget.showCustomKeyboard,
          textInputAction: TextInputAction.done,
          onSubmit: widget.onSubmit,
          onChange: widget.onChange,
          onCodeChanged: (code) {
            print('Code changed: $code');
          },
          otpPinFieldStyle: OtpPinFieldStyle(
            textStyle: TextFontStyle.textStyle18c231F20poppins700,
            activeFieldBorderGradient: const LinearGradient(
              colors: [Colors.black, Colors.black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            filledFieldBorderGradient: const LinearGradient(
              colors: [Colors.black, Colors.black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            defaultFieldBorderGradient: const LinearGradient(
              colors: [Colors.black, Colors.black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          fieldHeight: 50.0,
          fieldWidth: 50.0,
          
          showCursor: true,
          cursorColor:AppColors.cF2F0F0,
          cursorWidth: 2.0,
          mainAxisAlignment: MainAxisAlignment.center,
          otpPinFieldDecoration: OtpPinFieldDecoration.defaultPinBoxDecoration,

        
        ),
      ],
    );
  }
}

