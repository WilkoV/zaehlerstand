import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zaehlerstand/src/models/base/reading_dialog_result.dart';

class EnterReadingDialog extends StatefulWidget {
  EnterReadingDialog({
    super.key,
    required this.minimalReadingValue,
    required this.minimalDateValue,
    required this.zaehlerstandController,
    required this.dateController,
  });

  final TextEditingController zaehlerstandController;
  final TextEditingController dateController;
  final int minimalReadingValue;
  final DateTime minimalDateValue;
  final FocusNode zaehlerstandFocusNode = FocusNode();

  @override
  State<EnterReadingDialog> createState() => _EnterReadingDialogState();
}

class _EnterReadingDialogState extends State<EnterReadingDialog> {
  @override
  Widget build(BuildContext context) {
    // Ensure the cursor is placed at the end of the initial value
    widget.zaehlerstandController.selection = TextSelection.fromPosition(
      TextPosition(offset: widget.zaehlerstandController.text.length),
    );

    return AlertDialog(
      title: Text(
        'Heutiger Zählerstand',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Zählerstand Text Field
            TextFormField(
              style: Theme.of(context).textTheme.headlineLarge,
              controller: widget.zaehlerstandController,
              keyboardType: TextInputType.number,
              autofocus: true,
              focusNode: widget.zaehlerstandFocusNode,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Zählerstand',
              ),
              maxLength: 6,
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
                final input = widget.zaehlerstandController.text;
                if (int.tryParse(input) == null || !RegExp(r'^\d{1,6}$').hasMatch(input)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Bitte eine gültige 6-stellige Zahl eingeben.'),
                    ),
                  );
                } else if (int.parse(input) <= widget.minimalReadingValue) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Der eingegebene Zählerstand ist kleiner als der vorherige. Bitte korrigieren.'),
                    ),
                  );
                } else {
                  DateTime tmpDate = DateFormat('dd.MM.yyyy').parse(widget.dateController.text);
                  DateTime resultDate = DateTime(tmpDate.year, tmpDate.month, tmpDate.day, 12);
                  Navigator.of(context).pop(ReadingDialogResult(
                    reading: int.parse(widget.zaehlerstandController.text),
                    date: resultDate,
                  ));
                }
              },
            ),
            const SizedBox(height: 16.0),
            // Date Picker Text Field
            TextFormField(
              controller: widget.dateController,
              readOnly: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Datum',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () async {
                if (DateTime.now().difference(widget.minimalDateValue).inDays >= 1) {
                  await _buildDatePicker(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Nur heutiges Datum möglich.'),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        // Cancel Button
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Abbrechen', style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).indicatorColor)),
        ),
        // Save Button
        ElevatedButton(
          onPressed: () {
            final reading = widget.zaehlerstandController.text;

            if (reading.isEmpty || !RegExp(r'^\d{1,6}$').hasMatch(reading)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Bitte eine gültige 6-stellige Zahl eingeben.'),
                ),
              );
            } else if (int.parse(reading) <= widget.minimalReadingValue) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Der eingegebene Zählerstand ist kleiner als der vorherige. Bitte korrigieren.'),
                ),
              );
            } else {
              Navigator.of(context).pop(ReadingDialogResult(
                reading: int.parse(widget.zaehlerstandController.text),
                date: DateFormat('dd.MM.yyyy').parse(widget.dateController.text),
              ));
            }
          },
          child: Text(
            'Speichern',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).indicatorColor),
          ),
        ),
      ],
    );
  }

  Future<void> _buildDatePicker(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: widget.minimalDateValue,
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.bodyMedium,
            )),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      final currentZaehlerstand = widget.zaehlerstandController.text;

      setState(() {
        widget.dateController.text = DateFormat('dd.MM.yyyy').format(selectedDate);
        widget.zaehlerstandController.text = currentZaehlerstand;
      });
    }
  }
}
