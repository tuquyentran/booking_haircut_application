import 'package:flutter/material.dart';

import 'const.dart';

Widget dropdownAD(
    List<String> items, String? selectedItem, ValueChanged<String?> onChanged) {
  return Container(
    width: 190,
    child: Row(
      children: [
        Expanded(
          child: DropdownButton<String>(
            isExpanded: true,
            value: selectedItem,
            hint: const Text('Hãy chọn'),
            dropdownColor: Colors.white,
            onChanged: onChanged,
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: infoDetailStyle,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    ),
  );
}
