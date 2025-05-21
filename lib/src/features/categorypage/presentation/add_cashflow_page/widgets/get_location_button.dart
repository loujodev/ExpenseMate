import 'package:expense_mate/src/features/categorypage/presentation/add_cashflow_page/add_cashflow_page.dart';
import 'package:expense_mate/src/shared/domain/cashflow_model.dart';
import 'package:expense_mate/src/shared/extension/custom_theme_extension.dart';
import 'package:expense_mate/src/shared/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// LocationInputField is a Stack that allows the user to manually enter a location inside of a [TextFormField]
/// or automatically inserting it by pressing the [IconButton]
/// The Icon button gets the current location of the user by using the [LocationService].
///
/// This widget:
/// - Has no validators and can be empty due to it being an optional property of [Cashflow]
///
/// Parameters:
/// - [controller]: A [TextEditingController] passed from the AddCashflowPage to access the entered text outside of this widget in [AddCashflowPage].
///
class LocationInputField extends StatelessWidget {
  final TextEditingController controller;
  const LocationInputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<CustomThemeColorsExtension>();
    final LocationService locationService = LocationService();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.07,
        child: Stack(
          children: [
            TextFormField(
              style: TextStyle(
                color: theme?.textColor ?? Colors.white,
                fontFamily: GoogleFonts.roboto().fontFamily,
              ),
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(
                    color: theme?.secondaryBackgroundColor ?? Colors.grey,
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(
                    color: theme?.secondaryBackgroundColor ?? Colors.grey,
                    width: 2,
                  ),
                ),
                hintText: 'Enter text / Press button (optional) ',
                filled: true,
                fillColor: theme?.mainBackGroundColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(
                    IconData(0xe3ab, fontFamily: 'MaterialIcons'),
                  ),
                  onPressed: () async {
                    final locationResult =
                        await locationService.getCurrentCityAndStreet();
                    final location =
                        "${locationResult.$1}, ${locationResult.$2}";
                    controller.text = location;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
