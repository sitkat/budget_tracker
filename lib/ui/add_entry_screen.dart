import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/data_base_helper.dart';
import '../theme/app_colors.dart';
import 'navigation_screen.dart';


class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({Key? key}) : super(key: key);

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final controllerAmount = TextEditingController();
  final controllerPlace = TextEditingController();
  final controllerDate = TextEditingController();
  final controllerNote = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool isIncomes = true;

  double sum = 0.0;

  String selectedCategory = '';
  List<String> categories = [];

  @override
  void initState() {
    super.initState();

    controllerAmount.addListener(() {
      setState(() {});
    });
    fetchCategories();
  }

  Future<void> saveEntryToDatabase() async {
    final database = await DatabaseHelper.instance.database;

    var sum = controllerAmount.text;
    if (isIncomes)
      {
        sum = '+${controllerAmount.text}';
      } else{
      sum = '-${controllerAmount.text}';
    }

    final amount = double.tryParse(sum) ?? 0.0;
    final place = controllerPlace.text;
    final category = selectedCategory;
    final date = controllerDate.text;
    final note = controllerNote.text;

    await database.insert('Expense', {
      'amount': amount,
      'place': place,
      'category': category,
      'date': date,
      'note': note,
    });
  }

  Future<void> fetchCategories() async {
    final database = await DatabaseHelper.instance.database;
    final results = await database.query('Category');
    final categoryNames = results.map((row) => row['name'] as String).toList();

    setState(() {
      categories = categoryNames;
      if (categories.isNotEmpty) {
        selectedCategory = categories.first;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: CupertinoNavigationBarBackButton(
            color: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NavigationScreen(),
                ),
              );
            },
          ),
          title: Text(
            'Entrée',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.keyboard_arrow_down,
                size: 30,
                color: AppColors.accent,
              ),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NavigationScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).cardColor,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (isIncomes == false) {
                            setState(() {
                              isIncomes = !isIncomes;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: isIncomes
                                ? Theme.of(context).dividerColor
                                : Colors.transparent,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Revenus',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (isIncomes == true) {
                            setState(() {
                              isIncomes = !isIncomes;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: isIncomes
                                ? Colors.transparent
                                : Theme.of(context).dividerColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Dépenses',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).cardColor,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${controllerAmount.text.isNotEmpty ? (isIncomes ? '+' : '-') : ''}'
                              + '${controllerAmount.text.isNotEmpty ? controllerAmount.text + '\$' : ''}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: isIncomes
                                  ? Theme.of(context).canvasColor
                                  : Theme.of(context).primaryColor),
                        ),
                        AppTextField(
                          controller: controllerAmount,
                          labelText: 'Entrer le montant',
                          keyboardType: TextInputType.number,
                        ),
                        AppTextField(
                          controller: controllerPlace,
                          labelText: 'Lieu',
                        ),
                        AppDropDownField(
                          labelText: 'Catégorie',
                          categories: categories,
                          onChanged: (value) {
                            setState(() {
                              selectedCategory = value!;
                            });
                          },
                        ),
                        AppTextField(
                          controller: controllerDate,
                          labelText: 'Date',
                          keyboardType: TextInputType.datetime,
                        ),
                        AppTextField(
                          controller: controllerNote,
                          labelText: 'Note',
                        ),
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () async{
                                if (formKey.currentState?.validate() != true)
                                  {return;} else{
                                  await saveEntryToDatabase();
                                  controllerAmount.clear();
                                  controllerPlace.clear();
                                  controllerDate.clear();
                                  controllerNote.clear();
                                  if (categories.isNotEmpty) {
                                    selectedCategory = categories.first;
                                  }
                                  setState(() {});
                                }

                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: AppColors.accent,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 60, vertical: 8),
                                  child: Text(
                                    'Faire une entrée',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppDropDownField extends StatelessWidget {
  final String labelText;
  final List<String>? categories;
  final ValueChanged<String?>? onChanged;

  AppDropDownField({
    Key? key,
    required this.labelText,
    this.categories,
    this.onChanged,
  }) : super(key: key);

  TextEditingController controllerCategory = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controllerCategory.text = 'Catégorie';
    return Row(
      children: [
        Expanded(
          child: TextField(
            canRequestFocus: false,
            readOnly: true,
            controller: controllerCategory,
            style: TextStyle(color: AppColors.inout, fontSize: 14),
            decoration:  InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.inout),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.inout),
              ),
            ),
          ),
        ),
        Expanded(
          child: categories != null
              ? DropdownButtonFormField<String>(
            style: TextStyle(color: Theme.of(context).primaryColor),
            value: categories!.isNotEmpty ? categories!.first : null,
            onChanged: onChanged,
            items: categories!
                .map<DropdownMenuItem<String>>((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
            decoration: InputDecoration(
              labelStyle: TextStyle(color: Theme.of(context).primaryColor),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.inout),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.inout),
              ),
            ),
          )
              : CircularProgressIndicator(),
        ),
      ],
    );
  }
}

class AppTextField extends StatelessWidget {
  const AppTextField(
      {required this.controller,
      required this.labelText,
      this.keyboardType = TextInputType.text})
      : super();

  final TextEditingController controller;
  final String labelText;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        TextFormField(
          onTap: () {
            if (keyboardType == TextInputType.datetime) {
              _selectDate(context);
            }
          },
          controller: controller,
          textDirection: TextDirection.rtl,
          keyboardType: keyboardType,
          validator: validator,
          maxLines: 1,
          style: TextStyle(color: Theme.of(context).primaryColor),
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.inout),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.inout),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(right: 12.0),
          child: Text(
            labelText,
            style: const TextStyle(color: AppColors.inout),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != controller.text) {
      final formattedDate =
          "${picked.year}.${picked.month.toString().padLeft(2, '0')}.${picked.day.toString().padLeft(2, '0')}";
      controller.text = formattedDate;
    }
  }

  String? validator(String? value) {
    if (value?.isEmpty == true) {
      return "Обязательное поле";
    }
    if (keyboardType == TextInputType.number) {
      final regexNumber =
      RegExp(r'^[0-9,]*$');
      if (!regexNumber.hasMatch(value!)) {
        return "Поле может содержать только цифры и ,";
      }
    }
    if (labelText == "Логин") {
      final regexLogin =
          RegExp(r'^(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$');
      if (!regexLogin.hasMatch(value!)) {
        return "Поле может содержать только латиницу и цифры";
      }
    }
    return null;
  }
}
