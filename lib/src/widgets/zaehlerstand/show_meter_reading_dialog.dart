import 'package:flutter/material.dart';

class MeterReadingDialog extends StatelessWidget {
  const MeterReadingDialog({
    super.key,
    required this.minimalReadingValue,
    required this.zaehlerstandController,
  });

  final TextEditingController zaehlerstandController;
  final int minimalReadingValue;

  @override
  Widget build(BuildContext context) {
    // Create a FocusNode to handle autofocus
    final focusNode = FocusNode();

    // Ensure the cursor is at the end of the initial value
    zaehlerstandController.selection = TextSelection.fromPosition(
      TextPosition(offset: zaehlerstandController.text.length),
    );

    // Request focus when the dialog is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode);
    });

    return AlertDialog(
      title: Text('Heutiger Zählerstand', style: Theme.of(context).textTheme.headlineMedium),
      content: Form(
        child: TextFormField(
          style: Theme.of(context).textTheme.headlineLarge,
          controller: zaehlerstandController,
          focusNode: focusNode, // Attach the focus node
          keyboardType: TextInputType.number,
          autofocus: true, // Enable autofocus
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          maxLength: 6, // Limit input to 6 characters
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Bitte einen Wert eingeben';
            }
            if (!RegExp(r'^\d{1,6}$').hasMatch(value)) {
              return 'Bitte eine gültige 6-stellige Zahl eingeben';
            }
            return null;
          },
          onFieldSubmitted: (value) {
            // Save logic when the check symbol is pressed
            final input = zaehlerstandController.text;
            if (int.parse(input) <= minimalReadingValue) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Der eingegeben Zählerstand ist kleiner als der vorherige. Bitte korrigieren.')),
              );
            } else if (input.isNotEmpty && RegExp(r'^\d{1,6}$').hasMatch(input)) {
              Navigator.of(context).pop(input); 
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bitte eine gültige 6-stellige Zahl eingeben.')),
              );
            }
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Abbrechen', style: Theme.of(context).textTheme.bodyLarge),
        ),
        ElevatedButton(
          onPressed: () {
            final input = zaehlerstandController.text;
            if (int.parse(input) <= minimalReadingValue) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Der eingegeben Zählerstand is kleiner als der vorherige. Bitte korrigieren.')),
              );
            } else if (input.isNotEmpty && RegExp(r'^\d{1,6}$').hasMatch(input)) {
              Navigator.of(context).pop(input);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bitte eine gültige 6-stellige Zahl eingeben.')),
              );
            }
          },
          child: Text('Speichern', style: Theme.of(context).textTheme.bodyLarge),
        ),
      ],
    );
  }
}
