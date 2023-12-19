import 'package:csan/widgets/input_decoration_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class EditOrderDialog extends StatefulWidget {
  const EditOrderDialog({super.key});

  @override
  _EditOrderDialogState createState() => _EditOrderDialogState();
}

/*
class _EditOrderDialogState extends State<EditOrderDialog> {

  String order = '';
  String date = '';
  //String selectedStatus = 'Pending';
  String selectedStatus = '';
  String cost = '';
  String weight = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: 340,
        width: 400,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Редактирование заказа',
                  style: GoogleFonts.montserrat(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // const SizedBox(height: 16),
                // DropdownButton<String>(
                //   value: selectedStatus,
                //   onChanged: (value) {
                //     setState(() {
                //       selectedStatus = value!;
                //     });
                //   },
                //   items: ['Pending', 'Shipped', 'Delivered', 'Cancelled', 'Processing']
                //       .map<DropdownMenuItem<String>>((String value) {
                //     return DropdownMenuItem<String>(
                //       value: value,
                //       child: Text(
                //         value,
                //         style: GoogleFonts.montserrat(
                //           color: Colors.black87,
                //           fontSize: 15,
                //           fontWeight: FontWeight.w600,
                //         ),
                //       ),
                //     );
                //   })
                //       .toList(),
                // ),
                const SizedBox(height: 16),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      order = value;
                    });
                  },
                  decoration: InputDecorationBuilder.buildInputDecoration(context, 'Заказ, строка'),
                  style: GoogleFonts.montserrat(
                    color: Colors.black87,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  keyboardType: TextInputType.number,
                  cursorColor: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      date = value;
                    });
                  },
                  decoration: InputDecorationBuilder.buildInputDecoration(context, 'Дата, timestamp'),
                  style: GoogleFonts.montserrat(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                  keyboardType: TextInputType.number,
                  cursorColor: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value;
                    });
                  },
                  decoration: InputDecorationBuilder.buildInputDecoration(context, 'Статус, строка'),
                  style: GoogleFonts.montserrat(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                  keyboardType: TextInputType.number,
                  cursorColor: Theme.of(context).primaryColor,
                ),



                const SizedBox(height: 16),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      cost = value;
                    });
                  },
                  decoration: InputDecorationBuilder.buildInputDecoration(context, 'Цена, BYN'),
                  style: GoogleFonts.montserrat(
                    color: Colors.black87,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  keyboardType: TextInputType.number,
                  cursorColor: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 16),
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
                    fontSize: 15,
                  ),
                  keyboardType: TextInputType.number,
                  cursorColor: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    // Обработайте данные по необходимости
                    print('Order num: $order');
                    print('Date: $date');
                    print('Selected Status: $selectedStatus');

                    //print('Selected Status: $selectedStatus');
                    print('Cost: $cost');
                    print('Weight: $weight');

                    await FirebaseFirestore.instance.collection('orders').add({
                      'amount': cost,
                      'date': date,
                      'number': order,
                      'state': selectedStatus,
                      'weight': weight,
                    });

                    Navigator.pop(context); // Закрыть диалог
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
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

 */
class _EditOrderDialogState extends State<EditOrderDialog> {
  String order = '';
  String date = '';
  String selectedStatus = '';
  String cost = '';
  String weight = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: 400, // Увеличил высоту, чтобы уместить StreamBuilder и другие виджеты
        width: 400,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Редактирование заказа',
                  style: GoogleFonts.montserrat(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      order = value;
                    });
                  },
                  decoration: InputDecorationBuilder.buildInputDecoration(context, 'Заказ, строка'),
                  style: GoogleFonts.montserrat(
                    color: Colors.black87,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  keyboardType: TextInputType.number,
                  cursorColor: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      date = value;
                    });
                  },
                  decoration: InputDecorationBuilder.buildInputDecoration(context, 'Дата, timestamp'),
                  style: GoogleFonts.montserrat(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                  keyboardType: TextInputType.number,
                  cursorColor: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value;
                    });
                  },
                  decoration: InputDecorationBuilder.buildInputDecoration(context, 'Статус, строка'),
                  style: GoogleFonts.montserrat(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                  keyboardType: TextInputType.number,
                  cursorColor: Theme.of(context).primaryColor,
                ),



                const SizedBox(height: 16),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      cost = value;
                    });
                  },
                  decoration: InputDecorationBuilder.buildInputDecoration(context, 'Цена, BYN'),
                  style: GoogleFonts.montserrat(
                    color: Colors.black87,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  keyboardType: TextInputType.number,
                  cursorColor: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 16),
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
                    fontSize: 15,
                  ),
                  keyboardType: TextInputType.number,
                  cursorColor: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    // Обработайте данные по необходимости
                    print('Order num: $order');
                    print('Date: $date');
                    print('Selected Status: $selectedStatus');

                    //print('Selected Status: $selectedStatus');
                    print('Cost: $cost');
                    print('Weight: $weight');

                    await FirebaseFirestore.instance.collection('orders').add({
                      'amount': cost,
                      'date': date,
                      'number': order,
                      'state': selectedStatus,
                      'weight': weight,
                    });

                    Navigator.pop(context); // Закрыть диалог
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
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