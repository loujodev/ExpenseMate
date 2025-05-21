import 'package:expense_mate/src/shared/config/config.dart';
import 'package:expense_mate/src/shared/extension/custom_theme_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectIconWidget extends StatefulWidget {
  final void Function(String value, IconData icon)? onChanged;
  final String? initialValue;

  const SelectIconWidget({super.key, this.onChanged, this.initialValue});

  @override
  SelectIconWidgetState createState() => SelectIconWidgetState();
}

class SelectIconWidgetState extends State<SelectIconWidget> {
  String? selectedValue;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
    if (widget.initialValue != null) {
      selectedIndex = expenseCategories.indexWhere(
        (option) => option['value'] == widget.initialValue,
      );
      if (selectedIndex == -1) selectedIndex = 0;
    }
  }

  void _showPicker(BuildContext context) {
    final theme = Theme.of(context).extension<CustomThemeColorsExtension>();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: theme?.mainBackGroundColor,
          height: 250,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CupertinoButton(
                    child: const Text('Done'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              Expanded(
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                    initialItem: selectedIndex,
                  ),
                  itemExtent: 40,
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      selectedIndex = index;
                      selectedValue = expenseCategories[index]['value'];
                    });
                    if (widget.onChanged != null) {
                      widget.onChanged!(
                        expenseCategories[index]['value'],
                        expenseCategories[index]['icon'],
                      );
                    }
                  },
                  children:
                      expenseCategories.map((option) {
                        return Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                option['icon'],
                                size: 24,
                                color: theme?.textColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                option['value'],
                                style: TextStyle(color: theme?.textColor),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<CustomThemeColorsExtension>();
    return GestureDetector(
      onTap: () => _showPicker(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Select an icon',
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (selectedValue != null)
              Row(
                children: [
                  Icon(
                    expenseCategories[selectedIndex]['icon'],
                    size: 24,
                    color: theme?.textColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    selectedValue!,
                    style: TextStyle(color: theme?.textColor),
                  ),
                ],
              )
            else
              const Text('Select an option'),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
