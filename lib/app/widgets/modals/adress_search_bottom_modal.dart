import 'package:alga_app/app/widgets/textfield/custom_textfield.dart';
import 'package:flutter/material.dart';

class AddressSearchModal extends StatefulWidget {
  @override
  _AddressSearchModalState createState() => _AddressSearchModalState();
}

class _AddressSearchModalState extends State<AddressSearchModal> {
  final TextEditingController _addressAController = TextEditingController();
  final TextEditingController _addressBController = TextEditingController();
  List<String> _searchResults = [];

  void _searchAddresses() {
    // Simulate searching for addresses
    String addressA = _addressAController.text;
    String addressB = _addressBController.text;

    // Here you would typically call your address search API or logic
    // For demonstration, we're adding dummy results
    setState(() {
      _searchResults = [
        'Result for $addressA',
        'Result for $addressB',
        'Result for combined search: $addressA & $addressB',
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      height: MediaQuery.of(context).size.height * 0.9,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _addressAController,
              decoration: InputDecoration(
                labelText: 'Откуда',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => _searchAddresses(), // Search on text change
            ),
            SizedBox(height: 16),
            TextField(
              controller: _addressBController,
              decoration: InputDecoration(
                labelText: 'Куда',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => _searchAddresses(), // Search on text change
            ),
            SizedBox(height: 16),
            if (_searchResults.isNotEmpty)
              Column(
                children: _searchResults.map((result) {
                  return ListTile(
                    title: Text(result),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
