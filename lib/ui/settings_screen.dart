import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/app_colors.dart';
import '../theme/app_custom_icon_accent.dart';
import '../theme/custom_app_bar.dart';
import '../theme/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool val1 = true;
  bool val2 = false;

  void onChangeFunctionVal1(bool newValue) {
    setState(() {
      val1 = newValue;
    });
  }

  void onChangeFunctionVal2(bool newValue) {
    setState(() {
      final provider = Provider.of<ThemeProvider>(context, listen: false);
      provider.toggleTheme(newValue);
      val2 = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(context, 'Paramètres'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            _buildSubscriptionCard(),
            const SizedBox(height: 20),
            _buildOptionsContainer([
              buildAccountOption(
                  context, Icons.monetization_on, 'Devise', 'USD', true),
              buildAccountOption(
                  context, Icons.safety_check, 'Sécurité', '', true),
              buildNotificationOption(Icons.notifications, 'Notification', val1,
                  onChangeFunctionVal1),
              buildTransformOption(
                  Icons.dark_mode, 'Thème sombre', val2, onChangeFunctionVal2),
            ]),
            const SizedBox(height: 20),
            _buildOptionsContainer([
              buildAccountOption(context, Icons.star, 'Application de taux', '', false),
              buildAccountOption(
                  context, Icons.mail, 'Écrire aux développeurs', '', false),
              buildAccountOption(
                  context, Icons.description, 'Politique de confidentialité', '', false),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsContainer(List<Widget> options) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor,
      ),
      child: Column(children: options),
    );
  }

  GestureDetector buildAccountOption(BuildContext context, IconData icon,
      String title, String subtitle, bool isIconArrow) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CustomIconAccent(icon: icon),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 16, color: Theme.of(context).primaryColor),
                ),
              ],
            ),
            Row(
              children: [
                Text(subtitle, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                if (isIconArrow == true)
                  const Icon(Icons.arrow_forward_ios, color: AppColors.grey)
                else
                  const SizedBox.shrink(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTransformOption(
      IconData icon, String title, bool value, Function onChangedMethod) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CustomIconAccent(icon: icon),
              const SizedBox(width: 8),
              Text(title,
                  style: TextStyle(
                      fontSize: 16, color: Theme.of(context).primaryColor)),
            ],
          ),
          Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              activeColor: Colors.blue,
              trackColor: Colors.grey,
              value: themeProvider.isDarkMode,
              onChanged: (bool newValue) {
                onChangedMethod(newValue);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget buildNotificationOption(
      IconData icon, String title, bool value, Function onChangedMethod) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CustomIconAccent(icon: icon),
              const SizedBox(width: 8),
              Text(title,
                  style: TextStyle(
                      fontSize: 16, color: Theme.of(context).primaryColor)),
            ],
          ),
          Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              activeColor: Colors.blue,
              trackColor: Colors.grey,
              value: value,
              onChanged: (bool newValue) {
                onChangedMethod(newValue);
              },
            ),
          )
        ],
      ),
    );
  }


  Widget _buildSubscriptionCard() {
    return Card(
      color: AppColors.accent,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ListTile(
          title: Text(
            'Abonnement',
            maxLines: 1,
            style: TextStyle(
                fontSize: 24,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w400),
          ),
          subtitle: Text(
            'Gardez votre budget aussi efficace \nque possible grâce au libre accès',
            maxLines: 2,
            style:
                TextStyle(color: Theme.of(context).primaryColor, fontSize: 12),
          ),
          trailing: Column(
            children: [
              _buildSubscriptionPrice(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubscriptionPrice() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.black,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: const Text(
        '12\$/mois',
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}
