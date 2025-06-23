import 'package:flutter/material.dart';
import 'package:localcooks_app/common/constants.dart';

class InputFieldWithShadow extends StatefulWidget {

  IconData? prefixIcon;
  String hintLabel;
  bool? isReadOnly;
  Function()? onTap;
  TextInputType? keyboardType;
  TextEditingController? textController;
  int? maxLength;
  FormFieldValidator<String>? validator;
  InputFieldWithShadow({required this.hintLabel, this.prefixIcon, this.onTap, this.isReadOnly, this.textController, this.keyboardType, this.maxLength, this.validator});

  @override
  _InputFieldWithShadowState createState() => _InputFieldWithShadowState();
}

class _InputFieldWithShadowState extends State<InputFieldWithShadow> {
  bool isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: isFocused ? Colors.red.withOpacity(0.3) : Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(-2, 0),
          ),
        ],
      ),
      child: TextFormField(
        controller: widget.textController,
        onTap: widget.onTap,
        onTapOutside: (event) {
          setState(() {
            isFocused = false;
          });
        },
        keyboardType: widget.keyboardType,
        readOnly: widget.isReadOnly ?? false,
        maxLength: widget.maxLength,
        validator: widget.validator,
        decoration: InputDecoration(
          prefixIcon: Icon(widget.prefixIcon, color: Theme.of(context).primaryColor),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.red, width: 1)
          ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.red, width: 2)
            ),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          hintText: widget.hintLabel,
          hintStyle: titleMedium,
          counterText: ''
        ),
      ),
    );
  }
}