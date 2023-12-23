import 'package:csan/widgets/input_decoration_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// класс для создания нового заказа
class CreateOrderDialog extends StatefulWidget {
  const CreateOrderDialog({super.key});

  @override
  _CreateOrderDialogState createState() => _CreateOrderDialogState();
}

class _CreateOrderDialogState extends State<CreateOrderDialog> {

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
                buildCreateNewOrderHeader(context),
                // buildSetOrderStateField(context),
                buildSetCostsField(context),
                buildSetWeightField(context),
                buildSubmitButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // виджет для указания заголовка всплывающей формы (создание нового заказа)
  Widget buildCreateNewOrderHeader(BuildContext context) {
    return Column(
      children: [
        Text(
          'Создание нового заказа',
          style: GoogleFonts.montserrat(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // виджет редактирования состояния заказа
  Widget buildSetOrderStateField(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        DropdownButton<String>(
          value: state,
          onChanged: (value) {
            setState(() {
              state = value!;
            });
          },
          items: ['В обработке', 'Собран', 'Отправлен', 'В пункте выдачи', 'Доставлен', 'Отменен']
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
          }).toList(),
        ),
      ],
    );
  }

  // виджет задания стоимости заказа
  Widget buildSetCostsField(BuildContext context) {
    return Column(
      children: [
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
      ],
    );
  }

  // виджет задания веса заказа
  Widget buildSetWeightField(BuildContext context) {
    return Column(
      children: [
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
      ],
    );
  }

  // виджет кнопки для отправки формы нового заказа
  Widget buildSubmitButton(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
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
    );
  }
}

// класс для редактирования состояния заказа
class EditOrderDialog extends StatefulWidget {
  final String docID;

  const EditOrderDialog({required this.docID, super.key});

  @override
  _EditOrderDialogState createState() => _EditOrderDialogState();
}

class _EditOrderDialogState extends State<EditOrderDialog> {

  String state = 'В обработке';
  String amount = '';
  String weight = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: 370,
        width: 400,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildEditOrderHeader(context),
                buildSetOrderStateField(context),
                buildSetCostsField(context),
                buildSetWeightField(context),
                buildSubmitButton(context, widget.docID),
                buildDeleteButton(context, widget.docID),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // виджет для указания заголовка всплывающей формы (создание нового заказа)
  Widget buildEditOrderHeader(BuildContext context) {
    return Column(
      children: [
        Text(
          'Редактирование заказа',
          style: GoogleFonts.montserrat(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // виджет редактирования состояния заказа
  Widget buildSetOrderStateField(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        DropdownButton<String>(
          value: state,
          onChanged: (value) {
            setState(() {
              state = value!;
            });
          },
          items: ['В обработке', 'Собран', 'Отправлен', 'В пункте выдачи', 'Доставлен', 'Отменен']
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
          }).toList(),
        ),
      ],
    );
  }

  // виджет задания стоимости заказа
  Widget buildSetCostsField(BuildContext context) {
    return Column(
      children: [
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
      ],
    );
  }

  // виджет задания веса заказа
  Widget buildSetWeightField(BuildContext context) {
    return Column(
      children: [
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
      ],
    );
  }

  // виджет кнопки для отправки формы редактирования текущего заказа
  Widget buildSubmitButton(BuildContext context, String docID) {
    return Column(
      children: [
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            // Обновляем данные заказа по его ID
            await FirebaseFirestore.instance.collection('orders').doc(docID).update({
              'amount': amount,
              'date': DateFormat('dd.MM.yyyy | HH:mm:ss').format(DateTime.now()),
              'state': state,
              'weight': weight,
            });

            Navigator.pop(context); // Закрыть диалог
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black87,
            fixedSize: Size.fromWidth(MediaQuery.of(context).size.width),
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
    );
  }

  // виджет кнопки для отправки формы удаления текущего заказа
  Widget buildDeleteButton(BuildContext context, String docID) {
    return Column(
      children: [
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            // Удаляем заказ по его ID
            await FirebaseFirestore.instance.collection('orders').doc(docID).delete();

            Navigator.pop(context); // Закрыть диалог
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red, // Красный цвет для кнопки удаления
            fixedSize: Size.fromWidth(MediaQuery.of(context).size.width),
          ),
          child: Text(
            'УДАЛИТЬ ЗАКАЗ',
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

// класс только для редактирования состояния заказа
class EditOrderStateDialog extends StatefulWidget {
  final String docID;

  const EditOrderStateDialog({required this.docID, super.key});

  @override
  _EditOrderStateDialogState createState() => _EditOrderStateDialogState();
}

class _EditOrderStateDialogState extends State<EditOrderStateDialog> {

  String state = 'В обработке';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: 170,
        width: 400,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildEditOrderHeader(context),
                buildSetOrderStateField(context),
                buildSubmitButton(context, widget.docID),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // виджет для указания заголовка всплывающей формы (создание нового заказа)
  Widget buildEditOrderHeader(BuildContext context) {
    return Column(
      children: [
        Text(
          'Редактирование состояния заказа',
          style: GoogleFonts.montserrat(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // виджет редактирования состояния заказа
  Widget buildSetOrderStateField(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        DropdownButton<String>(
          value: state,
          onChanged: (value) {
            setState(() {
              state = value!;
            });
          },
          items: ['В обработке', 'Собран', 'Отправлен', 'В пункте выдачи', 'Доставлен', 'Отменен']
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
          }).toList(),
        ),
      ],
    );
  }

  // виджет кнопки для отправки формы редактирования состояния текущего заказа
  Widget buildSubmitButton(BuildContext context, String docID) {
    return Column(
      children: [
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            // Обновляем данные заказа по его ID
            await FirebaseFirestore.instance.collection('orders')
                .doc(docID)
                .update({
              'state': state,
            });

            Navigator.pop(context); // Закрыть диалог
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black87,
            fixedSize: Size.fromWidth(MediaQuery
                .of(context)
                .size
                .width),
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
    );
  }
}