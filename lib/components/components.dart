import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final String? hintText;
  final String? label;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final IconData? prefix;
  final bool isPassword;
  final TextEditingController controller;

  const CustomTextFormField({super.key,
    required this.controller,
    this.hintText,
    this.isPassword=false,
    this.label,
    this.onChanged,
    this.prefix,
    this.validator});

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool isObscured = true;
  @override
  Widget build(BuildContext context) {
    final defaultPadding = EdgeInsets.symmetric(horizontal: 15);
    return Padding(padding: defaultPadding,
    child: TextFormField(
        controller: widget.controller,
      obscureText: widget.isPassword? isObscured:false,
      validator: widget.validator,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade500),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.circular(15),
        ),
        prefixIcon: widget.prefix != null? Icon(widget.prefix):null,
        suffixIcon: widget.isPassword? IconButton(
            onPressed: (){
              setState(() {
                isObscured = !isObscured;
              });
            },
            icon: Icon(isObscured ?Icons.visibility:Icons.visibility_off)
        ):null,
        prefixIconColor: Colors.grey[400],
        suffixIconColor: Colors.blue,
        hintText: widget.hintText,
        labelText: widget.label,
        hintStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[100],
      ),

    ),
    );
  }
}
