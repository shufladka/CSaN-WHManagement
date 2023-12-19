import 'package:csan/widgets/input_decoration_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EditOrderDialog extends StatefulWidget {
  const EditOrderDialog({super.key});

  @override
  _EditOrderDialogState createState() => _EditOrderDialogState();
}

class _EditOrderDialogState extends State<EditOrderDialog> {

  String order = '';
  String state = 'В обработке';
  String amount = '';
  String weight = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: 260,
        width: 400,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Создание нового заказа',
                  style: GoogleFonts.montserrat(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                /*

                // ОСТАВИЛ ДЛЯ РЕДАКТИРОВАНИЯ ЗАКАЗА!!!!!!

                const SizedBox(height: 16),
                DropdownButton<String>(
                  value: state,
                  onChanged: (value) {
                    setState(() {
                      state = value!;
                    });
                  },
                  items: ['В ожидании', 'Отправлен', 'Доставлен', 'Отменен', 'В обработке']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: GoogleFonts.montserrat(
                          color: Colors.black87,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  })
                      .toList(),
                ),

                 */

                const SizedBox(height: 12),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      amount = value;
                    });
                  },
                  decoration: InputDecorationBuilder.buildInputDecoration(context, 'Стоимость, BYN'),
                  style: GoogleFonts.montserrat(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  keyboardType: TextInputType.number,
                  cursorColor: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      weight = value;
                    });
                  },
                  decoration: InputDecorationBuilder.buildInputDecoration(context, 'Вес, грамм'),
                  style: GoogleFonts.montserrat(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  keyboardType: TextInputType.number,
                  cursorColor: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () async {

                    // Получаем текущее количество записей
                    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('orders').get();
                    int currentOrderNumber = snapshot.size + 1;

                    String df = DateFormat('dd.MM.yyyy | HH:mm:ss').format(DateTime.now());
                    print('Order: $currentOrderNumber');
                    print('Date: $df');
                    print('State: $state');
                    print('amount: $amount');
                    print('Weight: $weight');

                    await FirebaseFirestore.instance.collection('orders').add({
                      'amount': amount,
                      'date': DateFormat('dd.MM.yyyy | HH:mm:ss').format(DateTime.now()),  // текущая дата в формате дд.мм.гггг
                      'number': currentOrderNumber,
                      'state': state,
                      'weight': weight,
                    });

                    Navigator.pop(context); // Закрыть диалог
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    fixedSize: Size.fromWidth(MediaQuery.of(context).size.width), // Выравнивание по ширине
                  ),
                  child: Text(
                    'СОХРАНИТЬ ИЗМЕНЕНИЯ',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}