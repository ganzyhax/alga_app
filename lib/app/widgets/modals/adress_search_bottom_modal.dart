import 'dart:developer';

import 'package:alga_app/app/screens/dgis_map/components/pick_on_map_screen.dart';
import 'package:alga_app/app/screens/passanger/passanger_screen.dart';
import 'package:alga_app/app/widgets/textfield/custom_textfield.dart';
import 'package:alga_app/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AddressSearchModal extends StatefulWidget {
  final String currentAddress;
  AddressSearchModal({required this.currentAddress});
  @override
  _AddressSearchModalState createState() => _AddressSearchModalState();
}

class _AddressSearchModalState extends State<AddressSearchModal> {
  final TextEditingController _addressAController = TextEditingController();
  final TextEditingController _addressBController = TextEditingController();
  final FocusNode _addressAFocusNode = FocusNode();
  final FocusNode _addressBFocusNode = FocusNode();
  var addressesResults = {};
  List<String> _searchResults = [];

  @override
  void initState() {
    super.initState();
    // Add listeners to focus nodes
    _addressAController.text = widget.currentAddress;
    _addressAFocusNode.addListener(() {
      if (_addressAFocusNode.hasFocus) {
        print('Focus on 1st text field');
      }
    });
    _addressBFocusNode.addListener(() {
      if (_addressBFocusNode.hasFocus) {
        print('Focus on 2nd text field');
      }
    });
  }

  void _searchAddresses() {
    // Simulate searching for addresses
    String addressA = _addressAController.text;
    String addressB = _addressBController.text;

    setState(() {
      _searchResults = [
        'Result for $addressA',
        'Result for $addressB',
        'Result for combined search: $addressA & $addressB',
      ];
    });
  }

  void _onSelectOnMap() async {
    if (_addressAFocusNode.hasFocus) {
      var address = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PickOnMapScreen()),
      );
      if (address != null) {
        _addressAController.text = address['address'];
        addressesResults['addressA'] = address;
        _addressAFocusNode.unfocus();
        _addressBFocusNode.unfocus();
        setState(() {});
      }
    } else if (_addressBFocusNode.hasFocus) {
      var address = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PickOnMapScreen()),
      );
      if (address != null) {
        _addressBController.text = address['address'];
        addressesResults['addressB'] = address;
        _addressAFocusNode.unfocus();
        _addressBFocusNode.unfocus();
        setState(() {});
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PassangerScreen()),
        );
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(15),
      ),
      height: MediaQuery.of(context).size.height * 0.9,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Выберите маршрут',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 12,
                    offset: Offset(0, 20),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CustomTextField(
                    hintText: 'Откуда',
                    controller: _addressAController,
                    iconData: Icons.circle_outlined,
                    focusedIconData: Icons.search,

                    focusedIconColor: Colors.grey,
                    focusNode: _addressAFocusNode, // Attach focus node
                  ),
                  SizedBox(height: 5),
                  Divider(),
                  SizedBox(height: 5),
                  CustomTextField(
                    hintText: 'Куда',
                    controller: _addressBController,
                    iconColor: Colors.grey[400],
                    iconData: Icons.circle_outlined,
                    focusedIconData: Icons.search,
                    focusNode: _addressBFocusNode, // Attach focus node
                  ),
                  SizedBox(height: 15),
                  // (_addressBFocusNode.hasFocus || _addressAFocusNode.hasFocus)
                  //     ?
                  GestureDetector(
                    onTap: _onSelectOnMap,
                    child: Row(
                      children: [
                        Icon(Icons.location_searching),
                        SizedBox(width: 15),
                        Text(
                          'Выбрать на карте',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                  // : SizedBox()
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [addressCard()],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _addressAFocusNode.dispose();
    _addressBFocusNode.dispose();
    _addressAController.dispose();
    _addressBController.dispose();
    super.dispose();
  }

  addressCard() {
    return Container(
      child: Row(
        children: [
          Icon(
            Icons.location_on_outlined,
            color: Colors.grey,
            size: 30,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Хан Шатыр ТРЦ',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Астана',
                  style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 1, // Thickness of the underline
                  color: Colors.grey[300], // Underline color
                  width: double.infinity, // Makes the underline stretch to fill
                ),
              ],
            ),
          ),
          // Underline as a container
        ],
      ),
    );
  }
}
