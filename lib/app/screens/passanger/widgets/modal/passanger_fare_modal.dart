import 'package:alga_app/app/widgets/buttons/custom_button.dart';
import 'package:alga_app/app/widgets/textfield/custom_textfield.dart';
import 'package:flutter/material.dart';

class PassangerFareModal extends StatefulWidget {
  int selectedPayMethod;
  String fareValue;
  PassangerFareModal(
      {required this.selectedPayMethod, required this.fareValue});
  @override
  State<PassangerFareModal> createState() => _PassangerFareModalState();
}

class _PassangerFareModalState extends State<PassangerFareModal> {
  TextEditingController fareController = TextEditingController();
  int selectedLocalPaymentMethod = 0;
  @override
  void initState() {
    fareController.text = widget.fareValue;
    selectedLocalPaymentMethod = widget.selectedPayMethod;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      height: MediaQuery.of(context).size.height / 2,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Детали заказа',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context); // Close the modal sheet
                },
              ),
            ],
          ),
          SizedBox(height: 12),
          // TextField with money icon
          Text(
            'Укажите цену',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),

          CustomTextField(
            hintText: 'Укажите цену',
            controller: fareController,
          ),
          SizedBox(height: 10),
          Text(
            'Способ оплаты',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              setState(() {
                selectedLocalPaymentMethod = 0;
              });
            },
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                    width: 2,
                    color: (selectedLocalPaymentMethod == 0)
                        ? Colors.black
                        : const Color.fromARGB(255, 238, 238, 238)),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/kaspi.png',
                    width: 40,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text('Kaspi')
                ],
              ),
            ),
          ),
          SizedBox(height: 15),
          GestureDetector(
            onTap: () {
              setState(() {
                selectedLocalPaymentMethod = 1;
              });
            },
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                    width: 2,
                    color: (selectedLocalPaymentMethod == 1)
                        ? Colors.black
                        : const Color.fromARGB(255, 238, 238, 238)),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/nalichka.png',
                    width: 40,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text('Наличка')
                ],
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          CustomButton(
            text: 'Изменить',
            onTap: () async {
              Navigator.pop(context, {
                'payMethod': selectedLocalPaymentMethod,
                'fare': fareController.text
              });
            },
          )
        ],
      ),
    );
  }
}
