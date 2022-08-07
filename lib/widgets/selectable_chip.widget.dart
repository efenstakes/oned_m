import 'package:flutter/material.dart';


class SelectableChipWidget extends StatelessWidget {
  String text;
  bool isSelected;
  Function onSelect;

  SelectableChipWidget({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=> onSelect(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 9,
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors.brown : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.brown,
            width: 1,
          )
        ),
      ),
    );
  }
}