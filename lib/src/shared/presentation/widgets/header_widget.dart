import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final String text;
  final bool showBackButton;

  const HeaderWidget({
    super.key,
    required this.text,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    //final theme = Theme.of(context).extension<CustomThemeColorsExtension>();
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (showBackButton)
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
