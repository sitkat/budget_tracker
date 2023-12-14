import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';

import '../data/data_base_helper.dart';
import '../theme/app_colors.dart';
import '../theme/custom_app_bar.dart';


class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late String frenchMonth;
  double expenses = 0;
  double incomes = 0;
  double spending = 0;

  bool isIncomes = false;
  bool isSpending = false;

  late Future<Map<String, dynamic>> entriesFuture;

  Future<Map<String, dynamic>> loadEntriesFromDatabase() async {
    final database = await DatabaseHelper.instance.database;
    final results = await database.query('Expense');

    double totalIncomes = 0;
    double totalSpending = 0;
    final categoryCounts = <String, int>{};

    for (final entry in results) {
      final amount = entry['amount'] as double;
      final category = entry['category'] as String;

      categoryCounts[category] = (categoryCounts[category] ?? 0) + 1;

      if (amount > 0) {
        totalIncomes += amount;
      } else {
        totalSpending += amount;
      }
    }

    setState(() {
      incomes = totalIncomes;
      spending = totalSpending;
      expenses = totalIncomes - (-totalSpending);
    });

    return {
      'entries': results,
    };
  }

  @override
  void initState() {
    super.initState();
    entriesFuture = loadEntriesFromDatabase();
    initializeDateFormatting('fr_FR', null);
    frenchMonth = DateFormat('MMMM', 'fr_FR').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(context, 'Histoire'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                _buildContainer(
                  title: 'Dépenses',
                  value: expenses,
                  icon: Icons.arrow_forward_ios,
                  iconColor: Theme.of(context).primaryColor,
                  textColor: AppColors.grey,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: _buildCategoryIndicator(),
                ),
                const SizedBox(height: 15),
                _buildTwoContainers(
                  leftTitle: 'Revenus',
                  leftValue: incomes,
                  leftIcon: Icons.trending_up_outlined,
                  leftColor: Theme.of(context).canvasColor,
                  rightTitle: 'Dépenses',
                  rightValue: spending,
                  rightIcon: Icons.trending_down_outlined,
                  rightColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Expanded(
            child: Container(
              color: Theme.of(context).cardColor,
              child: FutureBuilder<Map<String, dynamic>>(
                future: entriesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No entries found.'),
                    );
                  } else {
                    final entries =
                        snapshot.data!['entries'] as List<Map<String, dynamic>>;

                    Map<String, List<Map<String, dynamic>>> groupedEntries = {};
                    for (final entry in entries) {
                      final date = entry['date'] as String;
                      groupedEntries.putIfAbsent(date, () => []);
                      groupedEntries[date]!.add(entry);
                    }
                    List<Widget> widgets = [];
                    groupedEntries.forEach((date, dateEntries) {
                      widgets.add(_buildDateHeader(date));
                      for (final entry in dateEntries) {
                        if (isIncomes == true && entry['amount'] > 0) {
                          widgets.add(_buildEntryWidget(entry));
                        } else if (isSpending == true && entry['amount'] < 0) {
                          widgets.add(_buildEntryWidget(entry));
                        }
                        if (isIncomes == false && isSpending == false) {
                          widgets.add(_buildEntryWidget(entry));
                        }
                      }
                    });
                    return ListView(
                      children: widgets,
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryIndicator() {
    final categoryColors = {
      'Food': const Color(0xffF18255),
      'Market': const Color(0xff55A6F1),
      'Travel': const Color(0xff8DDB69),
      'Financial operations': const Color(0xffDB6969),
      'Entertainment': const Color(0xffB069DB),
      'Other': const Color(0xff69D4DB),
    };

    return Container(
      height: 12.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categoryColors.length,
        itemBuilder: (context, index) {
          final category = categoryColors.keys.elementAt(index);
          final color = categoryColors[category];
          return Container(
            width: MediaQuery.of(context).size.width / categoryColors.length,
            color: color,
          );
        },
      ),
    );
  }

  Widget _buildEntryWidget(Map<String, dynamic> entry) {
    final place = entry['place'];
    final category = entry['category'];
    final amount = entry['amount'];
    String imagePath;
    if (category == 'Food') {
      imagePath = 'assets/icons/icon_food.png';
    } else if (category == 'Market') {
      imagePath = 'assets/icons/icon_market.png';
    } else if (category == 'Travel') {
      imagePath = 'assets/icons/icon_travel.png';
    } else if (category == 'Financial operations') {
      imagePath = 'assets/icons/icon_operations.png';
    } else if (category == 'Entertainment') {
      imagePath = 'assets/icons/icon_entertainment.png';
    } else if (category == 'Other') {
      imagePath = 'assets/icons/icon_other.png';
    } else {
      imagePath = 'assets/icons/icon_other.png';
    }

    return ListTile(
      leading: Image.asset(
        imagePath,
        width: 46,
        height: 48,
      ),
      title: Text(
        '$place',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        '$category',
        style: const TextStyle(color: AppColors.grey, fontSize: 12),
      ),
      trailing: Text(
        '${amount > 0 ? '+' : ''}$amount\$',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: amount > 0
              ? Theme.of(context).canvasColor
              : Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildDateHeader(String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Text(
        date,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.grey,
        ),
      ),
    );
  }

  Widget _buildContainer({
    required String title,
    required double value,
    required IconData icon,
    required Color iconColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$title dans ${_capitalizeFirstLetter(frenchMonth)}',
                style: TextStyle(fontSize: 14, color: textColor),
              ),
              _buildDetailsRow(icon: icon, iconColor: iconColor),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            '$value\$',
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsRow({required IconData icon, required Color iconColor}) {
    return Row(
      children: [
        Text(
          'Détails',
          style: TextStyle(fontSize: 14, color: Theme.of(context).primaryColor),
        ),
        const SizedBox(width: 5),
        Icon(
          icon,
          color: iconColor,
          size: 12,
        ),
      ],
    );
  }

  Widget _buildTwoContainers({
    required String leftTitle,
    required double leftValue,
    required IconData leftIcon,
    required Color leftColor,
    required String rightTitle,
    required double rightValue,
    required IconData rightIcon,
    required Color rightColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildExpandedContainer(
            title: leftTitle,
            value: leftValue,
            icon: leftIcon,
            color: leftColor),
        const SizedBox(width: 15),
        _buildExpandedContainer(
            title: rightTitle,
            value: rightValue,
            icon: rightIcon,
            color: rightColor),
      ],
    );
  }

  Widget _buildExpandedContainer({
    required String title,
    required double value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if ((title == 'Revenus' && isIncomes == true) ||
              (title == 'Dépenses' && isSpending == true)) {
            setState(() {
              isIncomes = false;
              isSpending = false;
            });
          } else if (title == 'Revenus' && isIncomes == false) {
            setState(() {
              isIncomes = true;
              isSpending = false;
            });
          } else if (title == 'Dépenses' && isSpending == false) {
            setState(() {
              isIncomes = false;
              isSpending = true;
            });
          } else {}
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).cardColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 14, color: AppColors.grey),
                  ),
                  Icon(
                    icon,
                    color: color,
                    size: 18,
                  ),
                ],
              ),
              const SizedBox(height: 15),
              title == 'Revenus'
                  ? Text(
                      '${value > 0 ? '+' : ''}$value\$',
                      style: TextStyle(
                          fontSize: 20,
                          color: color,
                          fontWeight: FontWeight.bold),
                    )
                  : Text(
                      '${value > 0 ? '-' : ''}$value\$',
                      style: TextStyle(
                          fontSize: 20,
                          color: color,
                          fontWeight: FontWeight.bold),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  String _capitalizeFirstLetter(String text) {
    return text.substring(0, 1).toUpperCase() + text.substring(1);
  }
}
