import 'package:expense_mate/src/features/categorypage/presentation/add_cashflow_page/add_cashflow_page.dart';
import 'package:expense_mate/src/shared/domain/cashflow_model.dart';
import 'package:expense_mate/src/shared/extension/custom_theme_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// CategoryPicker is a CupertinoDatePicker that allows the user to select a date when creating a [Cashflow]
/// It is used inside [AddCashflowPage].
///
/// This widget:
/// - Will set the selectedDate to the current time when it is initialized
///
/// Parameters:
/// - [onDateSelected]:  a setState()-Method to update the value of the selected date on [AddCashflowPage] if the selected item changes.
/// - [initialDate]: (optional) An initially selected date. Given if the [AddCashflowPage] is accessed
///                   through the [CashflowDetailPage] to edit an existing [Cashflow] and display the date of it inside the picker.
///

class DatePickerWidget extends StatefulWidget {
  final void Function(DateTime) onDateSelected;
  final DateTime? initialDate;
  const DatePickerWidget({
    super.key,
    required this.onDateSelected,
    this.initialDate,
  });

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  late DateTime selectedDate;

  //Uses the current time or a given date, depending on if a new [Cashflow] is created or an existing one gets edited.
  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<CustomThemeColorsExtension>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: theme?.mainBackGroundColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: theme?.secondaryBackgroundColor ?? Colors.black,

            width: 2.0,
          ),
        ),
        constraints: const BoxConstraints(minHeight: 48.0),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedDate.toLocal().toString().split(' ')[0],
              style: TextStyle(
                fontFamily: GoogleFonts.roboto().fontFamily,
                color: theme?.textColor,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed:
                  () => showCupertinoModalPopup(
                    context: context,
                    builder: (context) {
                      return Container(
                        height: 300,
                        color: theme?.mainBackGroundColor,
                        child: CupertinoTheme(
                          data: CupertinoThemeData(
                            textTheme: CupertinoTextThemeData(
                              dateTimePickerTextStyle: TextStyle(
                                color: theme?.textColor,
                                fontSize: 22,
                              ),
                            ),
                          ),
                          child: CupertinoDatePicker(
                            initialDateTime: selectedDate,
                            minimumYear: 1990,
                            maximumYear: DateTime.now().year,
                            onDateTimeChanged: (newDate) {
                              setState(() {
                                selectedDate = newDate;
                              });
                              widget.onDateSelected(newDate);
                            },
                            mode: CupertinoDatePickerMode.date,
                          ),
                        ),
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
