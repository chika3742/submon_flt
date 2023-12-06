import 'package:flutter/material.dart';
import 'package:submon/utils/utils.dart';

class DropdownTimePickerBottomSheet extends StatefulWidget {
  const DropdownTimePickerBottomSheet({super.key, this.initialTime});

  ///
  /// The [TimeOfDay] initially selected. if `null`, set to 0:00.
  ///
  final TimeOfDay? initialTime;

  @override
  State<DropdownTimePickerBottomSheet> createState() => _DropdownTimePickerBottomSheetState();
}

class _DropdownTimePickerBottomSheetState extends State<DropdownTimePickerBottomSheet> {
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();

    _selectedTime = widget.initialTime ?? const TimeOfDay(hour: 0, minute: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  items: range(0, 23).map((e) => DropdownMenuItem(
                    value: e,
                            child: Text("$e 時"),
                          )).toList(),
                  value: _selectedTime.hour,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "時",
                  ),
                  onChanged: (value) {
                    setState(() {
                      _selectedTime = TimeOfDay(hour: value!, minute: _selectedTime.minute);
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<int>(
                  items: range(0, 55, 5).map((e) => DropdownMenuItem(
                    value: e,
                            child: Text("$e 分"),
                          )).toList(),
                  value: _selectedTime.minute,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "分",
                  ),
                  onChanged: (value) {
                    setState(() {
                      _selectedTime = TimeOfDay(hour: _selectedTime.hour, minute: value!);
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0, bottom: 16.0),
            child: IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                Navigator.pop(context, _selectedTime);
              },
            ),
          ),
        ),
      ],
    );
  }
}
